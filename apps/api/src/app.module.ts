import { Module } from '@nestjs/common';
import { PlatformModule } from './platform/platform.module';
import { HealthModule } from './platform/health/health.module';
import { DrizzleModule } from './platform/db/drizzle.module';
import { SysModule } from './sys/sys.module';
import { AuthModule } from './auth/auth.module';
import { RbacModule } from './rbac/rbac.module';
import { WorkModule } from './work/work.module';

@Module({
  imports: [
    DrizzleModule.forRoot(),
    PlatformModule,
    HealthModule,
    SysModule,
    AuthModule,
    RbacModule,
    WorkModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}


