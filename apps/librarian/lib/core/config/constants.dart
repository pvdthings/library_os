const supabaseUrlKey = 'SUPABASE_URL';
const supabasePublicKeyKey = 'SUPABASE_PUBLIC_KEY';
const modeKey = 'MODE';

const supabaseUrl = String.fromEnvironment(supabaseUrlKey);
const supabasePublicKey = String.fromEnvironment(supabasePublicKeyKey);
const mode = String.fromEnvironment(modeKey, defaultValue: 'normal');
