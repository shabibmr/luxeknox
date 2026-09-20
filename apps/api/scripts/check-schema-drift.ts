import { execFileSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';

/**
 * Schema-drift gate for the hand-authored SQL migrate path.
 *
 * 1. `drizzle-kit check` — journal/snapshot consistency
 * 2. `drizzle-kit generate` — must report no schema changes vs committed
 *    `drizzle/meta/0000_snapshot.json`. If a migration would be written, the
 *    TypeScript schema drifted without updating the baseline snapshot / SQL.
 */

const apiRoot = path.resolve(__dirname, '..');
const drizzleDir = path.join(apiRoot, 'drizzle');
const driftName = '__schema_drift_check__';

function listRelativeFiles(dir: string): string[] {
  const out: string[] = [];
  if (!fs.existsSync(dir)) return out;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      for (const child of listRelativeFiles(full)) {
        out.push(path.join(entry.name, child));
      }
    } else {
      out.push(entry.name);
    }
  }
  return out.sort();
}

function runDrizzleKit(args: string[]): string {
  return execFileSync('pnpm', ['exec', 'drizzle-kit', ...args], {
    cwd: apiRoot,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  });
}

function cleanupDriftArtifacts(before: Set<string>): void {
  const after = listRelativeFiles(drizzleDir);
  for (const rel of after) {
    if (before.has(rel)) continue;
    fs.rmSync(path.join(drizzleDir, rel), { force: true });
  }

  // Restore journal if generate appended a drift entry.
  const journalPath = path.join(drizzleDir, 'meta', '_journal.json');
  if (!fs.existsSync(journalPath)) return;
  const journal = JSON.parse(fs.readFileSync(journalPath, 'utf8')) as {
    entries?: Array<{ tag?: string }>;
  };
  if (!Array.isArray(journal.entries)) return;
  const filtered = journal.entries.filter((e) => !String(e.tag || '').includes(driftName));
  if (filtered.length !== journal.entries.length) {
    journal.entries = filtered;
    fs.writeFileSync(journalPath, `${JSON.stringify(journal, null, 2)}\n`);
  }
}

function main(): void {
  const before = new Set(listRelativeFiles(drizzleDir));
  const journalBefore = fs.readFileSync(path.join(drizzleDir, 'meta', '_journal.json'), 'utf8');

  try {
    process.stdout.write(runDrizzleKit(['check']));
  } catch (err: any) {
    const msg = `${err.stdout || ''}${err.stderr || err.message || err}`;
    console.error(msg);
    process.exit(1);
  }

  let generateOut = '';
  try {
    generateOut = runDrizzleKit(['generate', '--name', driftName]);
    process.stdout.write(generateOut);
  } catch (err: any) {
    generateOut = `${err.stdout || ''}${err.stderr || err.message || err}`;
    console.error(generateOut);
    cleanupDriftArtifacts(before);
    fs.writeFileSync(path.join(drizzleDir, 'meta', '_journal.json'), journalBefore);
    process.exit(1);
  }

  const after = listRelativeFiles(drizzleDir);
  const added = after.filter((f) => !before.has(f));
  const noChanges = /No schema changes/i.test(generateOut);

  if (!noChanges || added.length > 0) {
    cleanupDriftArtifacts(before);
    fs.writeFileSync(path.join(drizzleDir, 'meta', '_journal.json'), journalBefore);
    console.error(
      [
        '',
        'Schema drift detected: TypeScript schema does not match drizzle/meta/0000_snapshot.json.',
        'Update the hand-authored SQL under drizzle/ and refresh the baseline snapshot, then re-run db:check.',
        added.length ? `Generated artifacts (removed): ${added.join(', ')}` : '',
      ]
        .filter(Boolean)
        .join('\n'),
    );
    process.exit(1);
  }

  console.log('Schema drift check passed: snapshot matches TypeScript schema.');
}

main();
