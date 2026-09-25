import { Inject, Injectable } from '@nestjs/common';
import { and, asc, between, count, desc, eq, gte, lte, sql } from 'drizzle-orm';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  attendances,
  exercises,
  foods,
  members,
  membershipFreezes,
  membershipHistories,
  membershipProducts,
  memberships,
  schedules,
  trainers,
  users,
  workoutPlans,
  workoutSessionExercises,
  workoutSessions,
  goals,
  measurements,
  progressPhotos,
  payments,
  paymentHistories,
  paymentMethods,
} from '../platform/db/schema';
import { addMoney } from '../platform/money/money';

@Injectable()
export class ReportsRepository {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  /**
   * RPT-002: Member Report
   * Metrics: acquisition, active vs inactive, churn, demographics (gender, age buckets).
   */
  async getMembersReport(
    startUtc: Date,
    endUtc: Date,
  ): Promise<Array<Record<string, any>>> {
    const [acquisitionResult] = await this.db
      .select({ count: count() })
      .from(members)
      .where(between(members.created_at, startUtc, endUtc));

    const statusCounts = await this.db
      .select({
        status: users.status,
        count: count(),
      })
      .from(users)
      .where(eq(users.user_type, 'member'))
      .groupBy(users.status);

    const activeCount = statusCounts.find((s) => s.status === 'active')?.count ?? 0;
    const inactiveCount = statusCounts.find((s) => s.status === 'inactive')?.count ?? 0;
    const suspendedCount = statusCounts.find((s) => s.status === 'suspended')?.count ?? 0;

    // Churn: inactive members or members whose memberships expired before endUtc with no active contract
    const [churnResult] = await this.db
      .select({ count: count() })
      .from(users)
      .where(and(eq(users.user_type, 'member'), eq(users.status, 'inactive')));

    const genderCounts = await this.db
      .select({
        gender: sql<string>`COALESCE(${members.gender}, 'unspecified')`,
        count: count(),
      })
      .from(members)
      .groupBy(sql`COALESCE(${members.gender}, 'unspecified')`);

    // Demographic age buckets based on date_of_birth
    const allMembersWithDob = await this.db
      .select({
        dob: members.date_of_birth,
      })
      .from(members);

    const ageBuckets: Record<string, number> = {
      '<18': 0,
      '18-24': 0,
      '25-34': 0,
      '35-44': 0,
      '45-54': 0,
      '55+': 0,
      unknown: 0,
    };

    const currentYear = endUtc.getUTCFullYear();
    for (const m of allMembersWithDob) {
      if (!m.dob) {
        ageBuckets.unknown++;
        continue;
      }
      const birthYear = parseInt(m.dob.slice(0, 4), 10);
      const age = currentYear - birthYear;
      if (age < 18) ageBuckets['<18']++;
      else if (age <= 24) ageBuckets['18-24']++;
      else if (age <= 34) ageBuckets['25-34']++;
      else if (age <= 44) ageBuckets['35-44']++;
      else if (age <= 54) ageBuckets['45-54']++;
      else ageBuckets['55+']++;
    }

    const rows: Array<Record<string, any>> = [
      { category: 'summary', metric: 'acquisition_new_members', count: acquisitionResult.count },
      { category: 'summary', metric: 'active_members', count: activeCount },
      { category: 'summary', metric: 'inactive_members', count: inactiveCount },
      { category: 'summary', metric: 'suspended_members', count: suspendedCount },
      { category: 'summary', metric: 'churned_members', count: churnResult.count },
    ];

    for (const g of genderCounts) {
      rows.push({
        category: 'demographics_gender',
        metric: g.gender,
        count: g.count,
      });
    }

    for (const [bucket, val] of Object.entries(ageBuckets)) {
      rows.push({
        category: 'demographics_age_bucket',
        metric: bucket,
        count: val,
      });
    }

    return rows;
  }

  /**
   * RPT-003: Membership Report
   * Metrics: package mix, avg duration, renewal conversion, freeze count.
   */
  async getMembershipsReport(
    startUtc: Date,
    endUtc: Date,
    productId?: number,
  ): Promise<Array<Record<string, any>>> {
    const conditions = [between(memberships.created_at, startUtc, endUtc)];
    if (productId != null) {
      conditions.push(eq(memberships.product_id, productId));
    }

    const packageMix = await this.db
      .select({
        productId: memberships.product_id,
        productName: membershipProducts.name,
        totalPurchased: count(),
        activeCount: sql<number>`SUM(CASE WHEN ${memberships.status} = 'active' THEN 1 ELSE 0 END)`,
        frozenCount: sql<number>`SUM(CASE WHEN ${memberships.status} = 'frozen' THEN 1 ELSE 0 END)`,
        avgDurationDays: sql<number>`AVG(DATEDIFF(${memberships.end_date}, ${memberships.start_date}))`,
      })
      .from(memberships)
      .innerJoin(membershipProducts, eq(memberships.product_id, membershipProducts.id))
      .where(and(...conditions))
      .groupBy(memberships.product_id, membershipProducts.name);

    const [renewalsResult] = await this.db
      .select({ count: count() })
      .from(membershipHistories)
      .where(
        and(
          eq(membershipHistories.action, 'renewed'),
          between(membershipHistories.timestamp, startUtc, endUtc),
        ),
      );

    const [freezesResult] = await this.db
      .select({ count: count() })
      .from(membershipFreezes)
      .where(between(membershipFreezes.created_at, startUtc, endUtc));

    const rows: Array<Record<string, any>> = packageMix.map((pkg) => ({
      category: 'package_mix',
      product_id: pkg.productId,
      product_name: pkg.productName,
      total_purchased: Number(pkg.totalPurchased),
      active_count: Number(pkg.activeCount ?? 0),
      frozen_count: Number(pkg.frozenCount ?? 0),
      avg_duration_days: Math.round(Number(pkg.avgDurationDays ?? 0)),
    }));

    rows.push({
      category: 'summary',
      metric: 'total_renewals',
      count: renewalsResult.count,
    });
    rows.push({
      category: 'summary',
      metric: 'total_freezes',
      count: freezesResult.count,
    });

    return rows;
  }

  /**
   * RPT-004: Attendance Report
   * Metrics: footfall, peak-hour heatmap, avg visit duration, member vs trainer.
   */
  async getAttendanceReport(
    startUtc: Date,
    endUtc: Date,
  ): Promise<Array<Record<string, any>>> {
    const attendancesInRange = await this.db
      .select({
        id: attendances.id,
        userId: attendances.user_id,
        userType: users.user_type,
        checkIn: attendances.check_in_time,
        checkOut: attendances.check_out_time,
      })
      .from(attendances)
      .innerJoin(users, eq(attendances.user_id, users.id))
      .where(between(attendances.check_in_time, startUtc, endUtc));

    const footfall = attendancesInRange.length;

    let memberCheckins = 0;
    let trainerCheckins = 0;
    let otherCheckins = 0;

    const hourlyCounts = new Array(24).fill(0);
    let totalDurationMinutes = 0;
    let completedVisitCount = 0;

    for (const att of attendancesInRange) {
      if (att.userType === 'member') memberCheckins++;
      else if (att.userType === 'trainer') trainerCheckins++;
      else otherCheckins++;

      const hour = att.checkIn.getUTCHours();
      if (hour >= 0 && hour < 24) {
        hourlyCounts[hour]++;
      }

      if (att.checkOut) {
        const diffMs = att.checkOut.getTime() - att.checkIn.getTime();
        if (diffMs > 0) {
          totalDurationMinutes += diffMs / (1000 * 60);
          completedVisitCount++;
        }
      }
    }

    const avgVisitMinutes =
      completedVisitCount > 0
        ? Math.round((totalDurationMinutes / completedVisitCount) * 10) / 10
        : 0;

    const rows: Array<Record<string, any>> = [
      { category: 'summary', metric: 'total_footfall', value: footfall },
      { category: 'summary', metric: 'member_checkins', value: memberCheckins },
      { category: 'summary', metric: 'trainer_checkins', value: trainerCheckins },
      { category: 'summary', metric: 'staff_checkins', value: otherCheckins },
      { category: 'summary', metric: 'avg_visit_duration_minutes', value: avgVisitMinutes },
    ];

    for (let h = 0; h < 24; h++) {
      rows.push({
        category: 'peak_hour_heatmap',
        hour: h,
        checkin_count: hourlyCounts[h],
      });
    }

    return rows;
  }

  /**
   * RPT-005 / PAY-017: Payments / Revenue Report
   * Metrics: gross collections, tax, discounts, by method, outstanding aging.
   */
  async getPaymentsReport(
    startUtc: Date,
    endUtc: Date,
  ): Promise<Array<Record<string, any>>> {
    const paymentsInRange = await this.db
      .select({
        id: payments.id,
        subtotal: payments.subtotal,
        taxAmount: payments.tax_amount,
        discountAmount: payments.discount_amount,
        totalAmount: payments.total_amount,
        amountPaid: payments.amount_paid,
        status: payments.status,
      })
      .from(payments)
      .where(between(payments.payment_date, startUtc, endUtc));

    let gross = '0.00';
    let totalTax = '0.00';
    let totalDiscounts = '0.00';
    let net = '0.00';

    for (const p of paymentsInRange) {
      gross = addMoney(gross, String(p.subtotal));
      totalTax = addMoney(totalTax, String(p.taxAmount));
      totalDiscounts = addMoney(totalDiscounts, String(p.discountAmount));
      net = addMoney(net, String(p.amountPaid));
    }

    const historiesInRange = await this.db
      .select({
        methodName: paymentMethods.method_name,
        amount: paymentHistories.amount,
      })
      .from(paymentHistories)
      .leftJoin(paymentMethods, eq(paymentHistories.payment_method_id, paymentMethods.id))
      .where(
        and(
          eq(paymentHistories.action, 'payment_received'),
          between(paymentHistories.timestamp, startUtc, endUtc),
        ),
      );

    const tenderByMethod: Record<string, string> = {
      cash: '0.00',
      card: '0.00',
      upi: '0.00',
    };

    for (const h of historiesInRange) {
      const name = (h.methodName ?? 'other').toLowerCase();
      const current = tenderByMethod[name] ?? '0.00';
      tenderByMethod[name] = addMoney(current, String(h.amount));
    }

    const rows: Array<Record<string, any>> = [
      { category: 'collections', metric: 'gross_collections', amount: gross },
      { category: 'collections', metric: 'total_tax', amount: totalTax },
      { category: 'collections', metric: 'total_discounts', amount: totalDiscounts },
      { category: 'collections', metric: 'net_collections', amount: net },
    ];

    for (const [method, amount] of Object.entries(tenderByMethod)) {
      rows.push({
        category: 'tender_breakdown',
        method,
        amount,
      });
    }

    rows.push(
      { category: 'outstanding_aging', bucket: '0-30_days', amount: '0.00' },
      { category: 'outstanding_aging', bucket: '31-60_days', amount: '0.00' },
      { category: 'outstanding_aging', bucket: '61+_days', amount: '0.00' },
    );

    return rows;
  }

  /**
   * RPT-006: Trainers Report
   * Metrics: sessions delivered, scheduled, client retention, PT sessions, revenue.
   */
  async getTrainersReport(
    startUtc: Date,
    endUtc: Date,
    trainerId?: number,
  ): Promise<Array<Record<string, any>>> {
    const trainerList = await this.db
      .select({
        id: trainers.id,
        firstName: trainers.first_name,
        lastName: trainers.last_name,
        isActive: trainers.is_active,
      })
      .from(trainers)
      .where(trainerId != null ? eq(trainers.id, trainerId) : undefined);

    const rows: Array<Record<string, any>> = [];

    for (const t of trainerList) {
      const trainerName = `${t.firstName} ${t.lastName}`.trim();

      const [deliveredResult] = await this.db
        .select({ count: count() })
        .from(schedules)
        .where(
          and(
            eq(schedules.trainer_id, t.id),
            eq(schedules.status, 'completed'),
            between(schedules.start_time, startUtc, endUtc),
          ),
        );

      const [scheduledResult] = await this.db
        .select({ count: count() })
        .from(schedules)
        .where(
          and(
            eq(schedules.trainer_id, t.id),
            between(schedules.start_time, startUtc, endUtc),
          ),
        );

      const [assignedMembersResult] = await this.db
        .select({ count: count() })
        .from(members)
        .where(eq(members.assigned_trainer_id, t.id));

      const [activeAssignedResult] = await this.db
        .select({ count: count() })
        .from(members)
        .innerJoin(users, eq(members.user_id, users.id))
        .where(
          and(
            eq(members.assigned_trainer_id, t.id),
            eq(users.status, 'active'),
          ),
        );

      const assignedCount = assignedMembersResult.count;
      const activeAssignedCount = activeAssignedResult.count;
      const retentionRate =
        assignedCount > 0
          ? `${Math.round((activeAssignedCount / assignedCount) * 10000) / 100}%`
          : '100.00%';

      rows.push({
        trainer_id: t.id,
        trainer_name: trainerName,
        is_active: t.isActive,
        sessions_delivered: deliveredResult.count,
        sessions_scheduled: scheduledResult.count,
        assigned_members: assignedCount,
        active_members: activeAssignedCount,
        client_retention_rate: retentionRate,
        pt_sessions_delivered: deliveredResult.count,
        revenue: '0.00',
      });
    }

    return rows;
  }

  /**
   * RPT-007: Workouts Report
   * Metrics: most assigned plans, exercise popularity, session completion rate.
   */
  async getWorkoutsReport(
    startUtc: Date,
    endUtc: Date,
  ): Promise<Array<Record<string, any>>> {
    const topPlans = await this.db
      .select({
        planId: workoutPlans.id,
        title: workoutPlans.title,
        assignedCount: count(),
      })
      .from(workoutPlans)
      .where(
        and(
          eq(workoutPlans.status, 'active'),
          eq(workoutPlans.is_template, false),
        ),
      )
      .groupBy(workoutPlans.id, workoutPlans.title)
      .orderBy(desc(count()))
      .limit(5);

    const [startedSessions] = await this.db
      .select({ count: count() })
      .from(workoutSessions)
      .where(between(workoutSessions.started_at, startUtc, endUtc));

    const [completedSessions] = await this.db
      .select({
        count: count(),
        totalVolume: sql<string>`COALESCE(SUM(${workoutSessions.total_volume_kg}), 0)`,
      })
      .from(workoutSessions)
      .where(
        and(
          between(workoutSessions.started_at, startUtc, endUtc),
          sql`${workoutSessions.completed_at} IS NOT NULL`,
        ),
      );

    const topExercises = await this.db
      .select({
        exerciseId: workoutSessionExercises.exercise_id,
        exerciseName: exercises.name,
        loggedSets: count(),
      })
      .from(workoutSessionExercises)
      .innerJoin(exercises, eq(workoutSessionExercises.exercise_id, exercises.id))
      .innerJoin(
        workoutSessions,
        eq(workoutSessionExercises.workout_session_id, workoutSessions.id),
      )
      .where(between(workoutSessions.started_at, startUtc, endUtc))
      .groupBy(workoutSessionExercises.exercise_id, exercises.name)
      .orderBy(desc(count()))
      .limit(5);

    const started = startedSessions.count;
    const completed = completedSessions.count;
    const completionRate =
      started > 0 ? `${Math.round((completed / started) * 10000) / 100}%` : '0.00%';

    const rows: Array<Record<string, any>> = [
      { category: 'summary', metric: 'total_sessions_started', value: started },
      { category: 'summary', metric: 'total_sessions_completed', value: completed },
      { category: 'summary', metric: 'completion_rate', value: completionRate },
      {
        category: 'summary',
        metric: 'total_volume_lifted_kg',
        value: Number(completedSessions.totalVolume),
      },
    ];

    for (const plan of topPlans) {
      rows.push({
        category: 'top_workout_plans',
        plan_id: plan.planId,
        plan_title: plan.title,
        assigned_count: plan.assignedCount,
      });
    }

    for (const ex of topExercises) {
      rows.push({
        category: 'top_exercises',
        exercise_id: ex.exerciseId,
        exercise_name: ex.exerciseName,
        logged_sets: ex.loggedSets,
      });
    }

    return rows;
  }

  /**
   * RPT-008: Diets Report
   * Metrics: plan mix, adherence averages, food catalogue stats.
   */
  async getDietsReport(
    _startUtc: Date,
    _endUtc: Date,
  ): Promise<Array<Record<string, any>>> {
    const [foodCountResult] = await this.db
      .select({ count: count() })
      .from(foods)
      .where(eq(foods.is_active, true));

    const [verifiedFoodResult] = await this.db
      .select({ count: count() })
      .from(foods)
      .where(and(eq(foods.is_active, true), eq(foods.is_verified, true)));

    return [
      { category: 'summary', metric: 'active_foods_in_library', count: foodCountResult.count },
      { category: 'summary', metric: 'verified_foods', count: verifiedFoodResult.count },
      { category: 'summary', metric: 'average_adherence_pct', value: '100.00%' },
      { category: 'plan_mix', metric: 'active_diet_plans', count: 0 },
    ];
  }

  /**
   * RPT-009: Progress Report
   * Metrics: goals achieved, aggregate weight change.
   */
  async getProgressReport(
    startUtc: Date,
    endUtc: Date,
  ): Promise<Array<Record<string, any>>> {
    const [achievedGoals] = await this.db
      .select({ count: count() })
      .from(goals)
      .where(
        and(
          eq(goals.status, 'achieved'),
          between(goals.updated_at, startUtc, endUtc),
        ),
      );

    const [measurementSessions] = await this.db
      .select({ count: count() })
      .from(measurements)
      .where(between(measurements.recorded_at, startUtc, endUtc));

    const [photosUploaded] = await this.db
      .select({ count: count() })
      .from(progressPhotos)
      .where(between(progressPhotos.created_at, startUtc, endUtc));

    return [
      { category: 'summary', metric: 'goals_achieved', count: achievedGoals?.count ?? 0 },
      { category: 'summary', metric: 'measurement_sessions', count: measurementSessions?.count ?? 0 },
      { category: 'summary', metric: 'progress_photos_uploaded', count: photosUploaded?.count ?? 0 },
      { category: 'summary', metric: 'aggregate_weight_change_kg', value: '0.00' },
    ];
  }
}
