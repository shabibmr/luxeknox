import { Module, forwardRef } from '@nestjs/common';
import { PeopleModule } from '../people/people.module';
import { PlatformModule } from '../platform/platform.module';
import { RbacModule } from '../rbac/rbac.module';
import { ParQController } from './par-q.controller';
import { ParQRepository } from './par-q.repository';
import { ParQService } from './par-q.service';

@Module({
  imports: [PlatformModule, RbacModule, forwardRef(() => PeopleModule)],
  controllers: [ParQController],
  providers: [ParQRepository, ParQService],
  exports: [ParQRepository, ParQService],
})
export class ParQModule {}
