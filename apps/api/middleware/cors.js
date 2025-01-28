const { isDevelopment } = require('../utils/environment');

const allowedOrigins = process.env.ACCESS_CONTROL_ALLOW_ORIGIN.split(',');

const corsOptions = Object.freeze({
  allowedHeaders: [
      'Origin',
      'x-api-key',
      'X-Requested-With',
      'Content-Type',
      'Accept',
      'x-access-token'
  ],
  credentials: true,
  origin: (origin, callback) => {
      if (allowedOrigins.includes(origin) || !origin || isDevelopment()) {
          callback(null, true);
      } else {
          console.log('origin', origin);
          callback(new Error('CORS Error'));
      }
  }
});

const cors = require('cors')(corsOptions);

module.exports = cors;