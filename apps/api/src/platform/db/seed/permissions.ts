import { sql } from 'drizzle-orm';
import type { DrizzleDb } from '../client';
import { permissions } from '../schema/permissions';

/**
 * Permission slug convention (freeze for V4+):
 * - Catalogue libraries: `{resource}.read|create|update` where resource matches the
 *   HTTP collection (`exercises.*`, OpenAPI food library uses `diet.*` — exception;
 *   reserved `diets.*` is for future plans/meals/logs, not food CRUD).
 * - PEOPLE/HEALTH/MEDIA mutates: OpenAPI granular `*.create|update` (and
 *   `health.approve`, `media.create`, `roles.update`) dual-seeded beside legacy
 *   `*.write` / `rbac.roles_write` until clients stop sending legacy slugs.
 * - Controllers enforce OpenAPI slugs only; do not map `diets.write` → food mutate.
 * - Prefer not granting future-module slugs on new roles until that vertical ships;
 *   existing SYSTEM_ROLES future grants are grandfathered and pruned only when
 *   explicitly removed from the matrix.
 */

export interface PermissionDefinition {
  module: string;
  action: string;
  slug: string;
  description: string;
}

export const SEED_PERMISSIONS: readonly PermissionDefinition[] = [
  // AUTH
  { module: 'AUTH', action: 'login', slug: 'auth.login', description: 'User login to system' },
  { module: 'AUTH', action: 'logout', slug: 'auth.logout', description: 'User logout and session invalidation' },
  { module: 'AUTH', action: 'session_read', slug: 'auth.session_read', description: 'View active sessions' },
  { module: 'AUTH', action: 'session_revoke', slug: 'auth.session_revoke', description: 'Revoke active sessions' },
  { module: 'AUTH', action: 'password_change', slug: 'users.update', description: 'Change own account password (OpenAPI POST /auth/password/change)' },

  // RBAC — roles.update is OpenAPI (PUT /employees/{id}/role); rbac.roles_write kept legacy
  { module: 'RBAC', action: 'roles_read', slug: 'rbac.roles_read', description: 'View roles catalog' },
  { module: 'RBAC', action: 'roles_write', slug: 'rbac.roles_write', description: 'Create and update roles' },
  { module: 'RBAC', action: 'roles_read', slug: 'roles.read', description: 'View roles and permission catalog (OpenAPI GET /roles, /roles/{id}, /permissions)' },
  { module: 'RBAC', action: 'roles_create', slug: 'roles.create', description: 'Create a custom role (OpenAPI POST /roles)' },
  { module: 'RBAC', action: 'roles_update', slug: 'roles.update', description: 'Update a role, assign an employee role, or replace a role\'s permission set' },
  { module: 'RBAC', action: 'permissions_read', slug: 'rbac.permissions_read', description: 'View system permissions catalog' },

  // PEOPLE — *.create|update are OpenAPI; *.write kept legacy
  { module: 'PEOPLE', action: 'read', slug: 'members.read', description: 'View members directory and details' },
  { module: 'PEOPLE', action: 'write', slug: 'members.write', description: 'Create and update members' },
  { module: 'PEOPLE', action: 'members_create', slug: 'members.create', description: 'Onboard a member (user + profile)' },
  { module: 'PEOPLE', action: 'members_update', slug: 'members.update', description: 'Update member profile or trainer assignment' },
  { module: 'PEOPLE', action: 'read', slug: 'trainers.read', description: 'View trainers directory and details' },
  { module: 'PEOPLE', action: 'write', slug: 'trainers.write', description: 'Create and update trainers' },
  { module: 'PEOPLE', action: 'trainers_create', slug: 'trainers.create', description: 'Create a trainer (user + profile)' },
  { module: 'PEOPLE', action: 'trainers_update', slug: 'trainers.update', description: 'Update trainer profile or active flag' },
  { module: 'PEOPLE', action: 'read', slug: 'employees.read', description: 'View employees directory and details' },
  { module: 'PEOPLE', action: 'write', slug: 'employees.write', description: 'Create and update employees' },
  { module: 'PEOPLE', action: 'employees_create', slug: 'employees.create', description: 'Create an employee (user + profile)' },
  { module: 'PEOPLE', action: 'employees_update', slug: 'employees.update', description: 'Update employee profile or employment status' },

  // HEALTH — health.update|approve are OpenAPI; health.write kept legacy
  { module: 'HEALTH', action: 'read', slug: 'health.read', description: 'View health profile and vital records' },
  { module: 'HEALTH', action: 'write', slug: 'health.write', description: 'Update health profile and medical history' },
  { module: 'HEALTH', action: 'update', slug: 'health.update', description: 'Update health profile, emergency contacts, and documents' },
  { module: 'HEALTH', action: 'approve', slug: 'health.approve', description: 'Verify member health documents' },
  { module: 'HEALTH', action: 'pii_read', slug: 'health.pii_read', description: 'View sensitive medical documents and PII' },

  // MEMB — *.create|update|approve are OpenAPI; *.write/freeze/extend kept legacy
  { module: 'MEMB', action: 'read', slug: 'memberships.read', description: 'View memberships and packages' },
  { module: 'MEMB', action: 'write', slug: 'memberships.write', description: 'Create and modify memberships' },
  { module: 'MEMB', action: 'create', slug: 'memberships.create', description: 'Create membership products and assign memberships' },
  { module: 'MEMB', action: 'update', slug: 'memberships.update', description: 'Update membership products and submit freeze requests' },
  { module: 'MEMB', action: 'approve', slug: 'memberships.approve', description: 'Approve renew/upgrade/cancel/freeze/extend actions' },
  { module: 'MEMB', action: 'freeze', slug: 'memberships.freeze', description: 'Freeze or unfreeze memberships' },
  { module: 'MEMB', action: 'extend', slug: 'memberships.extend', description: 'Extend membership duration' },

  // SCHED
  { module: 'SCHED', action: 'read', slug: 'schedules.read', description: 'View class schedules and availability' },
  { module: 'SCHED', action: 'write', slug: 'schedules.write', description: 'Create and update schedule events' },
  { module: 'SCHED', action: 'book', slug: 'schedules.book', description: 'Book class or personal trainer slot' },
  { module: 'SCHED', action: 'cancel', slug: 'schedules.cancel', description: 'Cancel scheduled booking' },

  // ATTN
  { module: 'ATTN', action: 'read', slug: 'attendance.read', description: 'View attendance records and logs' },
  { module: 'ATTN', action: 'checkin', slug: 'attendance.checkin', description: 'Check-in member or staff' },
  { module: 'ATTN', action: 'checkout', slug: 'attendance.checkout', description: 'Check-out member or staff' },
  // OpenAPI granular slugs for POST /attendances/check-in and POST /attendances/{id}/check-out
  // (x-permission: attendance.create / attendance.update). Dual-seeded beside the legacy
  // attendance.checkin/checkout slugs, per the PEOPLE/MEDIA dual-seed convention above.
  { module: 'ATTN', action: 'create', slug: 'attendance.create', description: 'Record a gate check-in event' },
  { module: 'ATTN', action: 'update', slug: 'attendance.update', description: 'Record a gate check-out event' },
  { module: 'ATTN', action: 'override', slug: 'attendance.override', description: 'Manual attendance override' },
  { module: 'ATTN', action: 'ingest', slug: 'attendance.ingest', description: 'Hardware turnstile event ingest' },

  // PAY
  { module: 'PAY', action: 'read', slug: 'payments.read', description: 'View invoices, transactions and dues' },
  { module: 'PAY', action: 'create', slug: 'payments.create', description: 'Record payment or generate invoice' },
  { module: 'PAY', action: 'refund', slug: 'payments.refund', description: 'Process payment refund' },
  { module: 'PAY', action: 'approve', slug: 'payments.approve', description: 'Approve refunds and invoice adjustments' },
  { module: 'PAY', action: 'pos', slug: 'payments.pos', description: 'POS point-of-sale checkout capture' },

  // WORK
  { module: 'WORK', action: 'read', slug: 'workouts.read', description: 'View workout plans and exercise sessions' },
  { module: 'WORK', action: 'write', slug: 'workouts.write', description: 'Create or update workout plans and logs' },
  { module: 'WORK', action: 'templates_write', slug: 'workouts.templates_write', description: 'Create and publish master workout templates' },
  { module: 'WORK', action: 'exercises_read', slug: 'exercises.read', description: 'View the exercise library' },
  { module: 'WORK', action: 'exercises_create', slug: 'exercises.create', description: 'Add exercises to the library' },
  { module: 'WORK', action: 'exercises_update', slug: 'exercises.update', description: 'Update or deactivate exercises in the library' },

  // DIET — diets.* reserved for plans/logs; diet.* is the food library (OpenAPI)
  { module: 'DIET', action: 'read', slug: 'diets.read', description: 'View diet plans and food intake logs' },
  { module: 'DIET', action: 'write', slug: 'diets.write', description: 'Create or update diet plans and intake logs' },
  { module: 'DIET', action: 'templates_write', slug: 'diets.templates_write', description: 'Create and publish master diet templates' },
  { module: 'DIET', action: 'foods_read', slug: 'diet.read', description: 'View the food library' },
  { module: 'DIET', action: 'foods_create', slug: 'diet.create', description: 'Add foods to the library' },
  { module: 'DIET', action: 'foods_update', slug: 'diet.update', description: 'Update or deactivate foods in the library' },

  // GOAL
  { module: 'GOAL', action: 'read', slug: 'goals.read', description: 'View fitness goals, measurements and progress photos' },
  { module: 'GOAL', action: 'write', slug: 'goals.write', description: 'Log measurements, progress photos and update goals' },
  { module: 'GOAL', action: 'create', slug: 'goals.create', description: 'Create goals, metrics, measurements, progress notes or photos' },
  { module: 'GOAL', action: 'update', slug: 'goals.update', description: 'Update goals, metrics, check-ins, or delete progress photos' },

  // NOTIF
  { module: 'NOTIF', action: 'read', slug: 'notifications.read', description: 'View notifications and alerts' },
  { module: 'NOTIF', action: 'send', slug: 'notifications.send', description: 'Send or broadcast notifications' },
  { module: 'NOTIF', action: 'update', slug: 'notifications.update', description: 'Mark notifications read and manage push devices' },
  { module: 'NOTIF', action: 'broadcast', slug: 'notifications.broadcast', description: 'Send and view notification broadcasts' },

  // DASH
  { module: 'DASH', action: 'member', slug: 'dashboard.member', description: 'Access member dashboard aggregates' },
  { module: 'DASH', action: 'trainer', slug: 'dashboard.trainer', description: 'Access trainer dashboard aggregates' },
  { module: 'DASH', action: 'admin', slug: 'dashboard.admin', description: 'Access admin dashboard analytics' },

  // RPT
  { module: 'RPT', action: 'read', slug: 'reports.read', description: 'View business and operational reports' },
  { module: 'RPT', action: 'export', slug: 'reports.export', description: 'Export report data and analytics' },
  { module: 'RPT', action: 'read_own', slug: 'reports.read_own', description: 'View own trainer performance report' },

  // SYS
  { module: 'SYS', action: 'read', slug: 'settings.read', description: 'View gym settings' },
  { module: 'SYS', action: 'update', slug: 'settings.update', description: 'Update gym settings' },
  { module: 'SYS', action: 'read', slug: 'audit.read', description: 'View system audit logs' },

  // MEDIA — media.create is OpenAPI; media.write kept legacy
  { module: 'MEDIA', action: 'read', slug: 'media.read', description: 'Access uploaded media and documents' },
  { module: 'MEDIA', action: 'write', slug: 'media.write', description: 'Upload media files and attachments' },
  { module: 'MEDIA', action: 'create', slug: 'media.create', description: 'Create a signed media upload slot' },
] as const;

/**
 * Seeds permissions idempotently.
 * Uses ON DUPLICATE KEY UPDATE on the unique `slug` column.
 */
export async function seedPermissions(db: DrizzleDb<any>): Promise<void> {
  const now = new Date();

  for (const perm of SEED_PERMISSIONS) {
    await db
      .insert(permissions)
      .values({
        module: perm.module,
        action: perm.action,
        slug: perm.slug,
        description: perm.description,
        created_at: now,
      })
      .onDuplicateKeyUpdate({
        set: {
          module: sql`VALUES(\`module\`)`,
          action: sql`VALUES(\`action\`)`,
          description: sql`VALUES(\`description\`)`,
        },
      });
  }
}
