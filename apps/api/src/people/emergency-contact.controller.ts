import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiProperty,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  emergencyContactUpdateSchema,
  emergencyContactWriteSchema,
  type EmergencyContactUpdateDto,
  type EmergencyContactWriteDto,
} from './emergency-contact.dto';
import { EmergencyContactService } from './emergency-contact.service';
import type { EmergencyContact } from '../platform/db/schema/members';

export class EmergencyContactResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) user_id!: number;
  @ApiProperty({ type: String }) contact_name!: string;
  @ApiProperty({ type: String, nullable: true }) relationship!: string | null;
  @ApiProperty({ type: String }) phone_primary!: string;
  @ApiProperty({ type: String, nullable: true }) phone_secondary!: string | null;
  @ApiProperty({ type: Boolean }) is_primary!: boolean;
}

@ApiTags('HEALTH')
@ApiBearerAuth('bearer')
@Controller('users/:id/emergency-contacts')
export class EmergencyContactController {
  constructor(private readonly emergencyContactService: EmergencyContactService) {}

  @Get()
  @RequirePermission('health.read')
  @ApiOperation({
    operationId: 'listEmergencyContacts',
    summary: 'Emergency contacts for a user',
  })
  @ApiParam({ name: 'id', type: Number })
  async list(
    @Param('id', ParseIntPipe) userId: number,
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ) {
    return this.emergencyContactService.list(userId, query, currentUser);
  }

  @Post()
  @RequirePermission('health.update')
  @HttpCode(201)
  @ApiOperation({
    operationId: 'createEmergencyContact',
    summary: 'Add an emergency contact',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 201, type: EmergencyContactResponseDto })
  async create(
    @Param('id', ParseIntPipe) userId: number,
    @Body(new ZodValidationPipe(emergencyContactWriteSchema)) dto: EmergencyContactWriteDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<EmergencyContact> {
    return this.emergencyContactService.create(userId, dto, currentUser);
  }

  @Patch(':contactId')
  @RequirePermission('health.update')
  @ApiOperation({
    operationId: 'updateEmergencyContact',
    summary: 'Update an emergency contact',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'contactId', type: Number })
  @ApiResponse({ status: 200, type: EmergencyContactResponseDto })
  async update(
    @Param('id', ParseIntPipe) userId: number,
    @Param('contactId', ParseIntPipe) contactId: number,
    @Body(new ZodValidationPipe(emergencyContactUpdateSchema))
    dto: EmergencyContactUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<EmergencyContact> {
    return this.emergencyContactService.update(userId, contactId, dto, currentUser);
  }

  @Delete(':contactId')
  @RequirePermission('health.update')
  @HttpCode(204)
  @ApiOperation({
    operationId: 'deleteEmergencyContact',
    summary: 'Delete an emergency contact',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiParam({ name: 'contactId', type: Number })
  async remove(
    @Param('id', ParseIntPipe) userId: number,
    @Param('contactId', ParseIntPipe) contactId: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<void> {
    await this.emergencyContactService.remove(userId, contactId, currentUser);
  }
}
