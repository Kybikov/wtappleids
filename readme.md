# Apple Accounts Manager

A beautiful, fully customizable Trello-like management system for Apple accounts with watermelon-inspired design.

## Features

### Fully Customizable System
- **Custom Statuses**: Create, edit, and delete your own status columns with custom colors
- **Custom Fields**: Add any type of field you need:
  - Text, Email, Phone, URL
  - Numbers and Dates
  - Checkboxes
  - Single-select Dropdowns
  - Multi-select Dropdowns
- **Dynamic Columns**: All fields and statuses are fully customizable

### Multiple Views
- **Kanban Board**: Visual board with drag-and-drop cards organized by status
- **List View**: Tabular view with all account details

### Powerful Features
- **Search**: Real-time search across account names and descriptions
- **Filter**: Filter by status
- **Sort**: Sort by position, name, or creation date
- **Rich Data**: Store comprehensive information about each Apple account

### Beautiful Design
- Watermelon-themed color scheme (green, pink, red tones)
- Smooth animations and transitions
- Responsive layout
- Modern, clean interface

## Getting Started

### Database
The system uses Supabase for data persistence with the following tables:
- `accounts`: Apple account records
- `statuses`: Custom status columns
- `field_definitions`: Custom field configurations
- `field_values`: Field data for each account

### Running the App
```bash
npm install
npm run dev
```

### Building for Production
```bash
npm run build
```

## Usage

### Managing Accounts
1. Click "Add Apple Account" to create a new account
2. Fill in basic information (name, description, icon, color, status)
3. Add custom field data as needed
4. Click "Create Account"

### Customizing Statuses
1. Click the Settings icon (gear)
2. Go to the "Statuses" tab
3. Add new statuses with custom names and colors
4. Delete statuses you don't need (except defaults)

### Customizing Fields
1. Click the Settings icon (gear)
2. Go to the "Fields" tab
3. Add new fields with different types:
   - Choose from 9 different field types
   - Add options for dropdown fields
4. Delete fields you don't need

### Organizing Accounts
- Switch between Kanban and List views
- Search for specific accounts
- Filter by status
- Sort by different criteria

## Tech Stack
- Vue 3 with Composition API
- Vite for build tooling
- Supabase for backend and database
- Modern CSS with CSS Variables

## Color Palette
- Primary Green: #10b981
- Secondary Pink: #ec4899
- Accent Red: #ef4444
- Background: #fef7f8
- Surface: #ffffff
- Border: #ffd6dd
