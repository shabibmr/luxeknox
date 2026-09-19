import 'dotenv/config';
import { createConnectionPool, createDrizzleClient } from '../client';
import * as schema from '../schema';
import { seedPermissions } from './permissions';
import { seedRoles } from './roles';
import { seedAdmin } from './admin';
import { seedSettings } from './settings';

export async function runSeeds(): Promise<void> {
  console.log('[Seed] Starting database seed process...');
  const pool = createConnectionPool();
  const db = createDrizzleClient(pool, schema);

  try {
    console.log('[Seed] Seeding permissions...');
    await seedPermissions(db);

    console.log('[Seed] Seeding system roles & role_permissions...');
    await seedRoles(db);

    console.log('[Seed] Seeding Super Admin user...');
    await seedAdmin(db);

    console.log('[Seed] Seeding gym settings...');
    await seedSettings(db);

    console.log('[Seed] Seed completed successfully.');
  } finally {
    await pool.end();
  }
}

// Allow standalone execution via `tsx src/platform/db/seed/index.ts`
if (require.main === module) {
  runSeeds()
    .then(() => {
      console.log('[Seed] Exiting successfully.');
      process.exit(0);
    })
    .catch((err) => {
      console.error('[Seed] Error during seeding:', err);
      process.exit(1);
    });
}
