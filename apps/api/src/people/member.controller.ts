import {
  Body,
  Controller,
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
  ApiQuery,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { CurrentUser } from '../auth/current-user.decorator';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { RequirePermission } from '../rbac/require-permission.decorator';
import { ZodValidationPipe } from '../platform/http/zod-validation.pipe';
import {
  assignTrainerSchema,
  memberCreateSchema,
  memberUpdateSchema,
  type AssignTrainerDto,
  type MemberCreateDto,
  type MemberUpdateDto,
} from './member.dto';
import { MemberService, type MemberDossier } from './member.service';
import type { Member } from '../platform/db/schema/members';

export class MemberResponseDto {
  @ApiProperty({ type: Number }) id!: number;
  @ApiProperty({ type: Number }) user_id!: number;
  @ApiProperty({ type: String }) membership_number!: string;
  @ApiProperty({ type: String }) first_name!: string;
  @ApiProperty({ type: String }) last_name!: string;
  @ApiProperty({ type: String, nullable: true }) gender!: string | null;
  @ApiProperty({ type: String, nullable: true }) date_of_birth!: string | null;
  @ApiProperty({ type: String, nullable: true }) address!: string | null;
  @ApiProperty({ type: Number, nullable: true }) assigned_trainer_id!: number | null;
  @ApiProperty({ type: String }) joined_date!: string;
  @ApiProperty({ type: String, nullable: true }) notes!: string | null;
}

export class MemberDossierResponseDto extends MemberResponseDto {
  /** MEMB domain stub — always null in Vertical 3. */
  @ApiProperty({ type: Object, nullable: true, required: false, example: null })
  membership!: null;
  @ApiProperty({ type: Object, nullable: true, required: false, example: null })
  outstanding_balance!: null;
  @ApiProperty({ type: Object, nullable: true, required: false, example: null })
  last_check_in!: null;
  @ApiProperty({ type: Object, nullable: true, required: false, example: null })
  next_schedule!: null;
}

export class MemberPageMetaDto {
  @ApiProperty({ type: Number }) limit!: number;
  @ApiProperty({ type: Number, nullable: true }) offset!: number | null;
  @ApiProperty({ type: String, nullable: true }) cursor!: string | null;
  @ApiProperty({ type: String, nullable: true }) next_cursor!: string | null;
  @ApiProperty({ type: Boolean }) has_more!: boolean;
  @ApiProperty({ type: Number, required: false }) total?: number;
}

export class MemberPageResponseDto {
  @ApiProperty({ type: [MemberResponseDto] }) data!: MemberResponseDto[];
  @ApiProperty({ type: MemberPageMetaDto }) meta!: MemberPageMetaDto;
}

@ApiTags('PEOPLE')
@ApiBearerAuth('bearer')
@Controller('members')
export class MemberController {
  constructor(private readonly memberService: MemberService) {}

  @Get()
  @RequirePermission('members.read')
  @ApiOperation({
    operationId: 'listMembers',
    summary: 'Member directory (scoped by role)',
  })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiQuery({ name: 'offset', required: false, type: Number })
  @ApiQuery({ name: 'q', required: false, type: String })
  @ApiQuery({ name: 'status', required: false, type: String })
  @ApiQuery({ name: 'membership_status', required: false, type: String })
  @ApiQuery({ name: 'assigned_trainer_id', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MemberPageResponseDto })
  async list(
    @Query() query: Record<string, unknown>,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MemberPageResponseDto> {
    return this.memberService.list(query, currentUser);
  }

  @Post()
  @RequirePermission('members.create')
  @HttpCode(201)
  @ApiOperation({
    operationId: 'createMember',
    summary: 'Onboard a member (user + profile, one transaction)',
  })
  @ApiResponse({ status: 201, description: 'OK', type: MemberResponseDto })
  async create(
    @Body(new ZodValidationPipe(memberCreateSchema)) dto: MemberCreateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<Member> {
    return this.memberService.create(dto, currentUser);
  }

  @Get(':id')
  @RequirePermission('members.read')
  @ApiOperation({
    operationId: 'getMember',
    summary: 'Member dossier (role-scoped)',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MemberDossierResponseDto })
  @ApiResponse({ status: 404, description: 'Member not found' })
  async getById(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<MemberDossier> {
    return this.memberService.getById(id, currentUser);
  }

  @Patch(':id')
  @RequirePermission('members.update')
  @ApiOperation({
    operationId: 'updateMember',
    summary: 'Update member profile',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MemberResponseDto })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(memberUpdateSchema)) dto: MemberUpdateDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<Member> {
    return this.memberService.update(id, dto, currentUser);
  }

  @Post(':id/assign-trainer')
  @RequirePermission('members.update')
  @HttpCode(200)
  @ApiOperation({
    operationId: 'assignTrainer',
    summary: 'Assign or reassign a trainer',
  })
  @ApiParam({ name: 'id', type: Number })
  @ApiResponse({ status: 200, description: 'OK', type: MemberResponseDto })
  @ApiResponse({ status: 422, description: 'Capacity or inactive trainer' })
  async assignTrainer(
    @Param('id', ParseIntPipe) id: number,
    @Body(new ZodValidationPipe(assignTrainerSchema)) dto: AssignTrainerDto,
    @CurrentUser() currentUser: AuthenticatedUser,
  ): Promise<Member> {
    return this.memberService.assignTrainer(id, dto, currentUser);
  }
}
