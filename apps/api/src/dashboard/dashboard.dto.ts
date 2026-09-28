import type { UserType } from '../platform/db/schema/users';

export interface MemberDashboardWidget {
  membership: {
    status: string;
    end_date: string;
    days_remaining: number;
  } | null;
  assigned_trainer: { id: number; name: string } | null;
}

export interface TrainerDashboardWidget {
  assigned_members_count: number;
  assigned_members: Array<{
    id: number;
    name: string;
    membership_number: string;
  }>;
}

export interface AdminDashboardWidget {
  members_total: number;
  trainers_total: number;
  trainers_active: number;
  employees_total: number;
  employees_active: number;
  memberships_by_status: Record<string, number>;
  memberships_expiring_soon: {
    days: number;
    count: number;
  };
  occupancy?: {
    checked_in_now: number;
    as_of: string;
    by_gate: Array<{
      gate_identifier: string | null;
      count: number;
    }>;
  };
  revenue_today?: {
    total_amount: string;
    invoice_count: number;
  };
}

export interface DashboardResponseDto {
  role: UserType;
  member?: MemberDashboardWidget;
  trainer?: TrainerDashboardWidget;
  admin?: AdminDashboardWidget;
}
