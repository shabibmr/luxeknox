import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  Post,
  Put,
  Query,
  Req,
  Res,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiProperty,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import type { Request, Response } from 'express';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { Public } from '../auth/public.decorator';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { BadRequestError } from '../platform/errors/app-error';
import { mediaUploadRequestSchema, type MediaUploadRequestDto } from './media.dto';
import { StorageService } from './storage.service';

export class MediaUploadResponseDto {
  @ApiProperty({ type: String }) url!: string;
  @ApiProperty({ type: String }) object_key!: string;
  @ApiProperty({ type: String }) expires_at!: string;
}

export class MediaDownloadResponseDto {
  @ApiProperty({ type: String }) url!: string;
  @ApiProperty({ type: String }) expires_at!: string;
}

@ApiTags('MEDIA')
@Controller('media')
export class MediaController {
  constructor(private readonly storageService: StorageService) {}

  /**
   * Local-disk signed PUT target (ADR-0008). Auth is HMAC query signature, not Bearer.
   * Declared before `:key` so Nest does not treat `objects` as a media key.
   */
  @Put('objects')
  @Public()
  @HttpCode(204)
  @ApiOperation({ summary: 'Local adapter signed PUT (not part of OpenAPI MEDIA contract)' })
  async putObject(
    @Query('key') key: string,
    @Query('expires') expires: string,
    @Query('sig') sig: string,
    @Query('content_type') contentType: string,
    @Req() req: Request,
  ): Promise<void> {
    if (!key || !expires || !sig || !contentType) {
      throw new BadRequestError('key, expires, sig, and content_type are required');
    }
    const chunks: Buffer[] = [];
    for await (const chunk of req) {
      chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
    }
    const body = Buffer.concat(chunks);
    await this.storageService.putLocalObject(
      decodeURIComponent(key),
      body,
      contentType,
      Number(expires),
      sig,
    );
  }

  /**
   * Local-disk signed GET target (ADR-0008). Auth is HMAC query signature, not Bearer.
   */
  @Get('objects')
  @Public()
  @ApiOperation({ summary: 'Local adapter signed GET (not part of OpenAPI MEDIA contract)' })
  async getObject(
    @Query('key') key: string,
    @Query('expires') expires: string,
    @Query('sig') sig: string,
    @Res() res: Response,
  ): Promise<void> {
    if (!key || !expires || !sig) {
      throw new BadRequestError('key, expires, and sig are required');
    }
    const { body, contentType } = await this.storageService.getLocalObject(
      decodeURIComponent(key),
      Number(expires),
      sig,
    );
    res.setHeader('Content-Type', contentType);
    res.status(200).send(body);
  }

  @Post('uploads')
  @ApiBearerAuth('bearer')
  @RequirePermission('media.create')
  @HttpCode(201)
  @ApiOperation({
    operationId: 'createMediaUpload',
    summary: 'Signed PUT slot (ADR-0008)',
  })
  @ApiResponse({ status: 201, type: MediaUploadResponseDto })
  async createUpload(
    @Body(new ZodValidationPipe(mediaUploadRequestSchema)) dto: MediaUploadRequestDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MediaUploadResponseDto> {
    return this.storageService.createUploadSlot(dto, currentUser);
  }

  @Get(':key')
  @ApiBearerAuth('bearer')
  @RequirePermission('media.read')
  @ApiOperation({
    operationId: 'getMediaUrl',
    summary: 'Short-lived signed GET (ADR-0008)',
  })
  @ApiResponse({ status: 200, type: MediaDownloadResponseDto })
  async getSignedUrl(
    @Param('key') key: string,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MediaDownloadResponseDto> {
    const objectKey = decodeURIComponent(key);
    return this.storageService.createSignedGet(objectKey, currentUser);
  }
}
