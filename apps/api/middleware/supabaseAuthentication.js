const { createClient } = require('@supabase/supabase-js');
const { isWhitelisted } = require('../services/auth');

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_PUB_ANON_KEY, {
  auth: {
      autoRefreshToken: false, // All my Supabase access is from server, so no need to refresh the token
      detectSessionInUrl: false, // We are not using OAuth, so we don't need this. Also, we are manually "detecting" the session in the server-side code
      persistSession: false, // All our access is from server, so no need to persist the session to browser's local storage
  }
});

const authenticateToken = async (req, res, next) => {
    const environment = process.env.NODE_ENV || 'development';

    if (req.method === 'OPTIONS' || environment === 'development') {
        next();
        return;
    }

    const accessToken = req.headers['supabase-access-token'];
    const refreshToken = req.headers['supabase-refresh-token'];

    await supabase.auth.setSession({
        refresh_token: refreshToken,
        access_token: accessToken,
    });

    const session = await supabase.auth.getSession();
    const user = await supabase.auth.getUser();

    if (session.data.session && isWhitelisted(user.data.user.email)) {
        res.locals.user = user.data.user;
        next();
    } else {
        console.error(`Invalid Token:\t ${session.error || 'NO ENTRY'}`)
        res.status(401).send();
    }
}

module.exports = authenticateToken;