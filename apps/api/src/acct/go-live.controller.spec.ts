import { beforeEach, describe, expect, it, vi } from 'vitest';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { BadRequestError } from '../platform/errors/app-error';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { GoLiveController } from './go-live.controller';
import {
  enablePostingSchema,
  mapPaymentMethodSchema,
  type GoLiveChecklistResponseDto,
  type GoLivePaymentMethodDto,
  type UnearnedPreviewResponseDto,
} from './go-live.dto';
import { GoLiveService } from './go-live.service';

const SAMPLE_CHECKLIST: GoLiveChecklistResponseDto = {
  go_live_date: '2026-03-01',
  posting_enabled: false,
  can_enable: true,
  failing_reasons: [],
  opening_journal_found: true,
  opening_journal_matches: true,
  unearned_membership: {
    preview: '1000.00',
    actual: '1000.00',
    matched: true,
  },
  unearned_pt: {
    preview: '2000.00',
    actual: '2000.00',
    matched: true,
  },
  tax_match: {
    gym_tax_rate: '18.00',
    default_tax_code: 'gst_18',
    default_tax_rate: '18.00',
    matched: true,
  },
  payment_methods: [
    {
      id: 1,
      method_name: 'Cash',
      is_active: true,
      is_digital: false,
      account_id: 1000,
      account_code: '1000',
      account_name: 'Cash on Hand',
    },
  ],
};

const SAMPLE_PREVIEW: UnearnedPreviewResponseDto = {
  go_live_date: '2026-03-01',
  totals: {
    unearned_membership_total: '1000.00',
    unearned_pt_total: '2000.00',
    combined_total: '3000.00',
  },
  items: [],
};

const SAMPLE_PAYMENT_METHOD: GoLivePaymentMethodDto = {
  id: 1,
  method_name: 'Cash',
  is_active: true,
  is_digital: false,
  account_id: 1000,
  account_code: '1000',
  account_name: 'Cash on Hand',
};

describe('GoLiveController (ACC-099)', () => {
  let service: Partial<GoLiveService>;
  let controller: GoLiveController;

  beforeEach(() => {
    service = {
      getGoLiveChecklist: vi.fn().mockResolvedValue(SAMPLE_CHECKLIST),
      getUnearnedPreview: vi.fn().mockResolvedValue(SAMPLE_PREVIEW),
      mapPaymentMethodAccount: vi.fn().mockResolvedValue(SAMPLE_PAYMENT_METHOD),
      enablePosting: vi.fn().mockResolvedValue({ success: true, posting_enabled: true }),
    };
    controller = new GoLiveController(service as GoLiveService);
  });

  describe('getGoLiveChecklist', () => {
    it('requires accounting.read permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          GoLiveController.prototype.getGoLiveChecklist,
        ),
      ).toEqual(['accounting.read']);

      const result = await controller.getGoLiveChecklist('2026-03-01');

      expect(service.getGoLiveChecklist).toHaveBeenCalledWith('2026-03-01');
      expect(result).toEqual(SAMPLE_CHECKLIST);
    });
  });

  describe('getUnearnedPreview', () => {
    it('requires accounting.read permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          GoLiveController.prototype.getUnearnedPreview,
        ),
      ).toEqual(['accounting.read']);

      const result = await controller.getUnearnedPreview('2026-03-01');

      expect(service.getUnearnedPreview).toHaveBeenCalledWith('2026-03-01');
      expect(result).toEqual(SAMPLE_PREVIEW);
    });
  });

  describe('mapPaymentMethodAccount', () => {
    it('requires accounting.accounts_write permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          GoLiveController.prototype.mapPaymentMethodAccount,
        ),
      ).toEqual(['accounting.accounts_write']);

      const result = await controller.mapPaymentMethodAccount(1, { account_id: 1000 });

      expect(service.mapPaymentMethodAccount).toHaveBeenCalledWith(1, 1000);
      expect(result).toEqual(SAMPLE_PAYMENT_METHOD);
    });

    it('validates request body via ZodValidationPipe', () => {
      const pipe = new ZodValidationPipe(mapPaymentMethodSchema);

      expect(pipe.transform({ account_id: 1000 }, {} as any)).toEqual({ account_id: 1000 });
      expect(pipe.transform({ account_id: null }, {} as any)).toEqual({ account_id: null });

      expect(() => pipe.transform({ account_id: -1 }, {} as any)).toThrow(BadRequestError);
      expect(() => pipe.transform({ account_id: 'bad' }, {} as any)).toThrow(BadRequestError);
    });
  });

  describe('enablePosting', () => {
    it('requires accounting.posting_toggle permission and delegates to service', async () => {
      expect(
        Reflect.getMetadata(
          REQUIRE_PERMISSIONS_KEY,
          GoLiveController.prototype.enablePosting,
        ),
      ).toEqual(['accounting.posting_toggle']);

      const result = await controller.enablePosting({ go_live_date: '2026-03-01' });

      expect(service.enablePosting).toHaveBeenCalledWith('2026-03-01');
      expect(result).toEqual({ success: true, posting_enabled: true });
    });

    it('handles call with empty or undefined body', async () => {
      const result = await controller.enablePosting(undefined);

      expect(service.enablePosting).toHaveBeenCalledWith(undefined);
      expect(result).toEqual({ success: true, posting_enabled: true });
    });

    it('validates request body via ZodValidationPipe', () => {
      const pipe = new ZodValidationPipe(enablePostingSchema.optional().default({}));

      expect(pipe.transform({}, {} as any)).toEqual({});
      expect(pipe.transform(undefined, {} as any)).toEqual({});
      expect(pipe.transform({ go_live_date: '2026-03-01' }, {} as any)).toEqual({
        go_live_date: '2026-03-01',
      });

      expect(() => pipe.transform({ go_live_date: 'invalid-date' }, {} as any)).toThrow(
        BadRequestError,
      );
    });
  });
});
