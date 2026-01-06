/*
  # Apple Accounts Management System - Complete Schema

  ## Overview
  Creates a fully customizable Trello-like system for managing Apple accounts with:
  - Custom statuses with colors
  - Dynamic fields with multiple types
  - Multiple views (Kanban/List)
  - Advanced filtering and sorting

  ## New Tables

  ### 1. `statuses`
  Customizable status columns for kanban board
  - `id` (uuid, primary key) - Unique status identifier
  - `name` (text, unique) - Status name
  - `color` (text) - Display color (watermelon theme colors)
  - `position` (integer) - Sort order
  - `is_default` (boolean) - Whether this is a system default
  - `created_at` (timestamptz) - Creation timestamp

  ### 2. `accounts`
  Main table for Apple account records
  - `id` (uuid, primary key) - Unique account identifier
  - `name` (text) - Account name
  - `description` (text) - Account description
  - `color` (text) - Display color
  - `icon` (text) - Icon identifier
  - `status_id` (uuid, foreign key) - References statuses table
  - `position` (integer) - Sort order
  - `created_at` (timestamptz) - Record creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 3. `field_definitions`
  Defines custom fields/columns
  - `id` (uuid, primary key) - Unique field identifier
  - `name` (text) - Field name
  - `field_type` (text) - Type: text, number, date, select, multiselect, checkbox, url, email, phone
  - `options` (jsonb) - Configuration for select/multiselect fields
  - `is_required` (boolean) - Whether field is mandatory
  - `position` (integer) - Display order
  - `created_at` (timestamptz) - Creation timestamp

  ### 4. `field_values`
  Stores actual values for custom fields
  - `id` (uuid, primary key) - Unique value identifier
  - `account_id` (uuid, foreign key) - References accounts table
  - `field_id` (uuid, foreign key) - References field_definitions table
  - `value` (jsonb) - Actual field value
  - `created_at` (timestamptz) - Value creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ## Security
  - Enable RLS on all tables
  - Public access for demo purposes
  - In production, restrict to authenticated users

  ## Indexes
  - Index on foreign keys for performance
  - Index on position fields for sorting
  - Index on status_id for filtering
*/

-- Create statuses table
CREATE TABLE IF NOT EXISTS statuses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  color text DEFAULT '#10b981',
  position integer DEFAULT 0,
  is_default boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create accounts table
CREATE TABLE IF NOT EXISTS accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  color text DEFAULT '#10b981',
  icon text DEFAULT '🍎',
  status_id uuid REFERENCES statuses(id) ON DELETE SET NULL,
  position integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create field_definitions table
CREATE TABLE IF NOT EXISTS field_definitions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  field_type text NOT NULL DEFAULT 'text',
  options jsonb DEFAULT '[]'::jsonb,
  is_required boolean DEFAULT false,
  position integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Create field_values table
CREATE TABLE IF NOT EXISTS field_values (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id uuid NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  field_id uuid NOT NULL REFERENCES field_definitions(id) ON DELETE CASCADE,
  value jsonb DEFAULT 'null'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(account_id, field_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_accounts_status_id ON accounts(status_id);
CREATE INDEX IF NOT EXISTS idx_accounts_position ON accounts(position);
CREATE INDEX IF NOT EXISTS idx_field_values_account_id ON field_values(account_id);
CREATE INDEX IF NOT EXISTS idx_field_values_field_id ON field_values(field_id);
CREATE INDEX IF NOT EXISTS idx_field_definitions_position ON field_definitions(position);
CREATE INDEX IF NOT EXISTS idx_statuses_position ON statuses(position);

-- Enable Row Level Security
ALTER TABLE statuses ENABLE ROW LEVEL SECURITY;
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE field_definitions ENABLE ROW LEVEL SECURITY;
ALTER TABLE field_values ENABLE ROW LEVEL SECURITY;

-- Policies for statuses
CREATE POLICY "Anyone can view statuses"
  ON statuses FOR SELECT
  USING (true);

CREATE POLICY "Anyone can insert statuses"
  ON statuses FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update statuses"
  ON statuses FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Anyone can delete statuses"
  ON statuses FOR DELETE
  USING (true);

-- Policies for accounts
CREATE POLICY "Anyone can view accounts"
  ON accounts FOR SELECT
  USING (true);

CREATE POLICY "Anyone can insert accounts"
  ON accounts FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update accounts"
  ON accounts FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Anyone can delete accounts"
  ON accounts FOR DELETE
  USING (true);

-- Policies for field_definitions
CREATE POLICY "Anyone can view field definitions"
  ON field_definitions FOR SELECT
  USING (true);

CREATE POLICY "Anyone can insert field definitions"
  ON field_definitions FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update field definitions"
  ON field_definitions FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Anyone can delete field definitions"
  ON field_definitions FOR DELETE
  USING (true);

-- Policies for field_values
CREATE POLICY "Anyone can view field values"
  ON field_values FOR SELECT
  USING (true);

CREATE POLICY "Anyone can insert field values"
  ON field_values FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update field values"
  ON field_values FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Anyone can delete field values"
  ON field_values FOR DELETE
  USING (true);

-- Insert default statuses with watermelon colors
INSERT INTO statuses (name, color, position, is_default) VALUES
  ('Active', '#10b981', 0, true),
  ('In Review', '#f59e0b', 1, true),
  ('Suspended', '#ef4444', 2, true),
  ('Archived', '#6b7280', 3, true)
ON CONFLICT (name) DO NOTHING;

-- Insert default field definitions
INSERT INTO field_definitions (name, field_type, options, position) VALUES
  ('Apple ID', 'email', '[]'::jsonb, 0),
  ('Devices', 'multiselect', '["iPhone", "iPad", "MacBook", "Apple Watch", "AirPods", "Apple TV", "HomePod"]'::jsonb, 1),
  ('iCloud Storage', 'select', '["5GB", "50GB", "200GB", "2TB"]'::jsonb, 2),
  ('Purchase Date', 'date', '[]'::jsonb, 3),
  ('Subscription', 'select', '["None", "Apple One", "Apple Music", "iCloud+", "Apple TV+"]'::jsonb, 4),
  ('Family Sharing', 'checkbox', '[]'::jsonb, 5),
  ('Contact', 'phone', '[]'::jsonb, 6),
  ('Notes', 'text', '[]'::jsonb, 7),
  ('Monthly Cost', 'number', '[]'::jsonb, 8),
  ('Region', 'select', '["USA", "UK", "Canada", "Europe", "Asia", "Other"]'::jsonb, 9)
ON CONFLICT DO NOTHING;

-- Insert sample accounts
DO $$
DECLARE
  active_status_id uuid;
  review_status_id uuid;
BEGIN
  SELECT id INTO active_status_id FROM statuses WHERE name = 'Active' LIMIT 1;
  SELECT id INTO review_status_id FROM statuses WHERE name = 'In Review' LIMIT 1;

  INSERT INTO accounts (name, description, color, icon, status_id, position) VALUES
    ('John''s Account', 'Primary family account with all devices', '#10b981', '👤', active_status_id, 0),
    ('Sarah''s Account', 'Work account for iPad and MacBook', '#3b82f6', '👩‍💼', active_status_id, 1),
    ('Kids Account', 'Shared account for children devices', '#f59e0b', '👶', review_status_id, 2)
  ON CONFLICT DO NOTHING;
END $$;
