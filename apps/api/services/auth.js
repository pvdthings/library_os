const isAdmin = (email) => {
    const whitelist = process.env.ADMIN_WHITELIST.split(' ');
    return whitelist.includes(email);
};

module.exports = {
    isAdmin
};