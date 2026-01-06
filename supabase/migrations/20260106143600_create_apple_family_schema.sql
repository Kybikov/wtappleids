/*
  # Apple Family Manager - Database Schema

  ## Overview
  Creates a flexible Trello-like system for managing Apple families with dynamic fields,
  multiple views (Kanban/List), and advanced filtering capabilities.

  ## New Tables

  ### 1. `families`
  Main table for family records
  - `id` (uuid, primary key) - Unique family identifier
  - `name` (text) - Family name
  - `description` (text) - Family description
  - `color` (text) - Display color for visual organization
  - `icon` (text) - Icon identifier
  - `status` (text) - Current status (active, inactive, archived)
  - `position` (integer) - Sort order position
  - `created_at` (timestamptz) - Record creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 2. `field_definitions`
  Defines custom fields that can be added to families
  - `id` (uuid, primary key) - Unique field definition identifier
  - `name` (text) - Field name
  - `field_type` (text) - Type: text, number, date, select, multiselect, checkbox, url, email, phone
  - `options` (jsonb) - Configuration for select/multiselect fields
  - `is_required` (boolean) - Whether field is mandatory
  - `position` (integer) - Display order
  - `created_at` (timestamptz) - Field creation timestamp

  ### 3. `field_values`
  Stores actual values for custom fields
  - `id` (uuid, primary key) - Unique value identifier
  - `family_id` (uuid, foreign key) - References families table
  - `field_id` (uuid, foreign key) - References field_definitions table
  - `value` (jsonb) - Actual field value (flexible JSON storage)
  - `created_at` (timestamptz) - Value creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ## Security
  - Enable RLS on all tables
  - All tables are publicly accessible for this demo (authenticated users can perform all operations)
  - In production, you would restrict to specific users/teams

  ## Indexes
  - Index on family_id in field_values for faster lookups
  - Index on field_id in field_values for faster queries
  - Index on position fields for sorting
  - Index on status for filtering
*/

-- Create families table
CREATE TABLE IF NOT EXISTS families (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text DEFAULT '',
  color text DEFAULT '#0071e3',
  icon text DEFAULT '👨‍👩‍👧‍👦',
  status text DEFAULT 'active',
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
  family_id uuid NOT NULL REFERENCES families(id) ON DELETE CASCADE,
  field_id uuid NOT NULL REFERENCES field_definitions(id) ON DELETE CASCADE,
  value jsonb DEFAULT 'null'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(family_id, field_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_field_values_family_id ON field_values(family_id);
CREATE INDEX IF NOT EXISTS idx_field_values_field_id ON field_values(field_id);
CREATE INDEX IF NOT EXISTS idx_families_position ON families(position);
CREATE INDEX IF NOT EXISTS idx_families_status ON families(status);
CREATE INDEX IF NOT EXISTS idx_field_definitions_position ON field_definitions(position);

-- Enable Row Level Security
ALTER TABLE families ENABLE ROW LEVEL SECURITY;
ALTER TABLE field_definitions ENABLE ROW LEVEL SECURITY;
ALTER TABLE field_values ENABLE ROW LEVEL SECURITY;

-- Create policies for families table
CREATE POLICY "Anyone can view families"
  ON families FOR SELECT
  USING (true);

CREATE POLICY "Anyone can insert families"
  ON families FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update families"
  ON families FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Anyone can delete families"
  ON families FOR DELETE
  USING (true);

-- Create policies for field_definitions table
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

-- Create policies for field_values table
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

-- Insert some default field definitions
INSERT INTO field_definitions (name, field_type, position) VALUES
  ('Устройства', 'multiselect', 0),
  ('Дата покупки', 'date', 1),
  ('Гарантия до', 'date', 2),
  ('Стоимость', 'number', 3),
  ('Статус', 'select', 4),
  ('Контакт', 'phone', 5),
  ('Email', 'email', 6),
  ('Заметки', 'text', 7),
  ('Apple ID', 'email', 8),
  ('iCloud Storage', 'select', 9)
ON CONFLICT DO NOTHING;

-- Update select field options
UPDATE field_definitions
SET options = '["iPhone", "iPad", "MacBook", "Apple Watch", "AirPods", "Apple TV", "HomePod"]'::jsonb
WHERE name = 'Устройства' AND field_type = 'multiselect';

UPDATE field_definitions
SET options = '["Активная", "Истекла", "На рассмотрении"]'::jsonb
WHERE name = 'Статус' AND field_type = 'select';

UPDATE field_definitions
SET options = '["50GB", "200GB", "2TB"]'::jsonb
WHERE name = 'iCloud Storage' AND field_type = 'select';

-- Insert sample family data
INSERT INTO families (name, description, color, icon, status, position) VALUES
  ('Семья Ивановых', 'Основная семья с полным доступом к экосистеме Apple', '#0071e3', '👨‍👩‍👧‍👦', 'active', 0),
  ('Семья Петровых', 'Начинающие пользователи Apple', '#34c759', '👨‍👩‍👧', 'active', 1),
  ('Семья Сидоровых', 'Премиум подписка Apple One', '#ff9500', '👨‍👩‍👦‍👦', 'active', 2)
ON CONFLICT DO NOTHING;
