import { Injectable, Logger } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { PermissionCache } from '../rbac/permission-cache';
import { PersonFactory } from '../people/person.factory';
import { MemberRepository } from '../people/member.repository';
import { TrainerRepository } from '../people/trainer.repository';
import { EmployeeRepository } from '../people/employee.repository';
import { MembershipRepository } from '../memb/membership.repository';
import { DashboardCache } from './dashboard-cache';
import type {
  AdminDashboardWidget,
  DashboardResponseDto,
  MemberDashboardWidget,
  TrainerDashboardWidget,
} from './dashboard.dto';

const ADMIN_SUMMARY_TTL_MS = 30_000;
const PROFILE_WIDGET_TTL_MS = 15_000;
const EXPIRING_SOON_WINDOW_DAYS = 7;
const TRAINER_ASSIGNED_MEMBERS_PREVIEW_LIMIT = 5;

@Injectable()
export class DashboardService {
  private readonly logger = new Logger(DashboardService.name);

  constructor(
    private readonly permissionCache: PermissionCache,
    private readonly personFactory: PersonFactory,
    private readonly memberRepository: MemberRepository,
    private readonly trainerRepository: TrainerRepository,
    private readonly employeeRepository: EmployeeRepository,
    private readonly membershipRepository: MembershipRepository,
    private readonly cache: DashboardCache,
  ) {}

  async getDashboard(currentUser: AuthenticatedUser): Promise<DashboardResponseDto> {
    const profileId =
      currentUser.profileId ??
      (await this.personFactory.resolveProfileId(currentUser.id, currentUser.userType));

    const [canMember, canTrainer, canAdmin] = await Promise.all([
      this.permissionCache.hasPermission(currentUser.roleId, 'dashboard.member'),
      this.permissionCache.hasPermission(currentUser.roleId, 'dashboard.trainer'),
      this.permissionCache.hasPermission(currentUser.roleId, 'dashboard.admin'),
    ]);

    const response: DashboardResponseDto = { role: currentUser.userType };

    const [member, trainer, admin] = await Promise.all([
      currentUser.userType === 'member' && canMember && profileId != null
        ? this.safeSection('member', () => this.buildMemberWidget(profileId))
        : Promise.resolve(undefined),
      currentUser.userType === 'trainer' && canTrainer && profileId != null
        ? this.safeSection('trainer', () => this.buildTrainerWidget(profileId))
        : Promise.resolve(undefined),
      canAdmin
        ? this.safeSection('admin', () => this.buildAdminWidget())
        : Promise.resolve(undefined),
    ]);

    if (member) response.member = member;
    if (trainer) response.trainer = trainer;
    if (admin) response.admin = admin;

    return response;
  }

  /**
   * DSH-005: a failure composing one widget must not fail the whole response —
   * the section is simply omitted, same as an unauthorized one.
   */
  private async safeSection<T>(name: string, build: () => Promise<T>): Promise<T | undefined> {
    try {
      return await build();
    } catch (error) {
      this.logger.warn(`Failed to compose dashboard section "${name}": ${(error as Error).message}`);
      return undefined;
    }
  }

  private async buildMemberWidget(memberProfileId: number): Promise<MemberDashboardWidget> {
    const cacheKey = `member:${memberProfileId}`;
    const cached = this.cache.get<MemberDashboardWidget>(cacheKey);
    if (cached) return cached;

    const [membership, member] = await Promise.all([
      this.membershipRepository.findActiveOrFrozenForMember(memberProfileId),
      this.memberRepository.findById(memberProfileId),
    ]);

    let assignedTrainer: MemberDashboardWidget['assigned_trainer'] = null;
    if (member?.assigned_trainer_id != null) {
      const trainer = await this.trainerRepository.findById(member.assigned_trainer_id);
      if (trainer) {
        assignedTrainer = {
          id: trainer.id,
          name: `${trainer.first_name} ${trainer.last_name}`.trim(),
        };
      }
    }

    const widget: MemberDashboardWidget = {
      membership: membership
        ? {
            status: membership.status,
            end_date: membership.end_date,
            days_remaining: daysUntil(membership.end_date),
          }
        : null,
      assigned_trainer: assignedTrainer,
    };

    this.cache.set(cacheKey, widget, PROFILE_WIDGET_TTL_MS);
    return widget;
  }

  private async buildTrainerWidget(trainerProfileId: number): Promise<TrainerDashboardWidget> {
    const cacheKey = `trainer:${trainerProfileId}`;
    const cached = this.cache.get<TrainerDashboardWidget>(cacheKey);
    if (cached) return cached;

    const [assignedMembersCount, preview] = await Promise.all([
      this.trainerRepository.countAssignedMembers(trainerProfileId),
      this.memberRepository.findManyFiltered({
        scope: { type: 'trainer', trainerProfileId },
        limit: TRAINER_ASSIGNED_MEMBERS_PREVIEW_LIMIT,
        offset: 0,
      }),
    ]);

    const widget: TrainerDashboardWidget = {
      assigned_members_count: assignedMembersCount,
      assigned_members: preview.rows.map((member) => ({
        id: member.id,
        name: `${member.first_name} ${member.last_name}`.trim(),
        membership_number: member.membership_number,
      })),
    };

    this.cache.set(cacheKey, widget, PROFILE_WIDGET_TTL_MS);
    return widget;
  }

  private async buildAdminWidget(): Promise<AdminDashboardWidget> {
    const cacheKey = 'admin:summary';
    const cached = this.cache.get<AdminDashboardWidget>(cacheKey);
    if (cached) return cached;

    const [
      membersTotal,
      trainersTotal,
      trainersActive,
      employeesTotal,
      employeesActive,
      membershipsByStatus,
      membershipsExpiringSoon,
    ] = await Promise.all([
      this.memberRepository.countAll(),
      this.trainerRepository.countTotal(),
      this.trainerRepository.countActive(),
      this.employeeRepository.countTotal(),
      this.employeeRepository.countActive(),
      this.membershipRepository.countByStatus(),
      this.membershipRepository.countExpiringSoon(EXPIRING_SOON_WINDOW_DAYS),
    ]);

    const widget: AdminDashboardWidget = {
      members_total: membersTotal,
      trainers_total: trainersTotal,
      trainers_active: trainersActive,
      employees_total: employeesTotal,
      employees_active: employeesActive,
      memberships_by_status: membershipsByStatus,
      memberships_expiring_soon: {
        days: EXPIRING_SOON_WINDOW_DAYS,
        count: membershipsExpiringSoon,
      },
    };

    this.cache.set(cacheKey, widget, ADMIN_SUMMARY_TTL_MS);
    return widget;
  }
}

function daysUntil(isoDate: string): number {
  const today = new Date(`${new Date().toISOString().slice(0, 10)}T00:00:00.000Z`);
  const end = new Date(`${isoDate}T00:00:00.000Z`);
  const diffMs = end.getTime() - today.getTime();
  return Math.round(diffMs / (24 * 60 * 60 * 1000));
}
