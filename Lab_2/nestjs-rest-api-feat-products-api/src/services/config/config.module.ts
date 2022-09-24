import { Global, Module } from '@nestjs/common';
import { ConfigService } from './config.service';
require('dotenv');

@Global()
@Module({
  providers: [ConfigService],
  exports: [ConfigService],
})
export class ConfigModule {}
