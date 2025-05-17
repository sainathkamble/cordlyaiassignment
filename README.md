# Messy Data Analyzer

This project demonstrates analyzing and visualizing sales data from a messy database schema. It includes a React frontend with charts and a PostgreSQL backend with Supabase.

## Setup Instructions

1. **Database Setup**
   - Create a Supabase account at https://supabase.com
   - Create a new project
   - Copy your project URL and anon key
   - Run the `messy_schema.sql` script in the SQL editor
   - Run the `winter_sales_analysis.sql` script to create the analysis function

2. **Environment Setup**
   - Copy `.env.example` to `.env`
   - Update the Supabase URL and anon key in `.env`

3. **Install Dependencies**
   ```bash
   npm install
   ```

4. **Run the Application**
   ```bash
   npm start
   ```

## Project Structure

- `src/App.js` - Main React component with chart visualization
- `src/App.css` - Styling for the application
- `src/supabaseClient.js` - Supabase client configuration
- `messy_schema.sql` - Database schema with intentionally messy design
- `winter_sales_analysis.sql` - SQL function for analyzing winter sales

## Features

- Visualizes winter sales data using Recharts
- Displays detailed sales information in a table
- Provides a summary of best-selling products
- Includes temperature and weather data analysis

## Technologies Used

- React
- Supabase (PostgreSQL)
- Recharts
- CSS3 