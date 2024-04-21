const { isAdmin } = require('../services/auth');

const authorizeAdminUser = async (req, res, next) => {
  const adminWhitelist = process.env.ADMIN_WHITELIST;
  const userEmail = res.locals.user?.email;

  if (adminWhitelist && (!userEmail || !isAdmin(userEmail))) {
    res.status(403).send({ error: 'Not authorized' });
    return;
  }

  next();
};

module.exports = authorizeAdminUser;