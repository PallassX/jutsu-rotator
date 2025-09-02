-- Supabase Database Schema for Telegram Rotator (FIXED VERSION)
-- Run this SQL in your Supabase SQL Editor

-- Drop existing tables if they exist (be careful in production!)
-- DROP TABLE IF EXISTS global_settings CASCADE;
-- DROP TABLE IF EXISTS rotation_admins CASCADE;

-- Create rotation_admins table
CREATE TABLE IF NOT EXISTS rotation_admins (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  link TEXT NOT NULL,
  enabled BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create global_settings table for master toggle
CREATE TABLE IF NOT EXISTS global_settings (
  id SERIAL PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  value JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default global settings with proper JSONB values
INSERT INTO global_settings (key, value) 
VALUES 
  ('rotate_enabled', 'true'::jsonb),
  ('current_rotation_index', '0'::jsonb)
ON CONFLICT (key) DO UPDATE SET 
  value = EXCLUDED.value,
  updated_at = NOW();

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
DROP TRIGGER IF EXISTS update_rotation_admins_updated_at ON rotation_admins;
CREATE TRIGGER update_rotation_admins_updated_at 
  BEFORE UPDATE ON rotation_admins 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_global_settings_updated_at ON global_settings;
CREATE TRIGGER update_global_settings_updated_at 
  BEFORE UPDATE ON global_settings 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE rotation_admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE global_settings ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow public read access to rotation_admins" ON rotation_admins;
DROP POLICY IF EXISTS "Allow public read access to global_settings" ON global_settings;
DROP POLICY IF EXISTS "Allow all operations on rotation_admins" ON rotation_admins;
DROP POLICY IF EXISTS "Allow all operations on global_settings" ON global_settings;

-- Create policies for public read access (for the public page)
CREATE POLICY "Allow public read access to rotation_admins" 
  ON rotation_admins FOR SELECT 
  USING (true);

CREATE POLICY "Allow public read access to global_settings" 
  ON global_settings FOR SELECT 
  USING (true);

-- Create policies for admin access (you may want to add authentication later)
-- For now, allowing all operations - you should secure this in production
CREATE POLICY "Allow all operations on rotation_admins" 
  ON rotation_admins FOR ALL 
  USING (true);

CREATE POLICY "Allow all operations on global_settings" 
  ON global_settings FOR ALL 
  USING (true);

-- Insert some sample data (optional) - only if table is empty
INSERT INTO rotation_admins (name, link, enabled, sort_order) 
SELECT * FROM (VALUES
  ('hany', 'https://t.me/hanyjutsu?text=doneregister', true, 1),
  ('naylie', 'https://t.me/nayliejutsu?text=doneregister', true, 2),
  ('sofia', 'https://t.me/sofiyagfs?text=doneregister', false, 3)
) AS v(name, link, enabled, sort_order)
WHERE NOT EXISTS (SELECT 1 FROM rotation_admins LIMIT 1);

-- Verify the setup
SELECT 'Setup completed successfully!' as status;
SELECT 'Global settings:' as info, key, value FROM global_settings;
SELECT 'Rotation admins:' as info, COUNT(*) as count FROM rotation_admins;
