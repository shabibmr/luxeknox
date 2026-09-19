import {
  Body,
  Controller,
  Headers,
  HttpCode,
  HttpStatus,
  Post,
  Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import type { Request } from 'express';
import { AuthService } from './auth.service';
import { AuthResponseDto, LoginDto, RefreshTokenDto, loginSchema, refreshTokenSchema } from './auth.dto';
import { UnauthorizedError } from '../platform/errors/app-error';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Authenticate user with identifier and password',
    description:
      'Validates credentials, checks rate limiting, and returns an opaque access token and refresh token pair.',
  })
  @ApiResponse({
    status: 200,
    description: 'Authentication successful',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Invalid credentials or inactive account',
  })
  @ApiResponse({
    status: 429,
    description: 'Rate limit exceeded for identifier or IP',
  })
  async login(
    @Body(new ZodValidationPipe(loginSchema)) dto: LoginDto,
    @Req() req: Request,
  ): Promise<AuthResponseDto> {
    const ipAddress =
      (req.headers['x-forwarded-for'] as string)?.split(',')[0]?.trim() ??
      req.ip ??
      req.socket.remoteAddress ??
      'unknown';

    return this.authService.login(dto.identifier, dto.password, ipAddress);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Refresh access token with refresh token rotation',
    description:
      'Validates refresh token, detects reuse of revoked tokens across family, and returns a new token pair.',
  })
  @ApiResponse({
    status: 200,
    description: 'Token refreshed successfully',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Invalid, expired, or reused refresh token',
  })
  async refresh(
    @Body(new ZodValidationPipe(refreshTokenSchema)) dto: RefreshTokenDto,
  ): Promise<AuthResponseDto> {
    return this.authService.refresh(dto.refreshToken);
  }

  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth('bearer')
  @ApiOperation({
    summary: 'Revoke active session and logout',
    description:
      'Revokes the session corresponding to the provided Bearer access token and invalidates cache.',
  })
  @ApiResponse({
    status: 204,
    description: 'Session revoked successfully',
  })
  @ApiResponse({
    status: 401,
    description: 'Bearer token missing or malformed',
  })
  async logout(@Headers('authorization') authHeader?: string): Promise<void> {
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedError('Bearer token is required for logout');
    }

    const token = authHeader.substring('Bearer '.length).trim();
    if (!token) {
      throw new UnauthorizedError('Bearer token is required for logout');
    }

    await this.authService.logout(token);
  }
}
