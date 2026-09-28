import 'dotenv/config';
import * as fs from 'fs';
import * as path from 'path';
import YAML from 'yaml';

/**
 * Asserts live Nest dump (docs/openapi/v1.json) covers:
 * 1) every `x-status: module-0` operation in docs/openapi/v1.yaml
 * 2) every implemented mvp operation:
 *    - preferred: yaml `x-parity: required`
 *    - transitional fallback: IMPLEMENTED_MVP_PATH_ALLOWLIST (V1+V2+V3)
 *
 * medical-histories and health-conditions stay deferred and must not be
 * required for mvp parity.
 *
 * operationIds are not compared — Nest auto-names differ from the hand-authored contract.
 */

const HTTP_METHODS = new Set(['get', 'put', 'post', 'delete', 'options', 'head', 'patch', 'trace']);

/**
 * Transitional allowlist (now empty: all implemented MVP operations carry `x-parity: required` in YAML).
 */
const IMPLEMENTED_MVP_PATH_ALLOWLIST = new Set<string>([]);

function normalizePath(p: string): string {
  const withPrefix = p.startsWith('/v1/') || p === '/v1' ? p : `/v1${p.startsWith('/') ? p : `/${p}`}`;
  return withPrefix.replace(/\{[^}]+\}/g, '{}');
}

function stripV1(p: string): string {
  if (p === '/v1') return '/';
  return p.startsWith('/v1/') ? p.slice(3) : p;
}

function collectDumpRoutes(dump: any): Set<string> {
  const routes = new Set<string>();
  for (const [rawPath, item] of Object.entries(dump.paths || {})) {
    for (const method of Object.keys(item as object)) {
      if (!HTTP_METHODS.has(method.toLowerCase())) continue;
      routes.add(`${method.toUpperCase()} ${normalizePath(rawPath)}`);
    }
  }
  return routes;
}

type SpecRoute = {
  key: string;
  operationId: string;
  rawPath: string;
  xParity?: string;
};

function collectRoutesByStatus(spec: any, status: string): SpecRoute[] {
  const routes: SpecRoute[] = [];
  for (const [rawPath, item] of Object.entries(spec.paths || {})) {
    for (const [method, op] of Object.entries(item as object)) {
      if (!HTTP_METHODS.has(method.toLowerCase())) continue;
      if (!op || typeof op !== 'object') continue;
      const operation = op as { 'x-status'?: string; 'x-parity'?: string; operationId?: string };
      if (operation['x-status'] !== status) continue;
      routes.push({
        key: `${method.toUpperCase()} ${normalizePath(rawPath)}`,
        operationId: operation.operationId || '(missing operationId)',
        rawPath: stripV1(rawPath.startsWith('/v1/') ? rawPath : rawPath),
        xParity: operation['x-parity'],
      });
    }
  }
  return routes;
}

function isImplementedMvp(route: SpecRoute): boolean {
  if (route.xParity === 'required') return true;
  if (route.xParity === 'skip' || route.xParity === 'optional') return false;
  return IMPLEMENTED_MVP_PATH_ALLOWLIST.has(route.rawPath);
}

function isDeferredPath(rawPath: string): boolean {
  return rawPath.includes('health-conditions');
}

function main(): void {
  const root = path.resolve(__dirname, '../../..');
  const yamlPath = path.join(root, 'docs/openapi/v1.yaml');
  const dumpPath = path.join(root, 'docs/openapi/v1.json');

  if (!fs.existsSync(yamlPath)) {
    throw new Error(`Missing authoritative contract: ${yamlPath}`);
  }
  if (!fs.existsSync(dumpPath)) {
    throw new Error(
      `Missing live OpenAPI dump: ${dumpPath}. Run \`pnpm --filter api openapi:dump\` first.`,
    );
  }

  const yamlDoc = YAML.parse(fs.readFileSync(yamlPath, 'utf-8'));
  const dumpDoc = JSON.parse(fs.readFileSync(dumpPath, 'utf-8'));

  const dumpRoutes = collectDumpRoutes(dumpDoc);

  // --- module-0 ---
  const module0 = collectRoutesByStatus(yamlDoc, 'module-0');
  const missingModule0 = module0.filter((r) => !dumpRoutes.has(r.key));
  if (missingModule0.length > 0) {
    const lines = missingModule0.map((m) => `  - ${m.key} (operationId: ${m.operationId})`).join('\n');
    throw new Error(
      `OpenAPI parity failed: ${missingModule0.length} module-0 operation(s) missing from live dump:\n${lines}`,
    );
  }

  // --- implemented mvp (x-parity: required OR V1/V2/V3 allowlist) ---
  const mvpAll = collectRoutesByStatus(yamlDoc, 'mvp');
  const mvpRequired = mvpAll.filter(isImplementedMvp);
  const missingMvp = mvpRequired.filter((r) => !dumpRoutes.has(r.key));
  if (missingMvp.length > 0) {
    const lines = missingMvp.map((m) => `  - ${m.key} (operationId: ${m.operationId})`).join('\n');
    throw new Error(
      `OpenAPI parity failed: ${missingMvp.length} implemented mvp operation(s) missing from live dump:\n${lines}`,
    );
  }

  const deferredLeaked = mvpRequired.filter((r) => isDeferredPath(r.rawPath));
  if (deferredLeaked.length > 0) {
    const lines = deferredLeaked.map((m) => `  - ${m.key}`).join('\n');
    throw new Error(
      `OpenAPI parity failed: deferred health-conditions appeared in required mvp set:\n${lines}`,
    );
  }

  const deferredYaml = [...collectRoutesByStatus(yamlDoc, 'deferred')].filter((r) =>
    isDeferredPath(r.rawPath),
  );
  if (deferredYaml.length === 0) {
    throw new Error(
      'OpenAPI parity failed: expected health-conditions to remain x-status: deferred in yaml',
    );
  }

  const viaAnnotation = mvpRequired.filter((r) => r.xParity === 'required').length;
  const viaAllowlist = mvpRequired.length - viaAnnotation;

  console.log(
    `[OpenAPI parity] OK — ${module0.length} module-0 + ${mvpRequired.length} implemented mvp ` +
      `(${viaAnnotation} x-parity:required, ${viaAllowlist} allowlist) present in live dump; ` +
      `${deferredYaml.length} deferred health-conditions ops excluded.`,
  );
}

try {
  main();
} catch (err) {
  console.error('[OpenAPI parity]', err instanceof Error ? err.message : err);
  process.exitCode = 1;
}
