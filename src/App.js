import React, { useState, useEffect } from 'react';
import { supabase } from './supabaseClient';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';
import './App.css';
import Chatbot from './components/Chatbot';

function App() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!process.env.REACT_APP_SUPABASE_URL || !process.env.REACT_APP_SUPABASE_ANON_KEY) {
      setError('Missing Supabase environment variables. Please set REACT_APP_SUPABASE_URL and REACT_APP_SUPABASE_ANON_KEY in .env file.');
      setLoading(false);
      return;
    }
    fetchWinterSales();
  }, []);

  const fetchWinterSales = async () => {
    try {
      const { data, error } = await supabase
        .rpc('get_winter_sales_analysis');

      if (error) throw error;

      if (!data) {
        throw new Error('No data received from the database');
      }

      setData(data);
      setLoading(false);
    } catch (err) {
      console.error('Error details:', err);
      setError('Error fetching data: ' + err.message);
      setLoading(false);
    }
  };

  if (loading) return (
    <div className="App">
      <div className="loading-message">Loading...</div>
    </div>
  );
  
  if (error) return (
    <div className="App">
      <div className="error-message">
        <h2>Error</h2>
        <p>{error}</p>
        <p>Please check your database connection and environment variables.</p>
      </div>
    </div>
  );
  
  if (!data) return (
    <div className="App">
      <div className="no-data-message">
        <h2>No Data Available</h2>
        <p>Could not retrieve data from the database.</p>
      </div>
    </div>
  );

  return (
    <div className="App">
      <header className="App-header">
        <h1>Winter Sales Analysis</h1>
      </header>
      
      <main className="App-main">
        <div className="analysis-container">
          <div className="summary-section">
            <h2>Sales Summary</h2>
            <p>
              Based on our analysis of winter sales data, 
              {data.summary}
            </p>
          </div>

          <div className="chart-section">
            <h2>Sales by Product in Winter</h2>
            <ResponsiveContainer width="100%" height={400}>
              <BarChart data={data.chartData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="productName" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="totalSales" fill="#8884d8" name="Total Sales ($)" />
                <Bar dataKey="quantity" fill="#82ca9d" name="Quantity Sold" />
              </BarChart>
            </ResponsiveContainer>
          </div>

          <div className="table-section">
            <h2>Detailed Sales Data</h2>
            <table>
              <thead>
                <tr>
                  <th>Product</th>
                  <th>Total Sales</th>
                  <th>Quantity</th>
                  <th>Average Temperature</th>
                </tr>
              </thead>
              <tbody>
                {data.tableData.map((row, index) => (
                  <tr key={index}>
                    <td>{row.productName}</td>
                    <td>${row.totalSales.toFixed(2)}</td>
                    <td>{row.quantity}</td>
                    <td>{row.avgTemp}°C</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
        <div className="chatbot-section">
          <Chatbot />
        </div>
      </main>
    </div>
  );
}

export default App; 