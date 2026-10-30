import { describe, expect, it } from 'vitest';
import type { PtProgressReview } from '../platform/db/schema/personal-training';
import { renderPresentationCard } from './pt-progress-review-pdf.service';

/** WinAnsi text PDFKit draws with standard fonts when the page stream is uncompressed. */
function presentationCardText(buf: Buffer): string {
  const raw = buf.toString('latin1');
  const lines: string[] = [];
  for (const match of raw.matchAll(/\[([\s\S]*?)\] TJ/g)) {
    let line = '';
    for (const hexMatch of match[1].matchAll(/<([0-9A-Fa-f]+)>/g)) {
      const hex = hexMatch[1];
      for (let i = 0; i < hex.length; i += 2) {
        line += String.fromCharCode(Number.parseInt(hex.slice(i, i + 2), 16));
      }
    }
    if (line) lines.push(line);
  }
  return lines.join('\n');
}

const review = {
  id: 1,
  member_id: 2,
  trainer_id: 3,
  review_period_start: '2026-07-01',
  review_period_end: '2026-09-30',
  body_metrics_snapshot: [
    { metric: 'Weight', start_val: 82.5, current_val: 78.1, change_val: -4.4, target_val: 75 },
  ],
  performance_markers_snapshot: null,
  progress_highlights: ['Lost 4.4 kg'],
  highlights_other_text: null,
  trainer_summary: 'Great progress',
  client_feedback: null,
  next_phase_goal: 'Reach 75 kg',
  next_phase_training_focus: null,
  next_review_date: '2026-12-30',
  review_checklist: { goals_reviewed: true },
  final_review_notes: null,
  client_signed_at: null,
  trainer_signed_at: new Date('2026-10-01T00:00:00Z'),
  manager_user_id: null,
  manager_signed_at: null,
  status: 'pending_client_sign',
  created_at: new Date(),
  updated_at: null,
} as PtProgressReview;

describe('renderPresentationCard', () => {
  it('returns a valid PDF buffer', async () => {
    const buf = await renderPresentationCard(review, { memberName: 'Asha K', trainerName: 'Ravi T' });
    expect(buf.subarray(0, 5).toString()).toBe('%PDF-');
    expect(buf.length).toBeGreaterThan(1000);
  });

  it('shows the review period and the trainer name', async () => {
    const buf = await renderPresentationCard(review, { memberName: 'Asha K', trainerName: 'Ravi T' });
    const text = presentationCardText(buf);
    expect(text).toContain('2026-07-01 to 2026-09-30');
    expect(text).toContain('Ravi T');
  });

  it('shows the five Page 8 measure rows and one worked weight row', async () => {
    const buf = await renderPresentationCard(
      {
        ...review,
        body_metrics_snapshot: [
          { metric: 'Hip', start_val: 100, current_val: 98, change_val: -2, target_val: 95 },
          { metric: 'WEIGHT', start_val: 82.5, current_val: 78.1, change_val: -4.4, target_val: 75 },
          { metric: 'waist', start_val: 90, current_val: 86, change_val: null, target_val: 84 },
          { metric: 'Chest', start_val: 111, current_val: 110, change_val: -1, target_val: 108 },
        ],
        performance_markers_snapshot: [
          { marker: 'Squat', start_val: '40 kg', current_val: '55 kg', change_val: '+15 kg', target_val: '60 kg' },
          { marker: 'Easy cardio', start_val: '30:00', current_val: null, change_val: null, target_val: '25:00' },
        ],
      },
      { memberName: 'Asha K', trainerName: 'Ravi T' },
    );
    const text = presentationCardText(buf);
    const labels = [
      'Measure',
      'Start',
      'Current',
      'Change',
      'Target',
      'Weight',
      'Waist',
      'Strength marker',
      'Cardio marker',
      'Other agreed metric',
    ];
    let from = 0;
    for (const label of labels) {
      const at = text.indexOf(label, from);
      expect(at, label).toBeGreaterThanOrEqual(0);
      from = at + label.length;
    }
    const between = (start: string, end: string) => text.slice(text.indexOf(start), text.indexOf(end, text.indexOf(start) + start.length));
    const weight = between('Weight', 'Waist');
    expect(weight).toContain('82.5');
    expect(weight).toContain('78.1');
    expect(weight).toContain('-4.4');
    expect(weight).toContain('75');
    const waist = between('Waist', 'Strength marker');
    expect(waist).toContain('90');
    expect(waist).toContain('86');
    expect(waist).toContain('-');
    expect(waist).toContain('84');
    const strength = between('Strength marker', 'Cardio marker');
    expect(strength).toContain('40 kg');
    expect(strength).toContain('55 kg');
    expect(strength).toContain('+15 kg');
    expect(strength).toContain('60 kg');
    const cardio = between('Cardio marker', 'Other agreed metric');
    expect(cardio).toContain('30:00');
    expect(cardio).toContain('-');
    expect(cardio).toContain('25:00');
    expect(cardio).not.toContain('Squat');
    const other = text.slice(text.indexOf('Other agreed metric'));
    expect(other).toContain('100');
    expect(other).toContain('98');
    expect(other).toContain('-2');
    expect(other).toContain('95');
    expect(text).not.toContain('111');
    expect(text).not.toContain('Chest');
  });

  it('does not put a cardio marker on the strength row when cardio is listed first', async () => {
    const buf = await renderPresentationCard(
      {
        ...review,
        performance_markers_snapshot: [
          { marker: 'Easy cardio', start_val: '30:00', current_val: '28:00', change_val: '-2:00', target_val: '25:00' },
          { marker: 'Squat', start_val: '40 kg', current_val: '55 kg', change_val: '+15 kg', target_val: '60 kg' },
        ],
      },
      { memberName: 'Asha K', trainerName: 'Ravi T' },
    );
    const text = presentationCardText(buf);
    const between = (start: string, end: string) =>
      text.slice(text.indexOf(start), text.indexOf(end, text.indexOf(start) + start.length));
    const strength = between('Strength marker', 'Cardio marker');
    expect(strength).toContain('40 kg');
    expect(strength).toContain('55 kg');
    expect(strength).toContain('+15 kg');
    expect(strength).toContain('60 kg');
    expect(strength).not.toContain('30:00');
    const cardio = between('Cardio marker', 'Other agreed metric');
    expect(cardio).toContain('30:00');
    expect(cardio).toContain('28:00');
    expect(cardio).toContain('-2:00');
    expect(cardio).toContain('25:00');
    expect(cardio).not.toContain('Squat');
  });

  it('leaves the strength row blank when the only marker is cardio', async () => {
    const buf = await renderPresentationCard(
      {
        ...review,
        performance_markers_snapshot: [
          { marker: 'Easy cardio', start_val: '30:00', current_val: '28:00', change_val: '-2:00', target_val: '25:00' },
        ],
      },
      { memberName: 'Asha K', trainerName: 'Ravi T' },
    );
    const text = presentationCardText(buf);
    const between = (start: string, end: string) =>
      text.slice(text.indexOf(start), text.indexOf(end, text.indexOf(start) + start.length));
    const strength = between('Strength marker', 'Cardio marker');
    expect(strength).not.toContain('30:00');
    expect(strength).toContain('-');
    const cardio = between('Cardio marker', 'Other agreed metric');
    expect(cardio).toContain('30:00');
    expect(cardio).toContain('28:00');
    expect(cardio).toContain('-2:00');
    expect(cardio).toContain('25:00');
  });

  it('checks Page 8 progress highlights and shows other text', async () => {
    const buf = await renderPresentationCard(
      {
        ...review,
        progress_highlights: ['Increased strength', 'Improved mobility'],
        highlights_other_text: 'Slept better',
      },
      { memberName: 'Asha K', trainerName: 'Ravi T' },
    );
    const text = presentationCardText(buf);
    const lines = [
      '[ ] Improved technique',
      '[x] Increased strength',
      '[ ] Improved conditioning',
      '[ ] Better consistency',
      '[x] Improved mobility',
      '[ ] Goal milestone achieved',
      'Other: Slept better',
    ];
    let from = 0;
    for (const line of lines) {
      const at = text.indexOf(line, from);
      expect(at, line).toBeGreaterThanOrEqual(0);
      from = at + line.length;
    }
  });

  it('leaves the progress highlight other line blank when none was written', async () => {
    const buf = await renderPresentationCard(
      { ...review, progress_highlights: [], highlights_other_text: null },
      { memberName: 'Asha K', trainerName: 'Ravi T' },
    );
    const text = presentationCardText(buf);
    expect(text).toContain('[ ] Improved technique');
    expect(text).toContain('Other:');
    expect(text).not.toMatch(/Other: \S/);
  });

  it("shows the trainer's progress summary and the client feedback", async () => {
    const buf = await renderPresentationCard(
      {
        ...review,
        trainer_summary: 'Great progress',
        client_feedback: 'Felt stronger on squats',
      },
      { memberName: 'Asha K', trainerName: 'Ravi T' },
    );
    const text = presentationCardText(buf);
    const summaryAt = text.indexOf("Trainer's progress summary");
    const feedbackAt = text.indexOf('Client feedback');
    expect(summaryAt).toBeGreaterThanOrEqual(0);
    expect(feedbackAt).toBeGreaterThan(summaryAt);
    expect(text.slice(summaryAt, feedbackAt)).toContain('Great progress');
    expect(text.slice(feedbackAt)).toContain('Felt stronger on squats');
  });

  it('shows the next phase as one table', async () => {
    const buf = await renderPresentationCard(
      {
        ...review,
        next_phase_goal: 'Reach 75 kg',
        next_phase_training_focus: 'Hypertrophy',
        next_review_date: '2026-12-30',
      },
      { memberName: 'Asha K', trainerName: 'Ravi T' },
    );
    const text = presentationCardText(buf);
    let from = text.indexOf('Client feedback');
    expect(from).toBeGreaterThanOrEqual(0);
    for (const header of ['Next goal', 'Training focus', 'Review date']) {
      const at = text.indexOf(header, from);
      expect(at, header).toBeGreaterThanOrEqual(0);
      from = at + header.length;
    }
    const table = text.slice(text.indexOf('Next goal'));
    expect(table).toContain('Reach 75 kg');
    expect(table).toContain('Hypertrophy');
    expect(table).toContain('2026-12-30');
  });

  it('shows client and trainer acknowledgement dates, or Pending', async () => {
    const buf = await renderPresentationCard(
      {
        ...review,
        client_signed_at: null,
        trainer_signed_at: new Date('2026-10-01T00:00:00.000Z'),
      },
      { memberName: 'Asha K', trainerName: 'Ravi T' },
    );
    const text = presentationCardText(buf);
    const clientAt = text.indexOf('Client acknowledgement');
    const trainerAt = text.indexOf('Trainer acknowledgement');
    expect(clientAt).toBeGreaterThanOrEqual(0);
    expect(trainerAt).toBeGreaterThan(clientAt);
    expect(text.slice(clientAt, trainerAt)).toContain('Pending');
    expect(text.slice(trainerAt)).toContain('2026-10-01');
  });

  it('does not draw status, the review checklist, final notes, or the manager signature', async () => {
    const buf = await renderPresentationCard(
      {
        ...review,
        status: 'pending_client_sign',
        review_checklist: {
          goals_reviewed: true,
          measurements_reviewed: true,
          performance_reviewed: true,
          attendance_reviewed: true,
          program_updated: true,
          next_goals_agreed: true,
        },
        final_review_notes: 'Manager only note',
        manager_user_id: 9,
        manager_signed_at: new Date('2026-10-02T00:00:00.000Z'),
      },
      { memberName: 'Asha K', trainerName: 'Ravi T' },
    );
    const text = presentationCardText(buf);
    expect(text).not.toContain('pending_client_sign');
    expect(text).not.toContain('Goals reviewed');
    expect(text).not.toContain('Measurements reviewed');
    expect(text).not.toContain('Performance reviewed');
    expect(text).not.toContain('Attendance reviewed');
    expect(text).not.toContain('Program updated');
    expect(text).not.toContain('Next goals agreed');
    expect(text).not.toContain('Manager only note');
    expect(text).not.toContain('2026-10-02');
    expect(text).not.toContain('Manager');
  });
});
