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
import type { AuthenticatedUser } from './auth.guard';
import { CurrentUser } from './current-user.decorator';
import { Public } from './public.decorator';
import { AuthService } from './auth.service';
import {
  AuthResponseDto,
  LoginDto,
  RefreshTokenDto,
  loginSchema,
  refreshTokenSchema,
  changePasswordSchema,
  forgotPasswordSchema,
  resetPasswordSchema,
  type ChangePasswordDto,
  type ForgotPasswordDto,
  type ResetPasswordDto,
} from './auth.dto';
import { UnauthorizedError } from '../platform/errors/app-error';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { RequirePermission } from '../rbac/require-permission.decorator';

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
    const ipAddress = req.ip ?? req.socket.remoteAddress ?? 'unknown';

    const identifier = (
      dto.identifier ||
      dto.email ||
      dto.phone_number ||
      dto.phoneNumber ||
      ''
    ).trim();

    return this.authService.login(identifier, dto.password, ipAddress);
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
    const token = (dto.refreshToken || dto.refresh_token || '').trim();
    return this.authService.refresh(token);
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

  @Post('password/change')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth('bearer')
  @RequirePermission('users.update')
  @ApiOperation({
    summary: 'Change password; invalidates other sessions',
    description: 'Verifies the current password, sets a new one, and revokes every other active session.',
  })
  @ApiResponse({ status: 204, description: 'No content' })
  async changePassword(
    @CurrentUser() currentUser: AuthenticatedUser,
    @Body(new ZodValidationPipe(changePasswordSchema)) dto: ChangePasswordDto,
  ): Promise<void> {
    await this.authService.changePassword(currentUser, dto);
  }

  @Post('password/forgot')
  @Public()
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Request a password-reset token',
    description: 'Always returns 204, regardless of whether the identifier matches an account.',
  })
  @ApiResponse({ status: 204, description: 'No content' })
  async forgotPassword(
    @Body(new ZodValidationPipe(forgotPasswordSchema)) dto: ForgotPasswordDto,
  ): Promise<void> {
    await this.authService.forgotPassword(dto);
  }

  @Post('password/reset')
  @Public()
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Consume a one-time reset token',
    description: 'Sets a new password from a valid reset token and revokes every active session.',
  })
  @ApiResponse({ status: 204, description: 'No content' })
  async resetPassword(
    @Body(new ZodValidationPipe(resetPasswordSchema)) dto: ResetPasswordDto,
  ): Promise<void> {
    await this.authService.resetPassword(dto);
  }
}
