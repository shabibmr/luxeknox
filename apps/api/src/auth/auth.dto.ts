import { ApiProperty } from '@nestjs/swagger';
import { z } from 'zod';

// ==========================================
// Login DTO & Schema
// ==========================================

const loginIdentifierField = z
  .string()
  .trim()
  .min(1, 'Email or phone number is required')
  .max(255, 'Identifier cannot exceed 255 characters');

export const loginSchema = z
  .object({
    identifier: loginIdentifierField.optional(),
    email: loginIdentifierField.optional(),
    phone_number: loginIdentifierField.optional(),
    phoneNumber: loginIdentifierField.optional(),
    password: z
      .string()
      .min(1, 'Password is required')
      .max(255, 'Password cannot exceed 255 characters'),
  })
  .refine(
    (data) => !!(data.identifier || data.email || data.phone_number || data.phoneNumber),
    {
      message: 'Email or phone number is required',
      path: ['identifier'],
    },
  );

export type LoginInput = z.infer<typeof loginSchema>;

export class LoginDto {
  @ApiProperty({
    type: String,
    example: 'member@luxeknox.com',
    required: false,
    description: 'User email address or registered phone number',
  })
  identifier?: string;

  @ApiProperty({
    type: String,
    example: 'member@luxeknox.com',
    required: false,
    description: 'User email address',
  })
  email?: string;

  @ApiProperty({
    type: String,
    example: '+1234567890',
    required: false,
    description: 'User registered phone number',
  })
  phone_number?: string;

  @ApiProperty({
    type: String,
    example: '+1234567890',
    required: false,
    description: 'User registered phone number (camelCase alias)',
  })
  phoneNumber?: string;

  @ApiProperty({
    type: String,
    example: 'P@ssword123!',
    description: 'Plaintext account password',
  })
  password!: string;
}

// ==========================================
// Password Management DTOs & Schemas
// ==========================================

export const changePasswordSchema = z.object({
  current_password: z.string().min(1, 'Current password is required'),
  new_password: z.string().min(8, 'New password must be at least 8 characters').max(255),
});

export type ChangePasswordDto = z.infer<typeof changePasswordSchema>;

export const forgotPasswordSchema = z
  .object({
    email: z.string().trim().email().optional(),
    phone_number: z.string().trim().min(1).optional(),
  })
  .refine((data) => !!(data.email || data.phone_number), {
    message: 'Email or phone number is required',
    path: ['email'],
  });

export type ForgotPasswordDto = z.infer<typeof forgotPasswordSchema>;

export const resetPasswordSchema = z.object({
  token: z.string().min(1, 'Reset token is required'),
  new_password: z.string().min(8, 'New password must be at least 8 characters').max(255),
});

export type ResetPasswordDto = z.infer<typeof resetPasswordSchema>;

// ==========================================
// Refresh Token DTO & Schema
// ==========================================

export const refreshTokenSchema = z
  .object({
    refreshToken: z.string().optional(),
    refresh_token: z.string().optional(),
  })
  .refine(
    (data) => {
      const token = data.refreshToken || data.refresh_token;
      return !!token && token.startsWith('gk_rt_');
    },
    {
      message: 'Refresh token must start with gk_rt_',
      path: ['refreshToken'],
    },
  );

export type RefreshTokenInput = z.infer<typeof refreshTokenSchema>;

export class RefreshTokenDto {
  @ApiProperty({
    type: String,
    example: 'gk_rt_abcdef123456...',
    required: false,
    description: 'Opaque refresh token prefixed with gk_rt_',
  })
  refreshToken?: string;

  @ApiProperty({
    type: String,
    example: 'gk_rt_abcdef123456...',
    required: false,
    description: 'Opaque refresh token prefixed with gk_rt_ (snake_case alias)',
  })
  refresh_token?: string;
}

// ==========================================
// Auth Response DTO & Schema
// ==========================================

export const principalSchema = z.object({
  user_id: z.number(),
  user_type: z.string(),
  role: z.string(),
  role_id: z.number().optional(),
  profile_id: z.number().nullable().optional(),
  permissions: z.array(z.string()),
});

export const authResponseSchema = z.object({
  accessToken: z.string(),
  access_token: z.string().optional(),
  refreshToken: z.string(),
  refresh_token: z.string().optional(),
  tokenType: z.literal('Bearer'),
  token_type: z.literal('Bearer').optional(),
  expiresIn: z.literal(1800),
  expires_in: z.literal(1800).optional(),
  principal: principalSchema.optional(),
});

export type AuthResponse = z.infer<typeof authResponseSchema>;

export class PrincipalDto {
  @ApiProperty({ type: Number, example: 1 })
  user_id!: number;

  @ApiProperty({ type: String, example: 'admin' })
  user_type!: string;

  @ApiProperty({ type: String, example: 'super_admin' })
  role!: string;

  @ApiProperty({ type: Number, example: 1, required: false })
  role_id?: number;

  @ApiProperty({ type: Number, nullable: true, required: false })
  profile_id?: number | null;

  @ApiProperty({ type: [String], example: ['members.read'] })
  permissions!: string[];
}

export class AuthResponseDto implements AuthResponse {
  @ApiProperty({
    type: String,
    example: 'gk_at_xyz789...',
    description: 'Opaque 256-bit access token valid for 30 minutes (1800 seconds)',
  })
  accessToken!: string;

  @ApiProperty({
    type: String,
    example: 'gk_at_xyz789...',
    required: false,
    description: 'Opaque access token (snake_case alias for OpenAPI client)',
  })
  access_token?: string;

  @ApiProperty({
    type: String,
    example: 'gk_rt_abc123...',
    description: 'Opaque 256-bit refresh token valid for 30 days (sliding)',
  })
  refreshToken!: string;

  @ApiProperty({
    type: String,
    example: 'gk_rt_abc123...',
    required: false,
    description: 'Opaque refresh token (snake_case alias for OpenAPI client)',
  })
  refresh_token?: string;

  @ApiProperty({
    type: String,
    example: 'Bearer',
    enum: ['Bearer'],
    description: 'HTTP Authorization header token type',
  })
  tokenType!: 'Bearer';

  @ApiProperty({
    type: String,
    example: 'Bearer',
    enum: ['Bearer'],
    required: false,
    description: 'HTTP Authorization header token type (snake_case alias)',
  })
  token_type?: 'Bearer';

  @ApiProperty({
    type: Number,
    example: 1800,
    description: 'Access token expiration lifespan in seconds (30 minutes)',
  })
  expiresIn!: 1800;

  @ApiProperty({
    type: Number,
    example: 1800,
    required: false,
    description: 'Access token expiration lifespan in seconds (snake_case alias)',
  })
  expires_in?: 1800;

  @ApiProperty({
    type: PrincipalDto,
    required: false,
    description: 'Authenticated principal summary',
  })
  principal?: PrincipalDto;
}
