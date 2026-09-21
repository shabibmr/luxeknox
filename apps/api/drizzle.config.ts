export interface DrizzleConfig {
  schema: string;
  out: string;
  dialect: 'postgresql';
  dbCredentials?: {
    host?: string;
    port?: number;
    user?: string;
    password?: string;
    database?: string;
    url?: string;
  };
}

const config: DrizzleConfig = {
  schema: './src/platform/db/schema',
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: {
    host: process.env.DB_HOST || '127.0.0.1',
    port: Number(process.env.DB_PORT) || 5432,
    user: process.env.DB_USER || 'luxeknox',
    password: process.env.DB_PASSWORD || 'luxeknox_secret',
    database: process.env.DB_NAME || 'luxeknox',
  },
};

export default config;
