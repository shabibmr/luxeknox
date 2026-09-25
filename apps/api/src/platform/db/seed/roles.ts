import { and, eq, notInArray, sql } from 'drizzle-orm';
import type { DrizzleDb } from '../client';
import { roles } from '../schema/roles';
import { permissions } from '../schema/permissions';
import { rolePermissions } from '../schema/role-permissions';

export interface SystemRoleDefinition {
  slug: string;
  name: string;
  description: string;
  permissionSlugs: readonly string[] | 'all';
}

export const SYSTEM_ROLES: readonly SystemRoleDefinition[] = [
  {
    slug: 'super_admin',
    name: 'Super Admin',
    description: 'System owner with full unrestricted access to all modules and configurations',
    permissionSlugs: 'all',
  },
  {
    slug: 'admin',
    name: 'Admin / Manager',
    description: 'Operational manager with access to operations, reports, staff, and settings',
    permissionSlugs: [
      'auth.login',
      'auth.logout',
      'users.update',
      'auth.session_read',
      'auth.session_revoke',
      'rbac.roles_read',
      'roles.read',
      'roles.create',
      'rbac.permissions_read',
      'members.read',
      'members.write',
      'members.create',
      'members.update',
      'trainers.read',
      'trainers.write',
      'trainers.create',
      'trainers.update',
      'employees.read',
      'employees.write',
      'employees.create',
      'employees.update',
      'health.read',
      'health.write',
      'health.update',
      'health.approve',
      'health.pii_read',
      'memberships.read',
      'memberships.write',
      'memberships.create',
      'memberships.update',
      'memberships.approve',
      'memberships.freeze',
      'memberships.extend',
      'schedules.read',
      'schedules.write',
      'schedules.book',
      'schedules.cancel',
      'attendance.read',
      'attendance.checkin',
      'attendance.checkout',
      'attendance.create',
      'attendance.update',
      'attendance.override',
      'attendance.ingest',
      'payments.read',
      'payments.create',
      'payments.refund',
      'payments.approve',
      'payments.pos',
      'workouts.read',
      'workouts.write',
      'workouts.templates_write',
      'exercises.read',
      'exercises.create',
      'exercises.update',
      'diets.read',
      'diets.write',
      'diets.templates_write',
      'diet.read',
      'diet.create',
      'diet.update',
      'goals.read',
      'goals.write',
      'goals.create',
      'goals.update',
      'notifications.read',
      'notifications.send',
      'notifications.update',
      'notifications.broadcast',
      'dashboard.admin',
      'reports.read',
      'reports.export',
      'reports.read_own',
      'settings.read',
      'audit.read',
      'media.read',
      'media.write',
      'media.create',
      'roles.update',
    ],
  },
  {
    slug: 'trainer',
    name: 'Trainer',
    description: 'Fitness trainer managing assigned clients, workout/diet plans, schedules, and progress',
    permissionSlugs: [
      'auth.login',
      'auth.logout',
      'users.update',
      'members.read',
      'trainers.read',
      'health.read',
      'memberships.read',
      'schedules.read',
      'schedules.write',
      'schedules.book',
      'schedules.cancel',
      'attendance.read',
      'attendance.checkin',
      'attendance.create',
      'attendance.update',
      'workouts.read',
      'workouts.write',
      'workouts.templates_write',
      'exercises.read',
      'exercises.create',
      'diets.read',
      'diets.write',
      'diets.templates_write',
      'diet.read',
      'goals.read',
      'goals.write',
      'goals.create',
      'goals.update',
      'notifications.read',
      'notifications.update',
      'notifications.broadcast',
      'dashboard.trainer',
      'reports.read_own',
      'media.read',
      // media.write / media.create stripped — no unrestricted upload (V3-01)
    ],
  },
  {
    slug: 'employee',
    name: 'Employee / Front Desk',
    description: 'Staff member managing front desk, attendance, bookings, and POS transactions',
    permissionSlugs: [
      'auth.login',
      'auth.logout',
      'users.update',
      'members.read',
      'members.write',
      'members.create',
      'members.update',
      'trainers.read',
      'memberships.read',
      'schedules.read',
      'schedules.book',
      'schedules.cancel',
      'attendance.read',
      'attendance.checkin',
      'attendance.checkout',
      'attendance.create',
      'attendance.update',
      'attendance.override',
      'payments.read',
      'payments.create',
      'payments.pos',
      'notifications.read',
      'notifications.update',
      'media.read',
    ],
  },
  {
    slug: 'member',
    name: 'Member',
    description: 'Gym member accessing personal profile, classes, workouts, diets, and goals',
    permissionSlugs: [
      'auth.login',
      'auth.logout',
      'users.update',
      'members.read',
      'trainers.read',
      'health.read',
      'health.write',
      'health.update',
      'memberships.read',
      'memberships.update',
      'schedules.read',
      'schedules.book',
      'schedules.cancel',
      'attendance.read',
      'payments.read',
      'workouts.read',
      'workouts.write',
      'exercises.read',
      'diets.read',
      'diets.write',
      'diet.read',
      'goals.read',
      'goals.write',
      'goals.create',
      'goals.update',
      'notifications.read',
      'notifications.update',
      'dashboard.member',
      'media.read',
      // media.write / media.create stripped — purpose-scoped upload lands with V3-11
    ],
  },
] as const;

/**
 * Seeds system roles and their permission mappings idempotently.
 */
export async function seedRoles(db: DrizzleDb<any>): Promise<void> {
  const now = new Date();

  // 1. Insert or update system roles
  for (const roleDef of SYSTEM_ROLES) {
    await db
      .insert(roles)
      .values({
        name: roleDef.name,
        slug: roleDef.slug,
        description: roleDef.description,
        is_system: true,
        created_at: now,
        updated_at: now,
      })
      .onDuplicateKeyUpdate({
        set: {
          name: sql`VALUES(\`name\`)`,
          description: sql`VALUES(\`description\`)`,
          is_system: true,
          updated_at: now,
        },
      });
  }

  // 2. Fetch all roles and permissions from DB
  const allRoles = await db.select().from(roles);
  const allPerms = await db.select().from(permissions);

  const roleBySlug = new Map(allRoles.map((r) => [r.slug, r]));
  const permBySlug = new Map(allPerms.map((p) => [p.slug, p]));

  // 3. Link role_permissions
  for (const roleDef of SYSTEM_ROLES) {
    const roleRecord = roleBySlug.get(roleDef.slug);
    if (!roleRecord) continue;

    let targetPerms = allPerms;
    if (roleDef.permissionSlugs !== 'all') {
      const allowed = new Set(roleDef.permissionSlugs as readonly string[]);
      targetPerms = allPerms.filter((p) => allowed.has(p.slug));
    }

    for (const perm of targetPerms) {
      await db
        .insert(rolePermissions)
        .values({
          role_id: roleRecord.id,
          permission_id: perm.id,
          created_at: now,
        })
        .onDuplicateKeyUpdate({
          set: {
            role_id: sql`VALUES(\`role_id\`)`,
          },
        });
    }

    // 4. Prune grants removed from the system role matrix (e.g. strip media.write).
    if (roleDef.permissionSlugs !== 'all') {
      const allowedIds = targetPerms.map((p) => p.id);
      if (allowedIds.length === 0) {
        await db.delete(rolePermissions).where(eq(rolePermissions.role_id, roleRecord.id));
      } else {
        await db
          .delete(rolePermissions)
          .where(
            and(
              eq(rolePermissions.role_id, roleRecord.id),
              notInArray(rolePermissions.permission_id, allowedIds),
            ),
          );
      }
    }
  }
}
