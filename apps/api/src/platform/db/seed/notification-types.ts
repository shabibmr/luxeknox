import { sql } from 'drizzle-orm';
import type { DrizzleDb } from '../client';
import { notificationTypes, type NotificationTypeCode } from '../schema/notifications';

export interface NotificationTypeDefinition {
  type_code: NotificationTypeCode;
  template_text: string;
}

export const SEED_NOTIFICATION_TYPES: readonly NotificationTypeDefinition[] = [
  {
    type_code: 'membership_expiry',
    template_text: 'Your membership expires on {{expiry_date}}. Renew today to continue your fitness journey without interruption.',
  },
  {
    type_code: 'session_reminder',
    template_text: 'Reminder: You have a scheduled session "{{session_title}}" starting at {{start_time}} with {{trainer_name}}.',
  },
  {
    type_code: 'payment_due',
    template_text: 'You have an outstanding payment of {{currency}} {{amount}} due on {{due_date}}.',
  },
  {
    type_code: 'announcement',
    template_text: '{{title}}: {{message}}',
  },
  {
    type_code: 'freeze_pending',
    template_text: 'Your membership freeze request from {{start_date}} to {{end_date}} is currently pending approval.',
  },
  {
    type_code: 'booking_confirmed',
    template_text: 'Your booking for "{{session_title}}" on {{start_time}} is confirmed.',
  },
  {
    type_code: 'booking_cancelled',
    template_text: 'Your booking for "{{session_title}}" on {{start_time}} has been cancelled.',
  },
  {
    type_code: 'session_waitlist_promoted',
    template_text: 'Great news! A spot opened up and you have been promoted from the waitlist for "{{session_title}}" at {{start_time}}.',
  },
  {
    type_code: 'trainer_assigned',
    template_text: 'Trainer {{trainer_name}} has been assigned to you. Get ready to smash your fitness goals!',
  },
  {
    type_code: 'broadcast',
    template_text: '{{message}}',
  },
] as const;

/**
 * Seeds default notification types idempotently.
 * Uses ON DUPLICATE KEY UPDATE on `type_code`.
 */
export async function seedNotificationTypes(db: DrizzleDb<any>): Promise<void> {
  const now = new Date();

  for (const item of SEED_NOTIFICATION_TYPES) {
    await db
      .insert(notificationTypes)
      .values({
        type_code: item.type_code,
        template_text: item.template_text,
        is_active: true,
        created_at: now,
        updated_at: now,
      })
      .onDuplicateKeyUpdate({
        set: {
          template_text: sql`VALUES(\`template_text\`)`,
          is_active: true,
          updated_at: now,
        },
      });
  }
}
