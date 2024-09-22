const express = require('express');
const mysql = require('mysql');
const cors = require('cors');
require('dotenv').config();

const PORT = process.env.PORT || 5000;
const app = express();
app.use(cors()); // To allow cross-origin requests from React frontend

// Create a connection to MySQL database
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

// Connect to MySQL
db.connect(err => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL');
});

// Simple route to get data from MySQL
app.get('/api/data', (req, res) => {
  const query = 'SELECT message FROM test_table LIMIT 1';
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: 'Database query failed' });
    }
    res.json({ message: results[0].message });
  });
});

app.listen(PORT, () => {
  console.log('Server running on port 5000');
});

