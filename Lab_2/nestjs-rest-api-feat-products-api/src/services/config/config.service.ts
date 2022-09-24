import { Injectable, Scope } from '@nestjs/common';
import * as dotenv from 'dotenv';
dotenv.config();

@Injectable({ scope: Scope.DEFAULT })
export class ConfigService {
  constructor() {}

  getAppConfig() {
    return {
      env: process.env.NODE_ENV || 'development',
      appPort: process.env.APP_PORT,
    };
  }
}
