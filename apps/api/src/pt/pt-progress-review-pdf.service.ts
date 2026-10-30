import { Injectable } from '@nestjs/common';
import PDFDocument from 'pdfkit';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { MemberRepository } from '../people/member.repository';
import { TrainerRepository } from '../people/trainer.repository';
import type { PtProgressReview } from '../platform/db/schema/personal-training';
import { NotFoundError } from '../platform/errors/app-error';
import { PAGE8_PROGRESS_HIGHLIGHTS, PtProgressReviewService } from './pt-progress-review.service';

export interface PresentationCardContext {
  memberName: string;
  trainerName: string;
}

export interface PresentationCardFile {
  filename: string;
  buffer: Buffer;
}

function fmtNum(value: number | null | undefined): string {
  if (value == null) return '-';
  return String(value);
}

function fmtText(value: string | null | undefined): string {
  if (value == null || value === '') return '-';
  return value;
}

function fmtDate(value: Date | string | null | undefined): string {
  if (!value) return 'Pending';
  const d = value instanceof Date ? value : new Date(value);
  return Number.isNaN(d.getTime()) ? String(value) : d.toISOString().slice(0, 10);
}

/** Renders the Page 8 progress review presentation card as an A4 PDF. */
export function renderPresentationCard(
  review: PtProgressReview,
  ctx: PresentationCardContext,
): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument({ size: 'A4', margin: 40, compress: false });
    const chunks: Buffer[] = [];
    doc.on('data', (c: Buffer) => chunks.push(c));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    const section = (title: string) => {
      doc.moveDown(0.8).font('Helvetica-Bold').fontSize(12).text(title, 40);
      doc.moveTo(40, doc.y).lineTo(doc.page.width - 40, doc.y).stroke();
      doc.moveDown(0.3).font('Helvetica').fontSize(10);
    };

    doc.font('Helvetica-Bold').fontSize(18).text('Luxe Knox - Progress Review Card', 40);
    doc.font('Helvetica').fontSize(10);
    doc.text(`Client: ${ctx.memberName}    Trainer: ${ctx.trainerName}`, 40);
    doc.text(`Review period: ${review.review_period_start} to ${review.review_period_end}`, 40);

    section('Measures');
    const measureCols = [40, 220, 300, 380, 460, 555];
    const drawRow = (cells: string[], columns: number[], bold = false) => {
      const y = doc.y;
      doc.font(bold ? 'Helvetica-Bold' : 'Helvetica');
      cells.forEach((cell, i) => {
        if (!cell) return;
        doc.text(cell, columns[i], y, { width: columns[i + 1] - columns[i] - 4 });
      });
      doc.x = 40;
      doc.y = y + 16;
    };
    drawRow(['Measure', 'Start', 'Current', 'Change', 'Target'], measureCols, true);
    const body = review.body_metrics_snapshot ?? [];
    const perf = review.performance_markers_snapshot ?? [];
    const weight = body.find((m) => m.metric.toLowerCase() === 'weight');
    const waist = body.find((m) => m.metric.toLowerCase() === 'waist');
    const other = body.find((m) => {
      const name = m.metric.toLowerCase();
      return name !== 'weight' && name !== 'waist';
    });
    const strength = perf[0];
    const cardio = perf.find((p) => /cardio/i.test(p.marker));
    const bodyCells = (metric: (typeof body)[number] | undefined): string[] =>
      metric
        ? [fmtNum(metric.start_val), fmtNum(metric.current_val), fmtNum(metric.change_val), fmtNum(metric.target_val)]
        : ['-', '-', '-', '-'];
    const perfCells = (marker: (typeof perf)[number] | undefined): string[] =>
      marker
        ? [fmtText(marker.start_val), fmtText(marker.current_val), fmtText(marker.change_val), fmtText(marker.target_val)]
        : ['-', '-', '-', '-'];
    drawRow(['Weight', ...bodyCells(weight)], measureCols);
    drawRow(['Waist', ...bodyCells(waist)], measureCols);
    drawRow(['Strength marker', ...perfCells(strength)], measureCols);
    drawRow(['Cardio marker', ...perfCells(cardio)], measureCols);
    drawRow(['Other agreed metric', ...bodyCells(other)], measureCols);
    doc.font('Helvetica');

    section('Progress Highlights');
    const selected = new Set(review.progress_highlights ?? []);
    for (const label of PAGE8_PROGRESS_HIGHLIGHTS) {
      doc.text(`${selected.has(label) ? '[x]' : '[ ]'} ${label}`, 40);
    }
    const otherText = review.highlights_other_text?.trim();
    doc.text(otherText ? `Other: ${otherText}` : 'Other:', 40);

    section("Trainer's progress summary");
    if (review.trainer_summary) doc.text(review.trainer_summary, 40);
    section('Client feedback');
    if (review.client_feedback) doc.text(review.client_feedback, 40);

    section('Next Phase');
    const phaseCols = [40, 210, 380, 555];
    drawRow(['Next goal', 'Training focus', 'Review date'], phaseCols, true);
    drawRow(
      [review.next_phase_goal ?? '', review.next_phase_training_focus ?? '', review.next_review_date ?? ''],
      phaseCols,
    );

    doc.text('Client acknowledgement', 40);
    doc.text(fmtDate(review.client_signed_at), 40);
    doc.text('Trainer acknowledgement', 40);
    doc.text(fmtDate(review.trainer_signed_at), 40);

    doc.end();
  });
}

@Injectable()
export class PtProgressReviewPdfService {
  constructor(
    private readonly reviews: PtProgressReviewService,
    private readonly memberRepository: MemberRepository,
    private readonly trainerRepository: TrainerRepository,
  ) {}

  async exportPresentationCard(
    id: number,
    actor: AuthenticatedUser,
  ): Promise<PresentationCardFile> {
    // `get` enforces member scoping for the actor.
    const review = await this.reviews.get(id, actor);
    const [member, trainer] = await Promise.all([
      this.memberRepository.findById(review.member_id),
      this.trainerRepository.findById(review.trainer_id),
    ]);
    if (!member) throw new NotFoundError('Member not found');

    const buffer = await renderPresentationCard(review, {
      memberName: `${member.first_name} ${member.last_name}`.trim(),
      trainerName: trainer ? `${trainer.first_name} ${trainer.last_name}`.trim() : 'Unassigned',
    });
    return { filename: `progress-review-${review.id}.pdf`, buffer };
  }
}
