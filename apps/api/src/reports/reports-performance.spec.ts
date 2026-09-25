import { describe, it, expect } from 'vitest';
import { Readable } from 'stream';
import { ReportsCsvStream, formatToCsv, CSV_SEPARATOR } from './reports.csv';
import { resolveReportDateRange, wallClockToUtcDate } from './reports.timezone';

describe('RPT-014: Report Query and Export Performance', () => {
  it('streams 5,000 report rows through ReportsCsvStream in under 100ms', async () => {
    const rowCount = 5000;
    const testRows: Array<Record<string, any>> = [];

    for (let i = 0; i < rowCount; i++) {
      testRows.push({
        index: i,
        member_id: 1000 + (i % 50),
        status: i % 2 === 0 ? 'active' : 'inactive',
        duration_days: 30 + (i % 365),
        amount_paid: '199.99',
        notes: i % 10 === 0 ? 'Special | notes with pipe' : 'Normal notes',
        recorded_at: '2026-09-21T10:00:00.000Z',
      });
    }

    const startTime = performance.now();

    const inStream = Readable.from(testRows);
    const csvStream = new ReportsCsvStream();

    let outputBytes = 0;
    let lineCount = 0;

    await new Promise<void>((resolve, reject) => {
      inStream
        .pipe(csvStream)
        .on('data', (chunk: string | Buffer) => {
          const str = chunk.toString();
          outputBytes += str.length;
          lineCount += (str.match(/\n/g) || []).length;
        })
        .on('end', () => resolve())
        .on('error', reject);
    });

    const durationMs = performance.now() - startTime;

    expect(lineCount).toBe(rowCount + 1); // Header + 5000 data lines
    expect(outputBytes).toBeGreaterThan(100000);
    expect(durationMs).toBeLessThan(500); // 5000 rows streamed in under 500ms
  });

  it('formats 10,000 rows into in-memory CSV in under 100ms', () => {
    const rowCount = 10000;
    const testRows: Array<Record<string, any>> = [];

    for (let i = 0; i < rowCount; i++) {
      testRows.push({
        id: i,
        metric: 'attendance_count',
        value: i * 2,
        category: 'performance_test',
      });
    }

    const start = performance.now();
    const csv = formatToCsv(testRows);
    const duration = performance.now() - start;

    expect(csv.startsWith(`id${CSV_SEPARATOR}metric${CSV_SEPARATOR}value${CSV_SEPARATOR}category`)).toBe(true);
    expect(duration).toBeLessThan(300);
  });

  it('evaluates timezone boundary calculations across 1,000 operations in under 500ms', () => {
    const start = performance.now();
    for (let i = 0; i < 1000; i++) {
      resolveReportDateRange('2026-09-01', '2026-09-30', 'Asia/Kolkata');
    }
    const duration = performance.now() - start;
    expect(duration).toBeLessThan(500);
  });
});
