-- Supabase Database Schema for Telegram Rotator
-- Run this SQL in your Supabase SQL Editor

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

-- Insert default global settings
INSERT INTO global_settings (key, value) 
VALUES ('rotate_enabled', 'true')
ON CONFLICT (key) DO NOTHING;

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_rotation_admins_updated_at 
  BEFORE UPDATE ON rotation_admins 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_global_settings_updated_at 
  BEFORE UPDATE ON global_settings 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE rotation_admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE global_settings ENABLE ROW LEVEL SECURITY;

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

-- Insert some sample data (optional)
INSERT INTO rotation_admins (name, link, enabled, sort_order) VALUES
  ('hany', 'https://t.me/hanyjutsu?text=doneregister', true, 1),
  ('naylie', 'https://t.me/nayliejutsu?text=doneregister', true, 2),
  ('sofia', 'https://t.me/sofiyagfs?text=doneregister', false, 3)
ON CONFLICT DO NOTHING;
