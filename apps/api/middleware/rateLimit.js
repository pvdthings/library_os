const rateLimit = require('express-rate-limit');

const minutes = process.env.RATE_LIMIT_WINDOW_MINUTES || 15;
const failedAttempts = process.env.RATE_LIMIT_FAILED_ATTEMPTS || 5;

const limit = rateLimit({
  windowMs: minutes * 60 * 1000, // 15 minutes
  limit: failedAttempts,
  skipSuccessfulRequests: true,
});

module.exports = limit;