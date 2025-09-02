-- Migration script to add current_rotation_index to existing database
-- Run this in your Supabase SQL Editor if you already have the database set up

-- Insert the current_rotation_index setting if it doesn't exist
INSERT INTO global_settings (key, value) 
VALUES ('current_rotation_index', '0')
ON CONFLICT (key) DO NOTHING;
