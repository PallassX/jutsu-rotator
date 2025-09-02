# Supabase Setup Guide for Telegram Rotator

## 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - **Name**: `telegram-rotator` (or any name you prefer)
   - **Database Password**: Choose a strong password
   - **Region**: Choose closest to your users
5. Click "Create new project"
6. Wait for the project to be created (usually takes 1-2 minutes)

## 2. Get Your Project Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL** (looks like: `https://your-project-id.supabase.co`)
   - **anon public** key (starts with `eyJ...`)

## 3. Update Configuration

1. Open `supabase-config.js` in your project
2. Replace the placeholder values:

```javascript
const SUPABASE_CONFIG = {
  url: 'https://your-project-id.supabase.co', // Replace with your Project URL
  anonKey: 'eyJ...' // Replace with your anon public key
};
```

## 4. Set Up Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Copy and paste the entire content from `supabase-schema.sql`
4. Click "Run" to execute the SQL

This will create:
- `rotation_admins` table for storing admin links
- `global_settings` table for master toggle
- Sample data (optional)

## 5. Configure Row Level Security (RLS)

The schema includes RLS policies that allow:
- **Public read access** for the public page (index.html)
- **Full access** for admin operations (admin.html)

⚠️ **Security Note**: The current setup allows full access to everyone. For production, you should:
- Add authentication (Supabase Auth)
- Restrict admin operations to authenticated users only
- Use service role key for admin operations

## 6. Test the Setup

1. Open `admin.html` in your browser
2. You should see "✅ Data berjaya dimuatkan dari Supabase"
3. Try adding a new admin
4. Open `index.html` to test the rotation

## 7. Optional: Environment Variables

For better security, you can use environment variables:

```javascript
const SUPABASE_CONFIG = {
  url: process.env.SUPABASE_URL || 'YOUR_SUPABASE_URL',
  anonKey: process.env.SUPABASE_ANON_KEY || 'YOUR_SUPABASE_ANON_KEY'
};
```

## Troubleshooting

### Common Issues:

1. **"Failed to load settings from Supabase"**
   - Check your URL and API key in `supabase-config.js`
   - Ensure the database schema was created successfully

2. **"Error loading rotation admins"**
   - Verify the `rotation_admins` table exists
   - Check RLS policies are set correctly

3. **CORS errors**
   - Make sure you're serving the files from a web server (not file://)
   - Use a local server like `python -m http.server` or Live Server

### Database Schema Verification:

Run this query in Supabase SQL Editor to verify tables exist:

```sql
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('rotation_admins', 'global_settings');
```

## Next Steps

- Add authentication for admin panel security
- Implement real-time updates using Supabase subscriptions
- Add backup/export functionality
- Set up monitoring and logging
