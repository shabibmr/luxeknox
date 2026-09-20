import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiParam, ApiProperty, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import { memberPhotoWriteSchema, type MemberPhotoWriteDto } from './member-photo.dto';
import { MemberPhotoService } from './member-photo.service';
import type { MemberPhoto } from '../platform/db/schema/member-photos';

export class MemberPhotoResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) member_id!: number;
  @ApiProperty({ type: String }) photo_url!: string;
  @ApiProperty({ type: Boolean }) is_current_avatar!: boolean;
}

@ApiTags('HEALTH')
@ApiBearerAuth('bearer')
@Controller('members/:id/photos')
export class MemberPhotoController {
  constructor(private readonly memberPhotoService: MemberPhotoService) {}

  @Get()
  @RequirePermission('health.read')
  @ApiOperation({ operationId: 'listMemberPhotos', summary: 'Member gallery' })
  @ApiParam({ name: 'id', type: Number })
  async list(
    @Param('id', ParseIntPipe) memberId: number,
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.memberPhotoService.list(memberId, query, currentUser);
  }

  @Post()
  @RequirePermission('health.update')
  @HttpCode(201)
  @ApiOperation({ operationId: 'createMemberPhoto', summary: 'Add a gallery photo' })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 201, type: MemberPhotoResponseDto })
  async create(
    @Param('id', ParseIntPipe) memberId: number,
    @Body(new ZodValidationPipe(memberPhotoWriteSchema)) dto: MemberPhotoWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MemberPhoto> {
    return this.memberPhotoService.create(memberId, dto, currentUser);
  }

  @Post(':photoId/avatar')
  @RequirePermission('health.update')
  @ApiOperation({
    operationId: 'setMemberAvatar',
    summary: 'Set current avatar from a gallery shot',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'photoId', type: Number })
  @ApiResponse({ status: 200, type: MemberPhotoResponseDto })
  async setAvatar(
    @Param('id', ParseIntPipe) memberId: number,
    @Param('photoId', ParseIntPipe) photoId: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MemberPhoto> {
    return this.memberPhotoService.setAvatar(memberId, photoId, currentUser);
  }
}
