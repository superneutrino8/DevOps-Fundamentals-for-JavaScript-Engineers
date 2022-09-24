import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { CustomExceptionFilter } from './exception-filters/custom.exception-filter';
import { ConfigService } from './services/config/config.service';

async function bootstrap() {
  const configService = new ConfigService();
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(new ValidationPipe());
  app.useGlobalFilters(new CustomExceptionFilter());
  app.enableCors({
    origin: 'http://localhost:3000',
  });
  await app.listen(configService.getAppConfig().appPort || 3000);
}
bootstrap();
