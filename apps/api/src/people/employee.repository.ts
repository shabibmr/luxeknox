import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, like, or, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  employees,
  type Employee,
  type EmployeeStatus,
  type NewEmployee,
} from '../platform/db/schema/employees';
import { users } from '../platform/db/schema/users';

export interface EmployeeWithRole extends Employee {
  role_id: number;
}

export interface EmployeeFilterParams {
  q?: string;
  status?: EmployeeStatus;
  department?: string;
  limit: number;
  offset: number;
}

export interface EmployeeFilterResult {
  rows: EmployeeWithRole[];
  total: number;
}

@Injectable()
export class EmployeeRepository extends BaseRepository<
  typeof employees,
  Employee,
  NewEmployee
> {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN)
    db: DrizzleDb<any>,
  ) {
    super(db, employees);
  }

  async findByIdWithRole(id: number): Promise<EmployeeWithRole | null> {
    const db = this.getDb() as any;
    const rows = await db
      .select({
        id: employees.id,
        user_id: employees.user_id,
        first_name: employees.first_name,
        last_name: employees.last_name,
        job_title: employees.job_title,
        department: employees.department,
        hire_date: employees.hire_date,
        status: employees.status,
        created_at: employees.created_at,
        updated_at: employees.updated_at,
        role_id: users.role_id,
      })
      .from(employees)
      .innerJoin(users, eq(users.id, employees.user_id))
      .where(eq(employees.id, id))
      .limit(1);
    return (rows[0] as EmployeeWithRole) ?? null;
  }

  async findManyFiltered(params: EmployeeFilterParams): Promise<EmployeeFilterResult> {
    const { limit, offset, q, status, department } = params;
    const db = this.getDb() as any;
    const conditions: SQL[] = [];

    if (q) {
      const pattern = `%${q}%`;
      conditions.push(
        or(
          like(employees.first_name, pattern),
          like(employees.last_name, pattern),
          like(employees.job_title, pattern),
          like(employees.department, pattern),
        )!,
      );
    }
    if (status) {
      conditions.push(eq(employees.status, status));
    }
    if (department) {
      conditions.push(like(employees.department, `%${department}%`));
    }

    const where =
      conditions.length === 0
        ? undefined
        : conditions.length === 1
          ? conditions[0]
          : and(...conditions);

    let rowsQuery = db
      .select({
        id: employees.id,
        user_id: employees.user_id,
        first_name: employees.first_name,
        last_name: employees.last_name,
        job_title: employees.job_title,
        department: employees.department,
        hire_date: employees.hire_date,
        status: employees.status,
        created_at: employees.created_at,
        updated_at: employees.updated_at,
        role_id: users.role_id,
      })
      .from(employees)
      .innerJoin(users, eq(users.id, employees.user_id));

    let countQuery = db
      .select({ value: count() })
      .from(employees)
      .innerJoin(users, eq(users.id, employees.user_id));

    if (where) {
      rowsQuery = rowsQuery.where(where);
      countQuery = countQuery.where(where);
    }

    const [rows, countRows] = await Promise.all([
      rowsQuery.limit(limit).offset(offset),
      countQuery,
    ]);

    return {
      rows: rows as EmployeeWithRole[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async updateEmployee(id: number, values: Partial<NewEmployee>): Promise<void> {
    await this.update(eq(employees.id, id), values);
  }

  async updateStatus(id: number, status: EmployeeStatus): Promise<void> {
    await this.update(eq(employees.id, id), {
      status,
      updated_at: new Date(),
    });
  }

  async countTotal(): Promise<number> {
    const db = this.getDb() as any;
    const rows = await db.select({ value: count() }).from(employees);
    return Number(rows[0]?.value ?? 0);
  }

  async countActive(): Promise<number> {
    const db = this.getDb() as any;
    const rows = await db
      .select({ value: count() })
      .from(employees)
      .where(eq(employees.status, 'active'));
    return Number(rows[0]?.value ?? 0);
  }
}
