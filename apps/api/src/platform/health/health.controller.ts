import { Controller, Get, Res, HttpStatus, Inject, Query } from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags, ApiProperty, ApiQuery } from '@nestjs/swagger';
import type { Response } from 'express';
import { sql } from 'drizzle-orm';
import type { DrizzleDb } from '../db/client';
import { DRIZZLE_DB_TOKEN } from '../db/drizzle.module';
import { JobRunRepository } from '../../job/job-run.repository';

export class HealthResponseDto {
  @ApiProperty({ type: String, example: 'ok', description: 'Application process status' })
  status!: 'ok';

  @ApiProperty({ type: String, example: '2026-09-16T12:00:00.000Z', description: 'Current UTC ISO-8601 timestamp' })
  timestamp!: string;
}

export class JobMetricsDto {
  @ApiProperty({ type: Number, example: 0, description: 'Total job execution failures' })
  failure_count!: number;

  @ApiProperty({ type: Number, example: 0, description: 'Total job execution retries' })
  retry_count!: number;

  @ApiProperty({ type: String, nullable: true, example: '2026-09-16T12:00:00.000Z', description: 'Last successful job execution timestamp (UTC)' })
  last_success_at!: string | null;
}

export class ReadyResponseDto {
  @ApiProperty({ type: String, example: 'ok', enum: ['ok', 'error'], description: 'Readiness probe status' })
  status!: 'ok' | 'error';

  @ApiProperty({ type: String, example: 'connected', enum: ['connected', 'disconnected'], description: 'PostgreSQL database connectivity status' })
  database!: 'connected' | 'disconnected';

  @ApiProperty({ type: String, required: false, example: 'luxeknox_app', description: 'Current PostgreSQL connected role' })
  role?: string;

  @ApiProperty({ type: String, example: '2026-09-16T12:00:00.000Z', description: 'Current UTC ISO-8601 timestamp' })
  timestamp!: string;

  @ApiProperty({ type: JobMetricsDto, nullable: true, required: false, description: 'Background job observability metrics (if available)' })
  jobs?: JobMetricsDto;
}

@ApiTags('Health')
@Controller()
export class HealthController {
  constructor(
    @Inject(DRIZZLE_DB_TOKEN) private readonly db: DrizzleDb,
    private readonly jobRunRepository: JobRunRepository,
  ) {}

  @Get('health')
  @ApiOperation({
    summary: 'Process liveness health check',
    description: 'Returns HTTP 200 indicating the Node.js / NestJS process is running without checking database connectivity.',
  })
  @ApiResponse({
    status: 200,
    description: 'Process is healthy and operational',
    type: HealthResponseDto,
  })
  getHealth(): HealthResponseDto {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
    };
  }

  @Get('ready')
  @ApiOperation({
    summary: 'Readiness check with database ping and role verification',
    description: 'Pings PostgreSQL using Drizzle / connection pool (SELECT current_user). Returns 200 if connected, or 503 if disconnected. Optionally verifies connection role with ?verifyRole=true.',
  })
  @ApiQuery({
    name: 'verifyRole',
    required: false,
    type: Boolean,
    description: 'When true, asserts that connected DB role matches non-admin app user (DB_USER) and is not superuser',
  })
  @ApiResponse({
    status: 200,
    description: 'Application and database are ready to serve requests',
    type: ReadyResponseDto,
  })
  @ApiResponse({
    status: 503,
    description: 'Database is disconnected or unreachable',
    type: ReadyResponseDto,
  })
  async getReady(
    @Res({ passthrough: true }) res: Response,
    @Query('verifyRole') verifyRole?: string,
  ): Promise<ReadyResponseDto> {
    try {
      const pingResult: any = await this.db.execute(
        sql`SELECT current_user, current_setting('is_superuser') AS is_superuser`,
      );
      const row = pingResult?.rows?.[0] ?? pingResult?.[0];
      const role = row?.current_user;
      const isSuperuser = row?.is_superuser === 'on';

      if (verifyRole === 'true' || verifyRole === '1') {
        const expectedUser = process.env.DB_USER;
        if (expectedUser && role && role !== expectedUser) {
          throw new Error(`DB connected role '${role}' does not match expected DB_USER '${expectedUser}'`);
        }
        if (isSuperuser) {
          throw new Error(`DB connected role '${role}' has superuser privilege`);
        }
      }

      const metrics = await this.jobRunRepository.getMetrics();
      res.status(HttpStatus.OK);
      return {
        status: 'ok',
        database: 'connected',
        ...(role ? { role: String(role) } : {}),
        timestamp: new Date().toISOString(),
        jobs: {
          failure_count: metrics.failureCount,
          retry_count: metrics.retryCount,
          last_success_at: metrics.lastSuccessAt ? metrics.lastSuccessAt.toISOString() : null,
        },
      };
    } catch {
      res.status(HttpStatus.SERVICE_UNAVAILABLE);
      return {
        status: 'error',
        database: 'disconnected',
        timestamp: new Date().toISOString(),
      };
    }
  }
}
