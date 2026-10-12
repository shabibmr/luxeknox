// pm2 process definition for the LuxeKnox TEST API (api.luxeknox.com/test/).
'use strict';

const API_DEPLOY_DIR = process.env.TEST_API_DEPLOY_DIR || '/var/www/luxeknox-api-test';

module.exports = {
  apps: [
    {
      name: 'luxeknox-api-test',
      cwd: API_DEPLOY_DIR,
      script: 'dist/main.js',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production',
        PORT: process.env.TEST_API_PORT || 3011,
      },
      max_memory_restart: '300M',
      out_file: '/var/log/pm2/luxeknox-api-test-out.log',
      error_file: '/var/log/pm2/luxeknox-api-test-error.log',
      time: true,
    },
  ],
};
