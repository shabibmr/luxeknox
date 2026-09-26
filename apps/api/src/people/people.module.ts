import { Module, forwardRef } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { EmergencyContactController } from './emergency-contact.controller';
import { EmergencyContactRepository } from './emergency-contact.repository';
import { EmergencyContactService } from './emergency-contact.service';
import { EmployeeController } from './employee.controller';
import { EmployeeRepository } from './employee.repository';
import { EmployeeService } from './employee.service';
import { MemberController } from './member.controller';
import { MemberRepository } from './member.repository';
import { MemberService } from './member.service';
import { MemberDocumentController } from './member-document.controller';
import { MemberDocumentRepository } from './member-document.repository';
import { MemberDocumentService } from './member-document.service';
import { MemberHealthController } from './member-health.controller';
import { MemberHealthRepository } from './member-health.repository';
import { MemberHealthService } from './member-health.service';
import { MedicalHistoryController } from './medical-history.controller';
import { MedicalHistoryRepository } from './medical-history.repository';
import { MedicalHistoryService } from './medical-history.service';
import { MemberPhotoController } from './member-photo.controller';
import { MemberPhotoRepository } from './member-photo.repository';
import { MemberPhotoService } from './member-photo.service';
import { PersonFactory } from './person.factory';
import { TrainerController } from './trainer.controller';
import { TrainerRepository } from './trainer.repository';
import { TrainerService } from './trainer.service';

@Module({
  imports: [PlatformModule, RbacModule, forwardRef(() => AuthModule)],
  controllers: [
    MemberController,
    TrainerController,
    EmployeeController,
    EmergencyContactController,
    MemberHealthController,
    MedicalHistoryController,
    MemberDocumentController,
    MemberPhotoController,
  ],
  providers: [
    PersonFactory,
    MemberRepository,
    MemberService,
    TrainerRepository,
    TrainerService,
    EmployeeRepository,
    EmployeeService,
    EmergencyContactRepository,
    EmergencyContactService,
    MemberHealthRepository,
    MemberHealthService,
    MedicalHistoryRepository,
    MedicalHistoryService,
    MemberDocumentRepository,
    MemberDocumentService,
    MemberPhotoRepository,
    MemberPhotoService,
  ],
  exports: [
    PersonFactory,
    MemberRepository,
    MemberService,
    TrainerRepository,
    TrainerService,
    EmployeeRepository,
    EmployeeService,
    EmergencyContactRepository,
    EmergencyContactService,
    MemberHealthRepository,
    MemberHealthService,
    MedicalHistoryRepository,
    MedicalHistoryService,
    MemberDocumentRepository,
    MemberDocumentService,
    MemberPhotoRepository,
    MemberPhotoService,
  ],
})
export class PeopleModule {}
