const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_PUBLIC_KEY);

const authenticateToken = async (req, res, next) => {
    const accessToken = req.headers['x-access-token'];

    const { data: { user }, error } = await supabase.auth.getUser(accessToken);

    if (error || !user) {
        console.error(`Invalid Token`);
        res.status(401).send();
        return;
    }

    req.user = user;
    next();
}

module.exports = authenticateToken;