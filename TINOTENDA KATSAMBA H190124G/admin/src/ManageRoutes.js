import React, { useState } from 'react';

const ManageRoutesPage = () => {
  const [routes, setRoutes] = useState([
    { id: 1, name: 'Route 1', stops: ['Stop 1', 'Stop 2', 'Stop 3'] },
    { id: 2, name: 'Route 2', stops: ['Stop 4', 'Stop 5', 'Stop 6'] },
    { id: 3, name: 'Route 3', stops: ['Stop 7', 'Stop 8', 'Stop 9'] },
  ]);

  const [showForm, setShowForm] = useState(false);
  const [newRouteName, setNewRouteName] = useState('');
  const [newRouteStops, setNewRouteStops] = useState('');

  const handleNewRouteSubmit = (event) => {
    event.preventDefault();
    const newRoute = {
      id: routes.length + 1,
      name: newRouteName,
      stops: newRouteStops.split(','),
    };
    setRoutes([...routes, newRoute]);
    setShowForm(false);
    setNewRouteName('');
    setNewRouteStops('');
  };

  return (
    <div>
      <h1>Manage Bus Routes</h1>
      <button onClick={() => setShowForm(!showForm)}>Add New Route</button>
      {showForm && (
        <form onSubmit={handleNewRouteSubmit}>
          <label>
            Route Name:
            <input
              type="text"
              value={newRouteName}
              onChange={(event) => setNewRouteName(event.target.value)}
            />
          </label>
          <label>
            Route Stops (comma-separated):
            <input
              type="text"
              value={newRouteStops}
              onChange={(event) => setNewRouteStops(event.target.value)}
            />
          </label>
          <button type="submit">Add Route</button>
        </form>
      )}
      <ul>
        {routes.map((route) => (
          <li key={route.id}>
            <h2>{route.name}</h2>
            <ul>
              {route.stops.map((stop, index) => (
                <li key={index}>{stop}</li>
              ))}
            </ul>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ManageRoutesPage;