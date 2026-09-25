import { Inject, Injectable } from '@nestjs/common';
import { eq, sql } from 'drizzle-orm';
import { hashPassword } from '../auth/password';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction, type AnyTransaction } from '../platform/db/transaction-context';
import { BadRequestError, NotFoundError } from '../platform/errors/app-error';
import { translateDbError } from '../platform/db/db-error';
import {
  employees,
  members,
  membershipNumberCounters,
  trainers,
  users,
  type Employee,
  type Member,
  type NewEmployee,
  type NewMember,
  type NewTrainer,
  type Trainer,
  type User,
  type UserType,
} from '../platform/db/schema';
import { roles } from '../platform/db/schema/roles';
import { normalizeEmail, normalizePhone } from './credentials';

export type PublicUser = Omit<User, 'password_hash'>;
export { normalizeEmail, normalizePhone } from './credentials';

export interface PersonCredentials {
  email?: string | null;
  phone_number?: string | null;
  password: string;
}

export interface MemberProfileInput {
  first_name: string;
  last_name: string;
  gender?: string | null;
  date_of_birth?: string | null;
  address?: string | null;
  assigned_trainer_id?: number | null;
  joined_date?: string | null;
  notes?: string | null;
}

export interface TrainerProfileInput {
  first_name: string;
  last_name: string;
  bio?: string | null;
  specializations?: string[] | null;
  hourly_rate?: string | null;
  rating?: number | null;
  max_clients_capacity?: number | null;
  is_active?: boolean;
}

export interface EmployeeProfileInput {
  first_name: string;
  last_name: string;
  job_title: string;
  department?: string | null;
  hire_date?: string | null;
  status?: 'active' | 'on_probation' | 'suspended' | 'terminated';
}

export type CreatePersonInput =
  | {
      userType: 'member';
      credentials: PersonCredentials;
      profile: MemberProfileInput;
    }
  | {
      userType: 'trainer';
      credentials: PersonCredentials;
      profile: TrainerProfileInput;
    }
  | {
      userType: 'employee';
      credentials: PersonCredentials;
      profile: EmployeeProfileInput;
      /** RBAC role assigned on the users row (OpenAPI EmployeeCreate.role_id). */
      roleId: number;
    };

export type CreatePersonResult =
  | { userType: 'member'; user: PublicUser; profile: Member }
  | { userType: 'trainer'; user: PublicUser; profile: Trainer }
  | { userType: 'employee'; user: PublicUser; profile: Employee };

function utcDateString(d = new Date()): string {
  return d.toISOString().slice(0, 10);
}

function formatMembershipNumber(seq: number): string {
  if (!Number.isInteger(seq) || seq < 1 || seq > 99_999_999) {
    throw new BadRequestError(`Invalid membership number sequence: ${seq}`);
  }
  return `M${String(seq).padStart(8, '0')}`;
}

function toPublicUser(user: User): PublicUser {
  const { password_hash: _passwordHash, ...rest } = user;
  return rest;
}

/** Extract mysql2/drizzle insertId from an insert result. */
export function insertIdFromResult(result: unknown): number {
  const r = result as { insertId?: number | string } | Array<{ insertId?: number | string }> | null;
  if (Array.isArray(r)) {
    return Number(r[0]?.insertId ?? 0);
  }
  return Number(r?.insertId ?? 0);
}

/**
 * FR-AUTH-008/009: create a login user + matching profile in one transaction.
 * Login `sessions.profile_id` stamping is deferred to V3-09 — use {@link resolveProfileId}.
 */
@Injectable()
export class PersonFactory {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  /**
   * Resolves the profile PK for a users row (members/trainers/employees.id).
   * Returns null for admin or when no profile row exists.
   */
  async resolveProfileId(userId: number, userType: UserType): Promise<number | null> {
    if (userType === 'admin') {
      return null;
    }

    const executor = this.db as any;
    if (userType === 'member') {
      const rows = await executor
        .select({ id: members.id })
        .from(members)
        .where(eq(members.user_id, userId))
        .limit(1);
      return rows[0]?.id ?? null;
    }
    if (userType === 'trainer') {
      const rows = await executor
        .select({ id: trainers.id })
        .from(trainers)
        .where(eq(trainers.user_id, userId))
        .limit(1);
      return rows[0]?.id ?? null;
    }
    if (userType === 'employee') {
      const rows = await executor
        .select({ id: employees.id })
        .from(employees)
        .where(eq(employees.user_id, userId))
        .limit(1);
      return rows[0]?.id ?? null;
    }
    return null;
  }

  async createPerson(input: CreatePersonInput): Promise<CreatePersonResult> {
    this.assertCredentials(input.credentials);
    this.assertUserTypeMatches(input);

    const email = normalizeEmail(input.credentials.email);
    const phone = normalizePhone(input.credentials.phone_number);
    if (!email && !phone) {
      throw new BadRequestError('At least one of email or phone_number is required');
    }

    const passwordHash = await hashPassword(input.credentials.password);
    const now = new Date();

    return runInTransaction(this.db, async (tx) => {
      const roleId = await this.resolveRoleId(tx, input);
      const userId = await this.insertUser(tx, {
        email,
        phone_number: phone,
        password_hash: passwordHash,
        user_type: input.userType,
        role_id: roleId,
        status: 'active',
        created_at: now,
        updated_at: null,
        avatar_url: null,
      });

      if (input.userType === 'member') {
        const membershipNumber = await this.allocateMembershipNumber(tx);
        const profileId = await this.insertMember(tx, {
          user_id: userId,
          membership_number: membershipNumber,
          first_name: input.profile.first_name,
          last_name: input.profile.last_name,
          gender: input.profile.gender ?? null,
          date_of_birth: input.profile.date_of_birth ?? null,
          address: input.profile.address ?? null,
          assigned_trainer_id: input.profile.assigned_trainer_id ?? null,
          joined_date: input.profile.joined_date ?? utcDateString(now),
          notes: input.profile.notes ?? null,
          created_at: now,
          updated_at: null,
        });
        const user = await this.requireUser(tx, userId);
        const profile = await this.requireMember(tx, profileId);
        return { userType: 'member', user: toPublicUser(user), profile };
      }

      if (input.userType === 'trainer') {
        const profileId = await this.insertTrainer(tx, {
          user_id: userId,
          first_name: input.profile.first_name,
          last_name: input.profile.last_name,
          bio: input.profile.bio ?? null,
          specializations: input.profile.specializations ?? null,
          hourly_rate: input.profile.hourly_rate ?? null,
          rating: input.profile.rating ?? null,
          max_clients_capacity: input.profile.max_clients_capacity ?? null,
          is_active: input.profile.is_active ?? true,
          created_at: now,
          updated_at: null,
        });
        const user = await this.requireUser(tx, userId);
        const profile = await this.requireTrainer(tx, profileId);
        return { userType: 'trainer', user: toPublicUser(user), profile };
      }

      const profileId = await this.insertEmployee(tx, {
        user_id: userId,
        first_name: input.profile.first_name,
        last_name: input.profile.last_name,
        job_title: input.profile.job_title,
        department: input.profile.department ?? null,
        hire_date: input.profile.hire_date ?? null,
        status: input.profile.status ?? 'active',
        created_at: now,
        updated_at: null,
      });
      const user = await this.requireUser(tx, userId);
      const profile = await this.requireEmployee(tx, profileId);
      return { userType: 'employee', user: toPublicUser(user), profile };
    });
  }

  private assertCredentials(credentials: PersonCredentials): void {
    if (!credentials.password || credentials.password.length < 1) {
      throw new BadRequestError('password is required');
    }
  }

  private assertUserTypeMatches(input: CreatePersonInput): void {
    const allowed = new Set(['member', 'trainer', 'employee']);
    if (!allowed.has(input.userType)) {
      throw new BadRequestError(`Unsupported user_type for person create: ${input.userType}`);
    }
    if (input.userType === 'employee' && (input.roleId == null || !Number.isInteger(input.roleId))) {
      throw new BadRequestError('role_id is required when creating an employee');
    }
  }

  private async resolveRoleId(tx: AnyTransaction, input: CreatePersonInput): Promise<number> {
    if (input.userType === 'employee') {
      const rows = await (tx as any)
        .select({ id: roles.id })
        .from(roles)
        .where(eq(roles.id, input.roleId))
        .limit(1);
      if (!rows[0]) {
        throw new NotFoundError('Role not found');
      }
      return input.roleId;
    }

    const slug = input.userType === 'member' ? 'member' : 'trainer';
    const rows = await (tx as any)
      .select({ id: roles.id })
      .from(roles)
      .where(eq(roles.slug, slug))
      .limit(1);
    if (!rows[0]) {
      throw new NotFoundError(`Role "${slug}" not found`);
    }
    return rows[0].id as number;
  }

  /**
   * Patch login email/phone on an existing users row (ambient-TX aware via caller).
   */
  async patchUserCredentials(
    userId: number,
    patch: { email?: string | null; phone_number?: string | null },
    executor?: AnyTransaction | DrizzleDb<any>,
  ): Promise<void> {
    const db = (executor ?? this.db) as any;
    const values: Record<string, unknown> = { updated_at: new Date() };
    if (patch.email !== undefined) {
      values.email = normalizeEmail(patch.email);
    }
    if (patch.phone_number !== undefined) {
      values.phone_number = normalizePhone(patch.phone_number);
    }
    if (Object.keys(values).length === 1) {
      return;
    }
    try {
      await db.update(users).set(values).where(eq(users.id, userId));
    } catch (err: unknown) {
      throw translateDbError(err, { duplicateMessage: 'Email or phone_number already in use' });
    }
  }

  private async insertUser(
    tx: AnyTransaction,
    values: typeof users.$inferInsert,
  ): Promise<number> {
    try {
      const result = await (tx as any).insert(users).values(values);
      const insertId = insertIdFromResult(result);
      if (!insertId) {
        throw new BadRequestError('Failed to create user');
      }
      return insertId;
    } catch (err: unknown) {
      throw translateDbError(err, { duplicateMessage: 'Email or phone_number already in use' });
    }
  }

  private async allocateMembershipNumber(tx: AnyTransaction): Promise<string> {
    // Lock + read in one statement so the driver shape is unambiguous.
    const locked = await (tx as any).execute(
      sql`SELECT \`next_value\` AS next_value FROM \`membership_number_counters\` WHERE \`id\` = 1 FOR UPDATE`,
    );
    const rows = Array.isArray(locked) ? (Array.isArray(locked[0]) ? locked[0] : locked) : [];
    const nextValue = Number((rows[0] as { next_value?: unknown } | undefined)?.next_value);
    if (!Number.isFinite(nextValue) || nextValue < 1) {
      throw new BadRequestError('membership_number_counters is not initialized');
    }

    await (tx as any)
      .update(membershipNumberCounters)
      .set({ next_value: nextValue + 1 })
      .where(eq(membershipNumberCounters.id, 1));
    return formatMembershipNumber(nextValue);
  }

  private async insertMember(tx: AnyTransaction, values: NewMember): Promise<number> {
    const insertId = insertIdFromResult(await (tx as any).insert(members).values(values));
    if (!insertId) {
      throw new BadRequestError('Failed to create member profile');
    }
    return insertId;
  }

  private async insertTrainer(tx: AnyTransaction, values: NewTrainer): Promise<number> {
    const insertId = insertIdFromResult(await (tx as any).insert(trainers).values(values));
    if (!insertId) {
      throw new BadRequestError('Failed to create trainer profile');
    }
    return insertId;
  }

  private async insertEmployee(tx: AnyTransaction, values: NewEmployee): Promise<number> {
    const insertId = insertIdFromResult(await (tx as any).insert(employees).values(values));
    if (!insertId) {
      throw new BadRequestError('Failed to create employee profile');
    }
    return insertId;
  }

  private async requireUser(tx: AnyTransaction, id: number): Promise<User> {
    const rows = await (tx as any).select().from(users).where(eq(users.id, id)).limit(1);
    if (!rows[0]) {
      throw new NotFoundError('User not found after create');
    }
    return rows[0] as User;
  }

  private async requireMember(tx: AnyTransaction, id: number): Promise<Member> {
    const rows = await (tx as any).select().from(members).where(eq(members.id, id)).limit(1);
    if (!rows[0]) {
      throw new NotFoundError('Member not found after create');
    }
    return rows[0] as Member;
  }

  private async requireTrainer(tx: AnyTransaction, id: number): Promise<Trainer> {
    const rows = await (tx as any).select().from(trainers).where(eq(trainers.id, id)).limit(1);
    if (!rows[0]) {
      throw new NotFoundError('Trainer not found after create');
    }
    return rows[0] as Trainer;
  }

  private async requireEmployee(tx: AnyTransaction, id: number): Promise<Employee> {
    const rows = await (tx as any).select().from(employees).where(eq(employees.id, id)).limit(1);
    if (!rows[0]) {
      throw new NotFoundError('Employee not found after create');
    }
    return rows[0] as Employee;
  }
}
