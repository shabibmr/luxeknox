import { Transform, type TransformCallback } from 'stream';

/**
 * Global rule: Always use '|' as a separator when creating CSV files.
 */
export const CSV_SEPARATOR = '|';

/**
 * Escapes a single value for CSV using '|' separator.
 * Quotes the value if it contains '|', '"', '\r', or '\n'.
 */
export function escapeCsvCell(val: unknown): string {
  if (val === null || val === undefined) {
    return '';
  }

  let str: string;
  if (val instanceof Date) {
    str = val.toISOString();
  } else if (typeof val === 'object') {
    str = JSON.stringify(val);
  } else {
    str = String(val);
  }

  if (str.includes(CSV_SEPARATOR) || str.includes('"') || str.includes('\n') || str.includes('\r')) {
    return `"${str.replace(/"/g, '""')}"`;
  }
  return str;
}

/**
 * Formats an array of row objects into a CSV string using '|' separator.
 */
export function formatToCsv(
  rows: Array<Record<string, any>>,
  explicitColumns?: string[],
): string {
  if (!rows || rows.length === 0) {
    if (explicitColumns && explicitColumns.length > 0) {
      return explicitColumns.map(escapeCsvCell).join(CSV_SEPARATOR) + '\n';
    }
    return '';
  }

  const columns = explicitColumns ?? Object.keys(rows[0]);
  const headerLine = columns.map(escapeCsvCell).join(CSV_SEPARATOR);
  const dataLines = rows.map((row) =>
    columns.map((col) => escapeCsvCell(row[col])).join(CSV_SEPARATOR),
  );

  return [headerLine, ...dataLines].join('\n') + '\n';
}

/**
 * Transform stream that accepts row objects and outputs CSV lines with '|' separator (RPT-013).
 */
export class ReportsCsvStream extends Transform {
  private hasSentHeader = false;
  private readonly columns?: string[];

  constructor(columns?: string[]) {
    super({ objectMode: true });
    this.columns = columns;
  }

  _transform(chunk: any, _encoding: BufferEncoding, callback: TransformCallback): void {
    try {
      if (typeof chunk !== 'object' || chunk === null) {
        return callback();
      }

      if (!this.hasSentHeader) {
        const cols = this.columns ?? Object.keys(chunk);
        const header = cols.map(escapeCsvCell).join(CSV_SEPARATOR) + '\n';
        this.push(header);
        this.hasSentHeader = true;
      }

      const cols = this.columns ?? Object.keys(chunk);
      const line = cols.map((col) => escapeCsvCell(chunk[col])).join(CSV_SEPARATOR) + '\n';
      this.push(line);
      callback();
    } catch (err) {
      callback(err as Error);
    }
  }
}
