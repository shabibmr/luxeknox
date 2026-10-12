import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { REQUIRE_PERMISSIONS_KEY } from '../rbac/require-permission.decorator';
import { AccountsController } from './accounts.controller';
import {
  accountCreateSchema,
  accountUpdateSchema,
  type AccountDto,
} from './accounts.dto';
import { AccountsService } from './accounts.service';

const ADMIN_USER: AuthenticatedUser = {
  id: 1,
  email: 'admin@luxeknox.test',
  phoneNumber: null,
  userType: 'admin',
  roleId: 2,
  profileId: null,
  sessionId: 1,
};

const SAMPLE_ACCOUNT: AccountDto = {
  id: 10,
  code: '5000',
  name: 'Rent',
  account_type: 'expense',
  parent_id: null,
  is_active: true,
  is_bank: false,
  is_control: false,
  control_role: null,
  created_at: new Date('2026-04-01T00:00:00.000Z'),
  updated_at: null,
};

describe('AccountsController', () => {
  let service: Partial<AccountsService>;
  let controller: AccountsController;

  beforeEach(() => {
    service = {
      list: vi.fn().mockResolvedValue({ data: [SAMPLE_ACCOUNT], meta: {} }),
      getById: vi.fn().mockResolvedValue(SAMPLE_ACCOUNT),
      create: vi.fn().mockResolvedValue(SAMPLE_ACCOUNT),
      update: vi.fn().mockResolvedValue({ ...SAMPLE_ACCOUNT, name: 'Office Rent' }),
    };
    controller = new AccountsController(service as AccountsService);
  });

  it('requires accounting.read on GET /accounting/accounts and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, AccountsController.prototype.list),
    ).toEqual(['accounting.read']);

    const query = { account_type: 'expense' };
    const result = await controller.list(query, ADMIN_USER);

    expect(service.list).toHaveBeenCalledWith(query, ADMIN_USER);
    expect(result.data).toEqual([SAMPLE_ACCOUNT]);
  });

  it('requires accounting.accounts_write on POST /accounting/accounts and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, AccountsController.prototype.create),
    ).toEqual(['accounting.accounts_write']);

    const dto = {
      code: '5000',
      name: 'Rent',
      account_type: 'expense' as const,
      is_active: true,
      is_bank: false,
      is_control: false,
    };
    const result = await controller.create(dto, ADMIN_USER);

    expect(service.create).toHaveBeenCalledWith(dto, ADMIN_USER);
    expect(result).toEqual(SAMPLE_ACCOUNT);
  });

  it('requires accounting.read on GET /accounting/accounts/:id and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, AccountsController.prototype.getById),
    ).toEqual(['accounting.read']);

    const result = await controller.getById(10, ADMIN_USER);

    expect(service.getById).toHaveBeenCalledWith(10, ADMIN_USER);
    expect(result).toEqual(SAMPLE_ACCOUNT);
  });

  it('requires accounting.accounts_write on PATCH /accounting/accounts/:id and delegates', async () => {
    expect(
      Reflect.getMetadata(REQUIRE_PERMISSIONS_KEY, AccountsController.prototype.update),
    ).toEqual(['accounting.accounts_write']);

    const dto = { name: 'Office Rent' };
    const result = await controller.update(10, dto, ADMIN_USER);

    expect(service.update).toHaveBeenCalledWith(10, dto, ADMIN_USER);
    expect(result.name).toBe('Office Rent');
  });

  it('rejects create body with invalid account_type in validation pipe', () => {
    const pipe = new ZodValidationPipe(accountCreateSchema);

    expect(() =>
      pipe.transform(
        {
          code: '5000',
          name: 'Rent',
          account_type: 'invalid_type',
        },
        { type: 'body' } as never,
      ),
    ).toThrow();
  });

  it('rejects create body missing code or name in validation pipe', () => {
    const pipe = new ZodValidationPipe(accountCreateSchema);

    expect(() =>
      pipe.transform(
        {
          account_type: 'expense',
        },
        { type: 'body' } as never,
      ),
    ).toThrow();
  });

  it('validates update body in validation pipe', () => {
    const pipe = new ZodValidationPipe(accountUpdateSchema);

    const valid = pipe.transform(
      {
        name: 'New Rent',
        is_active: false,
      },
      { type: 'body' } as never,
    );
    expect(valid).toEqual({
      name: 'New Rent',
      is_active: false,
    });
  });
});
