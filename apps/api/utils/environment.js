function isDevelopment() {
  const environment = process.env.NODE_ENV || 'production';
  return environment === 'development';
}

module.exports = {
  isDevelopment
};