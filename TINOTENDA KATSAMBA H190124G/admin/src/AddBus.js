import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import axios from "axios";

const EmpCreate = () => {
    

    // const[id,idchange]=useState("");
    const[bus_route_name,bus_route_namechange]=useState("");  
    const[fair,fairchange]=useState("");
    const[bus_number,bus_numberchange]=useState("");
    const[active,activechange]=useState(true);
    const[validation,valchange]=useState(false);
    


    const navigate=useNavigate();

    const handlesubmit=(e)=>{
      e.preventDefault();
      const empdata={bus_route_name,bus_number,fair,active};

      console.log("here")
      

      fetch("http://localhost:8080/busses/save",{
        method:"POST",
        headers:{"content-type":"application/json"},
        body:JSON.stringify(empdata)
      }).then((res)=>{
        alert('Saved successfully.')
        navigate('/bus/detail');
      }).catch((err)=>{
        console.log(err.message)
      })

    }

    return (
        <div>

            <div className="row">
                <div className="offset-lg-3 col-lg-6">
                    <form className="container" onSubmit={handlesubmit}>

                        <div className="card" style={{"textAlign":"left"}}>
                            <div className="card-title">
                                <h2>Add Bus & Route</h2>
                            </div>
                            <div className="card-body">

                                <div className="row">

                                    <div className="col-lg-12">
                                        <div className="form-group">
                                            <label>Bus Route</label>
                                            <input required value={bus_route_name} onMouseDown={e=>valchange(true)} onChange={e=>bus_route_namechange(e.target.value)} className="form-control"></input>
                                        {bus_route_name.length==0 && validation && <span className="text-danger">Enter route name</span>}
                                        </div>
                                    </div>


                                    <div className="col-lg-12">
                                        <div className="form-group">
                                            <label>Bus Number</label>
                                            <input value={bus_number} onChange={e=>bus_numberchange(e.target.value)} className="form-control"></input>
                                        </div>
                                    </div>

                                    <div className="col-lg-12">
                                        <div className="form-group">
                                            <label>Bus Fair</label>
                                            <input value={fair} onChange={e=>fairchange(e.target.value)} className="form-control"></input>
                                        </div>
                                    </div>


                                    <div className="col-lg-12">
                                        <div className="form-check">
                                        <input checked={active} onChange={e=>activechange(e.target.checked)} type="checkbox" className="form-check-input"></input>
                                            <label  className="form-check-label">Is Active</label>
                                            
                                        </div>
                                    </div>
                                    <div className="col-lg-12">
                                        <div className="form-group">
                                           <button className="btn btn-success" onClick={handlesubmit} type="submit">Save</button>
                                           <Link to="/" className="btn btn-danger">Back</Link>
                                        </div>
                                    </div>

                                </div>

                            </div>

                        </div>

                    </form>

                </div>
            </div>
        </div>
    );
}



export default EmpCreate;