import React from 'react';
import './TopBar.css';  // Import your CSS file for styling

const TopBar = () => {
  return (
    <div className="top-bar">
      <div className="top-bar-logo">Real Time Bus Tracking System</div>
      <ul className="top-bar-menu">
        <li><a href='/'>Registerd Users</a></li>
        <li><a href='/bus/detail'>Busses & Routes</a></li>
        <li><a href='/bus/create'>Add Bus</a></li>

        <li><a href='/complaints'>Complaints</a></li>
      </ul>
    </div>
  );
};

export default TopBar;