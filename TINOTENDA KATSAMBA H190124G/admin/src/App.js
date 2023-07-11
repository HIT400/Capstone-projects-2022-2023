// import logo from './logo.svg';
import './App.css';
import { BrowserRouter, Route, Routes } from 'react-router-dom'

import AddBus from './AddBus';
import AddDriver from './AddDriver';
import DriversList from './DriverList';
import BusListing from './BusListing';
import TopBar from './Topbar';
import HomePage from './Home';
import Viewcomplaints from './Viewcomplaints';


function App() {
  return (
    <div className="App">
      <TopBar/>
      <h1>Real time bus tracking system admin</h1>
      <HomePage/>
      
      <BrowserRouter>
        <Routes>
          <Route path='/bus/create' element={<AddBus/>}></Route>

          <Route path='driver/create' element={<AddDriver/>}></Route>
          <Route path='/' element={<DriversList/>}></Route>

          <Route path='/complaints' element={<Viewcomplaints/>}></Route>

          <Route path='/bus/detail' element={<BusListing/>}></Route>

        </Routes>
      </BrowserRouter>
    </div>
  );

}

export default App;
