import { it } from 'vitest';
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../src/app.module';
it('boot', async () => {
  try { const app = await NestFactory.create(AppModule, { logger: ['error'], abortOnError: false }); await app.init(); await app.close(); }
  catch (e: any) { console.log('BOOTERR', e?.message, e?.stack?.split('\n').slice(0,6).join('\n')); }
}, 60000);
