import { ApiProperty } from '@nestjs/swagger';
import { z } from 'zod';

// ==========================================
// Login DTO & Schema
// ==========================================

export const loginSchema = z.object({
  identifier: z
    .string()
    .min(1, 'Email or phone number is required')
    .max(255, 'Identifier cannot exceed 255 characters'),
  password: z
    .string()
    .min(1, 'Password is required')
    .max(255, 'Password cannot exceed 255 characters'),
});

export type LoginInput = z.infer<typeof loginSchema>;

export class LoginDto implements LoginInput {
  @ApiProperty({
    type: String,
    example: 'member@luxeknox.com',
    description: 'User email address or registered phone number',
  })
  identifier!: string;

  @ApiProperty({
    type: String,
    example: 'P@ssword123!',
    description: 'Plaintext account password',
  })
  password!: string;
}

// ==========================================
// Refresh Token DTO & Schema
// ==========================================

export const refreshTokenSchema = z.object({
  refreshToken: z
    .string()
    .min(1, 'Refresh token is required')
    .startsWith('gk_rt_', 'Refresh token must start with gk_rt_'),
});

export type RefreshTokenInput = z.infer<typeof refreshTokenSchema>;

export class RefreshTokenDto implements RefreshTokenInput {
  @ApiProperty({
    type: String,
    example: 'gk_rt_abcdef123456...',
    description: 'Opaque refresh token prefixed with gk_rt_',
  })
  refreshToken!: string;
}

// ==========================================
// Auth Response DTO & Schema
// ==========================================

export const authResponseSchema = z.object({
  accessToken: z.string(),
  refreshToken: z.string(),
  tokenType: z.literal('Bearer'),
  expiresIn: z.literal(1800),
});

export type AuthResponse = z.infer<typeof authResponseSchema>;

export class AuthResponseDto implements AuthResponse {
  @ApiProperty({
    type: String,
    example: 'gk_at_xyz789...',
    description: 'Opaque 256-bit access token valid for 30 minutes (1800 seconds)',
  })
  accessToken!: string;

  @ApiProperty({
    type: String,
    example: 'gk_rt_abc123...',
    description: 'Opaque 256-bit refresh token valid for 30 days (sliding)',
  })
  refreshToken!: string;

  @ApiProperty({
    type: String,
    example: 'Bearer',
    enum: ['Bearer'],
    description: 'HTTP Authorization header token type',
  })
  tokenType!: 'Bearer';

  @ApiProperty({
    type: Number,
    example: 1800,
    description: 'Access token expiration lifespan in seconds (30 minutes)',
  })
  expiresIn!: 1800;
}
