import { Module, forwardRef } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { AuthController } from './auth.controller';
import { MeController } from './me.controller';
import { AuthService } from './auth.service';
import { SessionRepository } from './session.repository';
import { UserRepository } from './user.repository';
import { SessionCache } from './session.cache';
import { LoginThrottle } from './login-throttle';
import { AuthGuard } from './auth.guard';
import { PasswordResetTokenRepository } from './password-reset-token.repository';
import { RbacModule } from '../rbac/rbac.module';
import { PeopleModule } from '../people/people.module';
import { PlatformModule } from '../platform/platform.module';

@Module({
  imports: [RbacModule, PlatformModule, forwardRef(() => PeopleModule)],
  controllers: [AuthController, MeController],
  providers: [
    AuthService,
    SessionRepository,
    UserRepository,
    SessionCache,
    LoginThrottle,
    AuthGuard,
    PasswordResetTokenRepository,
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
  ],
  exports: [
    AuthService,
    SessionRepository,
    UserRepository,
    SessionCache,
    LoginThrottle,
    AuthGuard,
  ],
})
export class AuthModule {}
