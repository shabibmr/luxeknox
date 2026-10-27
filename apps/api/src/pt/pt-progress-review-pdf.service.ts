import { Injectable } from '@nestjs/common';
import PDFDocument from 'pdfkit';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { MemberRepository } from '../people/member.repository';
import { TrainerRepository } from '../people/trainer.repository';
import type { PtProgressReview, ReviewChecklist } from '../platform/db/schema/personal-training';
import { NotFoundError } from '../platform/errors/app-error';
import { PtProgressReviewService } from './pt-progress-review.service';

const CHECKLIST_LABELS: Array<[keyof ReviewChecklist, string]> = [
  ['goals_reviewed', 'Goals reviewed'],
  ['measurements_reviewed', 'Measurements reviewed'],
  ['performance_reviewed', 'Performance reviewed'],
  ['attendance_reviewed', 'Attendance reviewed'],
  ['program_updated', 'Program updated'],
  ['next_goals_agreed', 'Next goals agreed'],
];

export interface PresentationCardContext {
  memberName: string;
  trainerName: string;
}

export interface PresentationCardFile {
  filename: string;
  buffer: Buffer;
}

function fmtNum(value: number | null | undefined, signed = false): string {
  if (value == null) return '-';
  return signed && value > 0 ? `+${value}` : String(value);
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
    const doc = new PDFDocument({ size: 'A4', margin: 40 });
    const chunks: Buffer[] = [];
    doc.on('data', (c: Buffer) => chunks.push(c));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    const section = (title: string) => {
      doc.moveDown(0.8).font('Helvetica-Bold').fontSize(12).text(title.toUpperCase(), 40);
      doc.moveTo(40, doc.y).lineTo(doc.page.width - 40, doc.y).stroke();
      doc.moveDown(0.3).font('Helvetica').fontSize(10);
    };

    doc.font('Helvetica-Bold').fontSize(18).text('Luxe Knox - Progress Review Card', 40);
    doc.font('Helvetica').fontSize(10);
    doc.text(`Client: ${ctx.memberName}    Trainer: ${ctx.trainerName}`, 40);
    doc.text(
      `Review period: ${review.review_period_start} to ${review.review_period_end}    Status: ${review.status}`,
      40,
    );

    section('Measures');
    const cols = [40, 220, 300, 380, 460, 555];
    const drawRow = (cells: string[], bold = false) => {
      const y = doc.y;
      doc.font(bold ? 'Helvetica-Bold' : 'Helvetica');
      cells.forEach((cell, i) => doc.text(cell, cols[i], y, { width: cols[i + 1] - cols[i] - 4 }));
      doc.x = 40;
      doc.y = y + 16;
    };
    drawRow(['Measure', 'Start', 'Current', 'Change', 'Target'], true);
    for (const m of review.body_metrics_snapshot ?? []) {
      drawRow([
        m.metric,
        fmtNum(m.start_val),
        fmtNum(m.current_val),
        fmtNum(m.change_val, true),
        fmtNum(m.target_val),
      ]);
    }
    for (const p of review.performance_markers_snapshot ?? []) {
      drawRow([p.marker, p.start_val ?? '-', p.current_val ?? '-', p.change_val ?? '-', p.target_val ?? '-']);
    }
    doc.font('Helvetica');

    const highlights = [...(review.progress_highlights ?? [])];
    if (review.highlights_other_text) highlights.push(review.highlights_other_text);
    if (highlights.length) {
      section('Highlights');
      highlights.forEach((h) => doc.text(`* ${h}`, 40));
    }

    if (review.review_checklist) {
      section('Review checklist');
      for (const [key, label] of CHECKLIST_LABELS) {
        doc.text(`[${review.review_checklist[key] ? 'x' : ' '}] ${label}`, 40);
      }
    }

    const narrative: Array<[string, string | null]> = [
      ['Trainer summary', review.trainer_summary],
      ['Client feedback', review.client_feedback],
      ['Next phase goal', review.next_phase_goal],
      ['Next phase training focus', review.next_phase_training_focus],
      ['Next review date', review.next_review_date],
      ['Final review notes', review.final_review_notes],
    ];
    for (const [title, body] of narrative) {
      if (!body) continue;
      section(title);
      doc.text(body, 40);
    }

    section('Signatures');
    doc.text(`Trainer: ${ctx.trainerName} - ${fmtDate(review.trainer_signed_at)}`, 40);
    doc.text(`Client: ${ctx.memberName} - ${fmtDate(review.client_signed_at)}`, 40);
    doc.text(
      `Manager: ${review.manager_user_id != null ? `user #${review.manager_user_id}` : '-'} - ${fmtDate(review.manager_signed_at)}`,
      40,
    );

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
