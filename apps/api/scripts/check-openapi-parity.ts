import 'dotenv/config';
import * as fs from 'fs';
import * as path from 'path';
import YAML from 'yaml';

/**
 * Asserts every `x-status: module-0` operation in docs/openapi/v1.yaml exists in the
 * live Nest dump (docs/openapi/v1.json) with a matching HTTP method and path.
 * operationIds are not compared — Nest auto-names differ from the hand-authored contract.
 */

const HTTP_METHODS = new Set(['get', 'put', 'post', 'delete', 'options', 'head', 'patch', 'trace']);

function normalizePath(p: string): string {
  const withPrefix = p.startsWith('/v1/') || p === '/v1' ? p : `/v1${p.startsWith('/') ? p : `/${p}`}`;
  return withPrefix.replace(/\{[^}]+\}/g, '{}');
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

function collectModule0Routes(spec: any): Array<{ key: string; operationId: string }> {
  const routes: Array<{ key: string; operationId: string }> = [];
  for (const [rawPath, item] of Object.entries(spec.paths || {})) {
    for (const [method, op] of Object.entries(item as object)) {
      if (!HTTP_METHODS.has(method.toLowerCase())) continue;
      if (!op || typeof op !== 'object') continue;
      const operation = op as { 'x-status'?: string; operationId?: string };
      if (operation['x-status'] !== 'module-0') continue;
      routes.push({
        key: `${method.toUpperCase()} ${normalizePath(rawPath)}`,
        operationId: operation.operationId || '(missing operationId)',
      });
    }
  }
  return routes;
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
  const required = collectModule0Routes(yamlDoc);
  const missing = required.filter((r) => !dumpRoutes.has(r.key));

  if (missing.length > 0) {
    const lines = missing.map((m) => `  - ${m.key} (operationId: ${m.operationId})`).join('\n');
    throw new Error(
      `OpenAPI parity failed: ${missing.length} module-0 operation(s) missing from live dump:\n${lines}`,
    );
  }

  console.log(
    `[OpenAPI parity] OK — ${required.length} module-0 operation(s) present in live dump.`,
  );
}

try {
  main();
} catch (err) {
  console.error('[OpenAPI parity]', err instanceof Error ? err.message : err);
  process.exitCode = 1;
}
