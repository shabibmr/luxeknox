import { z } from 'zod';
import { EMPLOYEE_STATUSES } from '../platform/db/schema/employees';

export const employeeCreateSchema = z.object({
  email: z.string().trim().email().max(255),
  phone_number: z.string().trim().min(1).max(32).optional().nullable(),
  password: z.string().min(1, 'password is required').max(255),
  first_name: z.string().trim().min(1).max(100),
  last_name: z.string().trim().min(1).max(100),
  job_title: z.string().trim().min(1).max(150),
  department: z.string().trim().max(150).optional().nullable(),
  hire_date: z.string().trim().min(1).optional().nullable(),
  role_id: z.number().int().positive(),
});

export type EmployeeCreateDto = z.infer<typeof employeeCreateSchema>;

export const employeeUpdateSchema = z
  .object({
    job_title: z.string().trim().min(1).max(150).optional(),
    department: z.string().trim().max(150).optional().nullable(),
    hire_date: z.string().trim().min(1).optional().nullable(),
    first_name: z.string().trim().min(1).max(100).optional(),
    last_name: z.string().trim().min(1).max(100).optional(),
  })
  .strict();

export type EmployeeUpdateDto = z.infer<typeof employeeUpdateSchema>;

export const employeeStatusSchema = z.object({
  status: z.enum(EMPLOYEE_STATUSES),
});

export type EmployeeStatusDto = z.infer<typeof employeeStatusSchema>;

export const assignRoleSchema = z.object({
  role_id: z.number().int().positive(),
});

export type AssignRoleDto = z.infer<typeof assignRoleSchema>;

export const employeeFilterQuerySchema = z.object({
  q: z.string().trim().min(1).optional(),
  status: z.enum(EMPLOYEE_STATUSES).optional(),
  department: z.string().trim().min(1).max(150).optional(),
});

export type EmployeeFilterQueryDto = z.infer<typeof employeeFilterQuerySchema>;
