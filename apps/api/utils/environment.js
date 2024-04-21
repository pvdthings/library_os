function isDevelopment() {
  const environment = process.env.NODE_ENV || 'development';
  return environment === 'development';
}

module.exports = {
  isDevelopment
};