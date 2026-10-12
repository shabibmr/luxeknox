import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { TaxCodesController } from './tax-codes.controller';
import {
  taxCodeCreateSchema,
  taxCodeUpdateSchema,
  type TaxCodeDto,
} from './tax-codes.dto';
import { TaxCodesService } from './tax-codes.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SAMPLE_TAX_CODE: TaxCodeDto = {
  id: 2,
  name: 'GST 18%',
  code: 'gst_18',
  rate_percent: '18.00',
  is_active: true,
  components: [
    {
      id: 1,
      tax_code_id: 2,
      name: 'CGST',
      rate_percent: '9.00',
      output_account_id: 2100,
      input_account_id: 1300,
    },
    {
      id: 2,
      tax_code_id: 2,
      name: 'SGST',
      rate_percent: '9.00',
      output_account_id: 2110,
      input_account_id: 1300,
    },
  ],
};

describe('TaxCodesController', () => {
  let service: Partial<TaxCodesService>;
  let controller: TaxCodesController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({ data: [SAMPLE_TAX_CODE], meta: {} }),
      getById: vi.fn().mockResolvedValue(SAMPLE_TAX_CODE),
      create: vi.fn().mockResolvedValue(SAMPLE_TAX_CODE),
      update: vi.fn().mockResolvedValue({ ...SAMPLE_TAX_CODE, name: 'Updated GST' }),
    };
    controller = new TaxCodesController(service as TaxCodesService);
  });

  it('requires accounting.read on GET /accounting/tax-codes and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, TaxCodesController.prototype.list),
    ).toEqual(['accounting.read']);

    const query = { is_active: 'true' };
    const result = await controller.list(query, ADMIN_USER);

    expect(service.list).toHaveBeenCalledWith(query, ADMIN_USER);
    expect(result.data).toEqual([SAMPLE_TAX_CODE]);
  });

  it('requires accounting.accounts_write on POST /accounting/tax-codes and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, TaxCodesController.prototype.create),
    ).toEqual(['accounting.accounts_write']);

    const dto = {
      name: 'GST 18%',
      code: 'gst_18',
      rate_percent: '18.00',
      is_active: true,
      components: [
        {
          name: 'CGST',
          rate_percent: '9.00',
          output_account_id: 2100,
          input_account_id: 1300,
        },
      ],
    };
    const result = await controller.create(dto, ADMIN_USER);

    expect(service.create).toHaveBeenCalledWith(
      expect.objectContaining({
        code: 'gst_18',
        rate_percent: '18.00',
      }),
      ADMIN_USER,
    );
    expect(result).toEqual(SAMPLE_TAX_CODE);
  });

  it('requires accounting.read on GET /accounting/tax-codes/:id and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, TaxCodesController.prototype.getById),
    ).toEqual(['accounting.read']);

    const result = await controller.getById(2, ADMIN_USER);

    expect(service.getById).toHaveBeenCalledWith(2, ADMIN_USER);
    expect(result).toEqual(SAMPLE_TAX_CODE);
  });

  it('requires accounting.accounts_write on PATCH /accounting/tax-codes/:id and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, TaxCodesController.prototype.update),
    ).toEqual(['accounting.accounts_write']);

    const dto = { name: 'Updated GST' };
    const result = await controller.update(2, dto, ADMIN_USER);

    expect(service.update).toHaveBeenCalledWith(2, dto, ADMIN_USER);
    expect(result.name).toBe('Updated GST');
  });

  it('rejects create body missing required fields in validation pipe', () => {
    const pipe = new ZodValidationPipe(taxCodeCreateSchema);

    expect(() =>
      pipe.transform(
        {
          name: 'GST',
        },
        { type: 'body' } as never,
      ),
    ).toThrow();
  });

  it('rejects create body with rate_percent greater than 100 in validation pipe', () => {
    const pipe = new ZodValidationPipe(taxCodeCreateSchema);

    expect(() =>
      pipe.transform(
        {
          name: 'Super Tax',
          code: 'super_tax',
          rate_percent: '150.00',
        },
        { type: 'body' } as never,
      ),
    ).toThrow();
  });

  it('validates update body in validation pipe', () => {
    const pipe = new ZodValidationPipe(taxCodeUpdateSchema);

    const valid = pipe.transform(
      {
        name: 'New Tax Name',
        rate_percent: 18,
      },
      { type: 'body' } as never,
    );
    expect(valid).toEqual({
      name: 'New Tax Name',
      rate_percent: '18.00',
    });
  });
});
