const supabaseUrlKey = 'SUPABASE_URL';
const supabasePublicKeyKey = 'SUPABASE_PUBLIC_KEY';
const apiHostKey = 'API_HOST';
const apiKeyKey = 'API_KEY';
const appUrlKey = 'APP_URL';

const apiHost = String.fromEnvironment(apiHostKey);
const apiKey = String.fromEnvironment(apiKeyKey);
const supabaseUrl = String.fromEnvironment(supabaseUrlKey);
const supabasePublicKey = String.fromEnvironment(supabasePublicKeyKey);
