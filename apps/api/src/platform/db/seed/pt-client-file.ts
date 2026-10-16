import { eq } from 'drizzle-orm';
import type { DrizzleDb } from '../client';
import { users } from '../schema/users';
import { members } from '../schema/members';
import { trainers } from '../schema/trainers';
import { parQScreenings } from '../schema/par-q';
import { memberLifestyleIntakes } from '../schema/lifestyle-intake';
import { ptProgressReviews } from '../schema/personal-training';

/**
 * Seeds sample records for the PT client file module:
 * - 1 PAR-Q+ screening for the demo member (clearance passed)
 * - 1 Member lifestyle intake (activity, sleep, stress, habits, 4 priorities)
 * - 1 PT progress review (baseline -> current snapshot delta, badges, checklist)
 *
 * Safe to re-run idempotently.
 */
export async function seedPtClientFile(db: DrizzleDb<any>): Promise<{
  parQSeeded: boolean;
  lifestyleSeeded: boolean;
  reviewSeeded: boolean;
}> {
  const now = new Date();

  // Find demo member and trainer
  const allUsers = await db.select().from(users);
  const memberUser = allUsers.find((u) => u.email === 'member' && u.user_type === 'member');
  const trainerUser = allUsers.find((u) => u.email === 'trainer' && u.user_type === 'trainer');

  let memberId: number | null = null;
  if (memberUser) {
    const memRows = await db
      .select({ id: members.id })
      .from(members)
      .where(eq(members.user_id, memberUser.id))
      .limit(1);
    memberId = memRows[0]?.id ? Number(memRows[0].id) : null;
  }

  // Fallback to first member in DB if demo user member isn't found
  if (!memberId) {
    const firstMember = await db.select({ id: members.id }).from(members).limit(1);
    memberId = firstMember[0]?.id ? Number(firstMember[0].id) : null;
  }

  let trainerId: number | null = null;
  let trainerUserId: number | null = trainerUser ? Number(trainerUser.id) : null;
  if (trainerUser) {
    const trnRows = await db
      .select({ id: trainers.id })
      .from(trainers)
      .where(eq(trainers.user_id, trainerUser.id))
      .limit(1);
    trainerId = trnRows[0]?.id ? Number(trnRows[0].id) : null;
  }

  if (!trainerId) {
    const firstTrainer = await db
      .select({ id: trainers.id, user_id: trainers.user_id })
      .from(trainers)
      .limit(1);
    trainerId = firstTrainer[0]?.id ? Number(firstTrainer[0].id) : null;
    if (firstTrainer[0]?.user_id && !trainerUserId) {
      trainerUserId = Number(firstTrainer[0].user_id);
    }
  }

  if (!memberId) {
    console.warn('[Seed PtClientFile] No member found to attach seed records. Skipping.');
    return { parQSeeded: false, lifestyleSeeded: false, reviewSeeded: false };
  }

  let parQSeeded = false;
  let lifestyleSeeded = false;
  let reviewSeeded = false;

  // 1. Seed PAR-Q+ Screening
  const existingParQ = await db
    .select({ id: parQScreenings.id })
    .from(parQScreenings)
    .where(eq(parQScreenings.member_id, memberId))
    .limit(1);

  if (!existingParQ[0]) {
    await db.insert(parQScreenings).values({
      member_id: memberId,
      version: '2024.1',
      q1_heart_condition: false,
      q2_chest_pain_activity: false,
      q3_chest_pain_rest: false,
      q4_dizziness_consciousness: false,
      q5_bone_joint_problem: false,
      q6_medication_condition: false,
      q7_other_reason: false,
      has_positive_answer: false,
      trainer_screening_notes: 'Client completed initial health intake without restrictions.',
      referral_required: false,
      declaration_accepted: true,
      client_signed_at: now,
      trainer_signed_at: now,
      trainer_user_id: trainerUserId,
      clearance_status: 'passed',
      cleared_at: now,
      cleared_by_user_id: trainerUserId,
      created_at: now,
      updated_at: now,
    });
    parQSeeded = true;
  }

  // 2. Seed Lifestyle Intake
  const existingLifestyle = await db
    .select({ id: memberLifestyleIntakes.id })
    .from(memberLifestyleIntakes)
    .where(eq(memberLifestyleIntakes.member_id, memberId))
    .limit(1);

  if (!existingLifestyle[0]) {
    await db.insert(memberLifestyleIntakes).values({
      member_id: memberId,
      activity_level: 'moderate',
      training_history: '1-2 years sporadic gym attendance, looking for structured progression.',
      current_pain_discomfort: 'Occasional mild lower back stiffness after prolonged seated desk work.',
      sleep_hours_typical: '7.5',
      stress_level: 4,
      work_activity_demands: 'Desk-based corporate work; seated 7-8 hours daily with light walking breaks.',
      typical_daily_steps: 6500,
      nutrition_approach: 'Balanced whole foods, 3 meals daily, seeking guidance on protein distribution.',
      hydration_habits: '2 to 2.5 litres of water per day.',
      recovery_habits: 'Stretching 10 minutes post workout; walks on non-training days.',
      other_notes: 'Motivated to improve posture, compound lift strength, and workday vitality.',
      lifestyle_priorities: [
        {
          priority: 'sleep',
          current_status: '6.5-7 hours average, irregular weekend schedule',
          first_action: 'Consistent 11pm lights out and screen-free 30 minutes before sleep',
        },
        {
          priority: 'nutrition',
          current_status: 'Moderate protein intake (~80g daily)',
          first_action: 'Target 130g protein daily with protein source at every meal and post-workout shake',
        },
        {
          priority: 'activity',
          current_status: 'Desk bound, ~6k steps',
          first_action: '15-minute lunchtime walk and stairs to reach 8,000-10,000 daily steps',
        },
        {
          priority: 'recovery',
          current_status: 'Minimal dedicated mobility work',
          first_action: '10-minute morning thoracic and hip mobility routine 4x weekly',
        },
      ],
      conducted_by_trainer_id: trainerId,
      created_at: now,
      updated_at: now,
    });
    lifestyleSeeded = true;
  }

  // 3. Seed PT Progress Review
  if (trainerId) {
    const existingReview = await db
      .select({ id: ptProgressReviews.id })
      .from(ptProgressReviews)
      .where(eq(ptProgressReviews.member_id, memberId))
      .limit(1);

    if (!existingReview[0]) {
      const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
      const thirtyDaysHence = new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000);

      await db.insert(ptProgressReviews).values({
        member_id: memberId,
        trainer_id: trainerId,
        review_period_start: thirtyDaysAgo.toISOString().slice(0, 10),
        review_period_end: now.toISOString().slice(0, 10),
        body_metrics_snapshot: [
          { metric: 'weight_kg', start_val: 78.5, current_val: 76.8, change_val: -1.7, target_val: 74.0 },
          { metric: 'body_fat_pct', start_val: 22.0, current_val: 20.2, change_val: -1.8, target_val: 17.0 },
          { metric: 'waist_cm', start_val: 88.0, current_val: 85.0, change_val: -3.0, target_val: 82.0 },
          { metric: 'chest_cm', start_val: 102.0, current_val: 104.0, change_val: 2.0, target_val: 106.0 },
        ],
        performance_markers_snapshot: [
          { marker: 'barbell_squat_5rm', start_val: '60 kg', current_val: '75 kg', change_val: '+15 kg', target_val: '90 kg' },
          { marker: 'pushups_unbroken', start_val: '12', current_val: '22', change_val: '+10 reps', target_val: '30' },
          { marker: 'plank_hold', start_val: '45s', current_val: '75s', change_val: '+30s', target_val: '120s' },
        ],
        progress_highlights: ['strength_gains', 'body_comp', 'consistency_habit', 'improved_energy'],
        highlights_other_text: 'Squat depth, core brace, and thoracic posture improved significantly.',
        trainer_summary: 'Outstanding dedication and adherence over the first 4-week block. Completed 100% of planned sessions.',
        client_feedback: 'Feeling significantly stronger and experiencing zero lower back discomfort during long working days.',
        next_phase_goal: 'Transition to 4-week hypertrophy block with progressive volume accumulation.',
        next_phase_training_focus: 'Lower body compound loading and core anti-rotational stability.',
        next_review_date: thirtyDaysHence.toISOString().slice(0, 10),
        review_checklist: {
          goals_reviewed: true,
          measurements_reviewed: true,
          performance_reviewed: true,
          attendance_reviewed: true,
          program_updated: true,
          next_goals_agreed: true,
        },
        final_review_notes: 'Program progression approved for Phase 2.',
        status: 'draft',
        created_at: now,
        updated_at: now,
      });
      reviewSeeded = true;
    }
  }

  return { parQSeeded, lifestyleSeeded, reviewSeeded };
}
