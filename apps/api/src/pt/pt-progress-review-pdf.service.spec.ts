import { describe, expect, it } from 'vitest';
import type { PtProgressReview } from '../platform/db/schema/personal-training';
import { renderPresentationCard } from './pt-progress-review-pdf.service';

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
});
