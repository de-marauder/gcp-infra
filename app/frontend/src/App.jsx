import { useState, useEffect } from 'react';

function App() {
  const [data, setData] = useState(null);

  useEffect(() => {
    fetch(`http://${import.meta.env.VITE_APP_API_HOSTNAME ?? 'localhost'}:5000/api/data`)
      .then(response => response.json())
      .then(data => setData(data.message))
      .catch(error => console.error("Error fetching data:", error));
  }, []);

  return (
    <div>
      <h1>React Frontend</h1>
      <p>{data ? data : `${import.meta.env.VITE_APP_HOSTNAME} Loading...`}</p>
    </div>
  );
}

export default App;
