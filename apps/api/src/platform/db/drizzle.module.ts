import { Global, Module, type DynamicModule, type Provider } from '@nestjs/common';
import type { Pool } from 'mysql2/promise';
import { createConnectionPool, createDrizzleClient, type DatabaseConfig, type DrizzleDb } from './client';
import * as schema from './schema';

export const DRIZZLE_POOL_TOKEN = 'DRIZZLE_POOL';
export const DRIZZLE_DB_TOKEN = 'DRIZZLE_DB';

export interface DrizzleModuleOptions {
  config?: DatabaseConfig;
  schema?: Record<string, unknown>;
}

@Global()
@Module({})
export class DrizzleModule {
  static forRoot(options: DrizzleModuleOptions = {}): DynamicModule {
    const poolProvider: Provider = {
      provide: DRIZZLE_POOL_TOKEN,
      useFactory: (): Pool => {
        return createConnectionPool(options.config);
      },
    };

    const dbProvider: Provider = {
      provide: DRIZZLE_DB_TOKEN,
      inject: [DRIZZLE_POOL_TOKEN],
      useFactory: (pool: Pool): DrizzleDb<typeof schema> => {
        return createDrizzleClient(pool, (options.schema ?? schema) as typeof schema);
      },
    };

    return {
      module: DrizzleModule,
      providers: [poolProvider, dbProvider],
      exports: [DRIZZLE_POOL_TOKEN, DRIZZLE_DB_TOKEN],
    };
  }
}
