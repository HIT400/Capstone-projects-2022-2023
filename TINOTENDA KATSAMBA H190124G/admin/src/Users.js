import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";

const DriversList = () => {
    const [empdata, empdatachange] = useState(null);
    const navigate = useNavigate();

    const LoadDetail = (id) => {
        navigate("/driver/detail/" + id);
    }
    const LoadEdit = (id) => {
        navigate("/driver/edit/" + id);
    }
    const Removefunction = (id) => {
        if (window.confirm('Do you want to remove?')) {
            fetch("http://localhost:8080/user/delete-by-id" + id, {
                method: "DELETE"
            }).then((res) => {
                alert('Removed successfully.')
                window.location.reload();
            }).catch((err) => {
                console.log(err.message)
            })
        }
    }




    useEffect(() => {
        fetch("http://localhost:8080/user/all-users").then((res) => {
            return res.json();
        }).then((resp) => {
            empdatachange(resp);
        }).catch((err) => {
            console.log(err.message);
        })
    }, [])
    return (
        <div className="container">
            <div className="card">
                <div className="card-title">
                    <h2>Users Listing</h2>
                </div>
                <div className="card-body">
                    {/* <div className="divbtn">
                        <Link to="driver/create" className="btn btn-success">Add New (+)</Link>
                    </div> */}
                    <table className="table table-bordered">
                        <thead className="bg-dark text-white">
                            <tr>
                                {/* <td>ID</td> */}
                                <td>Name</td>
                                <td>Surname</td>
                                <td>Email</td>
                                <td>Driver's Licence</td>
                                <td>Phone</td>
                                <td>Action</td>
                                <td>Action</td>
                            </tr>
                        </thead>
                        <tbody>

                            {empdata &&
                                empdata.map(item => (
                                    <tr key={item.id}>
                                        {/* <td>{item.id}</td> */}
                                        <td>{item.name}</td>
                                        <td>{item.surname}</td>
                                        <td>{item.email}</td>
                                        <td>{item.drivers_license}</td>
                                        <td>{item.phone}</td>
                                        <td>
                                            {/* <a onClick={() => { LoadEdit(item.id) }} className="btn btn-success">Edit</a> */}
                                            <a onClick={() => { Removefunction(item.id) }} className="btn btn-danger">Remove</a>
                                            <a onClick={() => { LoadDetail(item.id) }} className="btn btn-primary">Details</a>
                                        </td>
                                    </tr>
                                ))
                            }

                        </tbody>

                    </table>
                </div>
            </div>
        </div>
    );
}

export default DriversList;