// Supabase Configuration
// Replace these with your actual Supabase project credentials
const SUPABASE_CONFIG = {
  url: 'https://jsbzlhpswguznsasdopp.supabase.co', // e.g., 'https://your-project.supabase.co'
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzYnpsaHBzd2d1em5zYXNkb3BwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4MDEwMTMsImV4cCI6MjA3MjM3NzAxM30.zUpEsdkU37uj9Owo4fqdGBHBlMGb5KYi-NkWPXDXrdM' // Your public anon key
};

// Initialize Supabase client
const { createClient } = supabase;
const supabaseClient = createClient(SUPABASE_CONFIG.url, SUPABASE_CONFIG.anonKey);

// Database table name
const ROTATION_TABLE = 'rotation_admins';
