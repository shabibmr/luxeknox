import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { NestFactory } from '@nestjs/core';
import pino from 'pino';
import pinoHttp from 'pino-http';
import { AppModule } from './app.module';
import { ZodValidationPipe } from './platform/http/zod-validation.pipe';

export { ZodValidationPipe };

async function bootstrap() {
  const logger = pino({
    level: process.env.LOG_LEVEL || 'info',
    transport:
      process.env.NODE_ENV !== 'production'
        ? {
            target: 'pino-pretty',
            options: {
              colorize: true,
              singleLine: true,
            },
          }
        : undefined,
  });

  const app = await NestFactory.create(AppModule, {
    logger: ['error', 'warn', 'log', 'debug', 'verbose'],
  });

  app.use(pinoHttp({ logger }));

  app.enableCors();

  app.setGlobalPrefix('v1');

  app.useGlobalPipes(new ZodValidationPipe());

  const swaggerConfig = new DocumentBuilder()
    .setTitle('LuxeKnox API')
    .setDescription('LuxeKnox backend spine and core platform services API')
    .setVersion('0.1.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'Opaque (gk_at_*)',
        description: 'Provide your opaque access token prefixed with gk_at_',
      },
      'bearer',
    )
    .build();

  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('v1/docs', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);
  logger.info(`LuxeKnox API listening on port ${port} (prefix: /v1, docs: /v1/docs)`);
}

if (process.env.NODE_ENV !== 'test') {
  bootstrap();
}
