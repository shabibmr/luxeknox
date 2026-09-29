// pm2 process definition for the LuxeKnox API.
// Start:   pm2 start deploy/ecosystem.config.js
// Reload:  pm2 reload luxeknox-api --update-env
'use strict';

const API_DEPLOY_DIR = process.env.API_DEPLOY_DIR || '/var/www/luxeknox-api';

module.exports = {
  apps: [
    {
      name: 'luxeknox-api',
      cwd: API_DEPLOY_DIR,
      script: 'dist/main.js',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production',
        PORT: process.env.API_PORT || 3010,
      },
      max_memory_restart: '300M',
      out_file: '/var/log/pm2/luxeknox-api-out.log',
      error_file: '/var/log/pm2/luxeknox-api-error.log',
      time: true,
    },
  ],
};
