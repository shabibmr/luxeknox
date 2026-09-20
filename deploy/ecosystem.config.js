// pm2 process definition for the LuxeKnox API.
// Start:   pm2 start deploy/ecosystem.config.js
// Reload:  pm2 reload luxeknox-api --update-env
'use strict';

const path = require('path');

module.exports = {
  apps: [
    {
      name: 'luxeknox-api',
      cwd: path.join(__dirname, '..', 'apps', 'api'),
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
