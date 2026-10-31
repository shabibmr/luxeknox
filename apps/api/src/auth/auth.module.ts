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
import { FirebaseTokenVerifier } from './firebase-token-verifier';
import { RbacModule } from '../rbac/rbac.module';
import { PermissionGuard } from '../rbac/permission.guard';
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
    FirebaseTokenVerifier,
    // Both global guards are registered here, in this order, on purpose: Nest runs
    // APP_GUARDs in module-scan order, so splitting them across modules made the
    // order depend on which feature module happened to import RbacModule first.
    // PermissionGuard needs `request.user`, which AuthGuard sets.
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
    {
      provide: APP_GUARD,
      useClass: PermissionGuard,
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
