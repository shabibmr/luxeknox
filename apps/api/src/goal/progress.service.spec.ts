import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import type { MemberRepository } from '../people/member.repository';
import type { AuditService } from '../platform/audit/audit.service';
import type { ProgressNote, ProgressPhoto } from '../platform/db/schema/goals';
import { ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { PaginationHelper } from '../platform/http/pagination';
import type { ProgressNoteRepository } from './progress-note.repository';
import { ProgressNoteService } from './progress-note.service';
import type { ProgressPhotoRepository } from './progress-photo.repository';
import { ProgressPhotoService } from './progress-photo.service';

describe('ProgressService (GOA-010, GOA-011, GOA-012, GOA-014)', () => {
  let noteService: ProgressNoteService;
  let photoService: ProgressPhotoService;
  let noteRepo: any;
  let photoRepo: any;
  let memberRepo: any;
  let auditService: any;
  let paginationHelper: PaginationHelper;

  const mockAdminUser: AuthenticatedUser = {
    id: 1,
    roleId: 1,
    userType: 'admin',
    email: 'admin',
    phoneNumber: null,
    profileId: null,
    sessionId: 1,
  };

  const mockTrainerUser: AuthenticatedUser = {
    id: 10,
    roleId: 2,
    userType: 'trainer',
    profileId: 5,
    email: 'trainer@luxeknox.com',
    phoneNumber: null,
    sessionId: 2,
  };

  const mockMemberUser: AuthenticatedUser = {
    id: 20,
    roleId: 4,
    userType: 'member',
    profileId: 100,
    email: 'member@luxeknox.com',
    phoneNumber: null,
    sessionId: 3,
  };

  const samplePhoto: ProgressPhoto = {
    id: 1,
    member_id: 100,
    photo_url: 'https://storage.luxeknox.com/photos/front.jpg',
    pose: 'front',
    taken_date: '2026-01-01',
    is_private: true,
    created_at: new Date('2026-01-01T00:00:00Z'),
  };

  const sampleNote: ProgressNote = {
    id: 1,
    member_id: 100,
    author_user_id: 20,
    note_text: 'Feeling stronger this week.',
    note_type: 'member_note',
    created_at: new Date('2026-01-01T00:00:00Z'),
  };

  beforeEach(() => {
    const mockSettings = { getDefaultPageSize: vi.fn().mockResolvedValue(20) } as any;
    paginationHelper = new PaginationHelper(mockSettings);

    noteRepo = {
      findManyByMemberId: vi.fn().mockResolvedValue({ rows: [sampleNote], total: 1 }),
      create: vi.fn().mockImplementation(async (data) => ({ id: 1, ...data })),
      findById: vi.fn().mockResolvedValue(sampleNote),
    };

    photoRepo = {
      findManyByMemberId: vi.fn().mockResolvedValue({ rows: [samplePhoto], total: 1 }),
      findById: vi.fn().mockResolvedValue(samplePhoto),
      create: vi.fn().mockImplementation(async (data) => ({ id: 1, ...data })),
      delete: vi.fn().mockResolvedValue(undefined),
      deleteById: vi.fn().mockResolvedValue(undefined),
      findComparisonByDates: vi.fn().mockResolvedValue([
        samplePhoto,
        {
          id: 2,
          member_id: 100,
          photo_url: 'https://storage.luxeknox.com/photos/front_feb.jpg',
          pose: 'front',
          taken_date: '2026-02-01',
          is_private: true,
          created_at: new Date('2026-02-01T00:00:00Z'),
        },
      ]),
      findAllFiltered: vi.fn().mockResolvedValue({ rows: [], total: 0 }),
    };

    memberRepo = {
      findById: vi.fn().mockImplementation(async (id) => {
        if (id === 100) {
          return { id: 100, assigned_trainer_id: 5, user_id: 20 };
        }
        return null;
      }),
    };

    auditService = {
      recordAudit: vi.fn().mockResolvedValue(undefined),
    };

    const permissionCache = {
      hasPermission: vi.fn().mockImplementation(async (roleId: number, slug: string) => {
        // By default roleId 1 (admin) has progress_photos.moderate
        return roleId === 1 && slug === 'progress_photos.moderate';
      }),
    } as any;

    noteService = new ProgressNoteService(noteRepo, memberRepo, paginationHelper, auditService);
    photoService = new ProgressPhotoService(
      photoRepo,
      memberRepo,
      paginationHelper,
      auditService,
      permissionCache,
    );
  });

  describe('Progress Notes Stream & Authorization (GOA-010)', () => {
    it('allows member to write member_note on self', async () => {
      const note = await noteService.createNote(
        100,
        {
          note_text: 'Great workout today',
          note_type: 'member_note',
        },
        mockMemberUser,
      );

      expect(note.id).toBe(1);
      expect(noteRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          member_id: 100,
          author_user_id: 20,
          note_type: 'member_note',
        }),
      );
    });

    it('rejects member attempting to write trainer_assessment', async () => {
      await expect(
        noteService.createNote(
          100,
          {
            note_text: 'Assessment note',
            note_type: 'trainer_assessment',
          },
          mockMemberUser,
        ),
      ).rejects.toThrow(ForbiddenError);
    });

    it('allows assigned trainer to write trainer_assessment', async () => {
      const note = await noteService.createNote(
        100,
        {
          note_text: 'Excellent squat depth and form',
          note_type: 'trainer_assessment',
        },
        mockTrainerUser,
      );

      expect(note).toBeDefined();
      expect(noteRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({
          author_user_id: 10,
          note_type: 'trainer_assessment',
        }),
      );
    });

    it('rejects unassigned trainer attempting to write assessment', async () => {
      const unassignedTrainer: AuthenticatedUser = {
        ...mockTrainerUser,
        profileId: 99,
      };

      await expect(
        noteService.createNote(
          100,
          {
            note_text: 'Assessment',
            note_type: 'trainer_assessment',
          },
          unassignedTrainer,
        ),
      ).rejects.toThrow(ForbiddenError);
    });
  });

  describe('Progress Photos & Privacy (GOA-011 & GOA-014)', () => {
    it('allows member to view their own private photos', async () => {
      const res = await photoService.listPhotos(100, {}, {}, mockMemberUser);
      expect(res.data).toHaveLength(1);
      expect(photoRepo.findManyByMemberId).toHaveBeenCalledWith(
        100,
        expect.objectContaining({ includePrivate: true }),
      );
    });

    it('allows assigned trainer to view private photos of client (FR-GOAL-009)', async () => {
      const res = await photoService.listPhotos(100, {}, {}, mockTrainerUser);
      expect(res.data).toHaveLength(1);
      expect(photoRepo.findManyByMemberId).toHaveBeenCalledWith(
        100,
        expect.objectContaining({ includePrivate: true }),
      );
    });

    it('rejects member attempting to view another member photos', async () => {
      await expect(
        photoService.listPhotos(200, {}, {}, mockMemberUser),
      ).rejects.toThrow(NotFoundError);
    });

    it('allows member to upload their own progress photo (FR-GOAL-009)', async () => {
      const created = await photoService.createPhoto(
        100,
        {
          photo_url: 'https://storage.luxeknox.com/photos/front_new.jpg',
          pose: 'front',
        },
        mockMemberUser,
      );
      expect(created).toBeDefined();
      expect(photoRepo.create).toHaveBeenCalled();
    });

    it('rejects trainer attempting to upload progress photo (FR-GOAL-009, P0.2.3)', async () => {
      await expect(
        photoService.createPhoto(
          100,
          {
            photo_url: 'https://storage.luxeknox.com/photos/front.jpg',
            pose: 'front',
          },
          mockTrainerUser,
        ),
      ).rejects.toThrow(ForbiddenError);
    });

    it('rejects admin attempting to upload progress photo (FR-GOAL-009, P0.2.3)', async () => {
      await expect(
        photoService.createPhoto(
          100,
          {
            photo_url: 'https://storage.luxeknox.com/photos/front.jpg',
            pose: 'front',
          },
          mockAdminUser,
        ),
      ).rejects.toThrow(ForbiddenError);
    });

    it('allows admin with progress_photos.moderate to view private photos and delete photo (P0.3.4)', async () => {
      const res = await photoService.listPhotos(100, {}, {}, mockAdminUser);
      expect(photoRepo.findManyByMemberId).toHaveBeenCalledWith(
        100,
        expect.objectContaining({ includePrivate: true }),
      );

      await photoService.deletePhoto(1, mockAdminUser);
      expect(photoRepo.deleteById).toHaveBeenCalledWith(1);
    });

    it('omits private photos and blocks delete for admin WITHOUT progress_photos.moderate (P0.3.4)', async () => {
      const unmoderatedAdmin: AuthenticatedUser = {
        ...mockAdminUser,
        roleId: 99, // role without progress_photos.moderate
      };

      await photoService.listPhotos(100, {}, {}, unmoderatedAdmin);
      expect(photoRepo.findManyByMemberId).toHaveBeenCalledWith(
        100,
        expect.objectContaining({ includePrivate: false }),
      );

      await expect(photoService.deletePhoto(1, unmoderatedAdmin)).rejects.toThrow(ForbiddenError);
    });

    it('allows owner member to delete own progress photo', async () => {
      await photoService.deletePhoto(1, mockMemberUser);
      expect(photoRepo.deleteById).toHaveBeenCalledWith(1);
      expect(auditService.recordAudit).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'delete', entityName: 'progress_photos' }),
      );
    });

    it('rejects non-owner trainer attempting to delete progress photo', async () => {
      await expect(
        photoService.deletePhoto(1, mockTrainerUser),
      ).rejects.toThrow(ForbiddenError);
    });
  });

  describe('Two-Date Comparison Queries (GOA-012)', () => {
    it('returns structured comparison side-by-side across two dates and poses', async () => {
      const comparison = await photoService.getComparison(
        100,
        {
          date1: '2026-01-01',
          date2: '2026-02-01',
        },
        mockMemberUser,
      );

      expect(comparison.date1).toBe('2026-01-01');
      expect(comparison.date2).toBe('2026-02-01');
      expect(comparison.date1_photos).toHaveLength(1);
      expect(comparison.date2_photos).toHaveLength(1);
      expect(comparison.comparison_by_pose.front?.date1?.photo_url).toContain('front.jpg');
      expect(comparison.comparison_by_pose.front?.date2?.photo_url).toContain('front_feb.jpg');
    });
  });

  describe('Progress Photos Vault (P0.5.3)', () => {
    it('allows admin with progress_photos.moderate to view vault including private photos (P0.5.3)', async () => {
      const res = await photoService.listAllPhotos({}, { pose: 'front' }, mockAdminUser);
      expect(res.data).toBeDefined();
      expect(photoRepo.findAllFiltered).toHaveBeenCalledWith(
        expect.objectContaining({
          pose: 'front',
          includePrivate: true,
        }),
      );
    });

    it('filters out private photos in vault for admin without progress_photos.moderate', async () => {
      const unmoderatedAdmin: AuthenticatedUser = {
        ...mockAdminUser,
        roleId: 99,
      };

      await photoService.listAllPhotos({}, {}, unmoderatedAdmin);
      expect(photoRepo.findAllFiltered).toHaveBeenCalledWith(
        expect.objectContaining({
          includePrivate: false,
        }),
      );
    });

    it('rejects trainer or member attempting to list progress photos vault', async () => {
      await expect(photoService.listAllPhotos({}, {}, mockTrainerUser)).rejects.toThrow(
        ForbiddenError,
      );
      await expect(photoService.listAllPhotos({}, {}, mockMemberUser)).rejects.toThrow(
        ForbiddenError,
      );
    });
  });
});
