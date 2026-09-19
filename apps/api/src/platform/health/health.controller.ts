import { Controller, Get, Res, HttpStatus, Inject, Optional } from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags, ApiProperty } from '@nestjs/swagger';
import type { Response } from 'express';
import { sql } from 'drizzle-orm';
import { createConnectionPool, createDrizzleClient, type DrizzleDb } from '../db/client';
import { DRIZZLE_DB_TOKEN } from '../db/drizzle.module';

export { DRIZZLE_DB_TOKEN };

export class HealthResponseDto {
  @ApiProperty({ type: String, example: 'ok', description: 'Application process status' })
  status!: 'ok';

  @ApiProperty({ type: String, example: '2026-09-16T12:00:00.000Z', description: 'Current UTC ISO-8601 timestamp' })
  timestamp!: string;
}

export class ReadyResponseDto {
  @ApiProperty({ type: String, example: 'ok', enum: ['ok', 'error'], description: 'Readiness probe status' })
  status!: 'ok' | 'error';

  @ApiProperty({ type: String, example: 'connected', enum: ['connected', 'disconnected'], description: 'MySQL database connectivity status' })
  database!: 'connected' | 'disconnected';

  @ApiProperty({ type: String, example: '2026-09-16T12:00:00.000Z', description: 'Current UTC ISO-8601 timestamp' })
  timestamp!: string;
}

@ApiTags('Health')
@Controller()
export class HealthController {
  private readonly db: DrizzleDb;

  constructor(@Optional() @Inject(DRIZZLE_DB_TOKEN) db?: DrizzleDb) {
    if (db) {
      this.db = db;
    } else {
      const pool = createConnectionPool();
      this.db = createDrizzleClient(pool);
    }
  }

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
    summary: 'Readiness check with database ping',
    description: 'Pings MySQL using Drizzle / connection pool (SELECT 1). Returns 200 if connected, or 503 if disconnected.',
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
  async getReady(@Res({ passthrough: true }) res: Response): Promise<ReadyResponseDto> {
    try {
      await this.db.execute(sql`SELECT 1`);
      res.status(HttpStatus.OK);
      return {
        status: 'ok',
        database: 'connected',
        timestamp: new Date().toISOString(),
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
