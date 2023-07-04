import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { authenticate } from "../store";
import { useHistory } from "react-router-dom";
import { Link } from "react-router-dom";

export const Main = () => {
    return (
        <div className="flex align-center">
            <img
                className="w-3/4 absolute left-1/2 transform -translate-x-1/2 mt-10"
                src="/welcome.png"
            />
            <img
                className="w-1/3 absolute left-10 top-1/2 transform"
                src="/logoPanda.png"
            />
            <div className="flex grid grid-cols-1 justify-items-center m-auto mt-14">
                <Link to="/login">
                    <div className="rounded-lg shadow-lg bg-purple-500 hover:bg-purple-300 transition text-white uppercase tracking-widest font-medium text-xl border-solid border-2 border-white w-28 h-8 text-center absolute left-1/2 transform -translate-x-1/2 translate-y-64">
                        Login
                    </div>
                </Link>
                <Link to="/signup">
                    <div className="rounded-lg shadow-lg bg-purple-500 hover:bg-purple-300 transition text-white uppercase tracking-widest font-medium text-xl border-solid border-2 border-white w-28 h-8 text-center absolute left-1/2 transform -translate-x-1/2 translate-y-80">
                        Sign Up
                    </div>
                </Link>
            </div>
        </div>
    );
};

export const Login = () => {
    const error = useSelector(state => state.auth.error);
    const dispatch = useDispatch();

    const handleSubmit = evt => {
        evt.preventDefault();
        const email = evt.target.email.value.toLowerCase();
        const password = evt.target.password.value;
        dispatch(authenticate(email, password, "login"));
    };

    return (
        <div className="flex align-center">
            <img
                className="w-3/4 absolute left-1/2 transform -translate-x-1/2 mt-10"
                src="/welcome.png"
            />
            <img
                className="w-1/3 absolute left-2/3 top-1/2 transform"
                src="/logoPanda2.png"
            />
            <div className="absolute left-1/2 top-1/3 transform -translate-x-1/2 -translate-y-1/2 mt-4 font-bold text-gray-800 p-2 m-4">
                <form onSubmit={handleSubmit}>
                    <div>
                        <label htmlFor="email" className="mr-11">
                            Email:
                        </label>
                        <input
                            className="border-2 border-purple-500 mb-5"
                            name="email"
                            type="text"
                        />
                    </div>
                    <div>
                        <label htmlFor="password" className="mr-3">
                            Password:
                        </label>
                        <input
                            className="border-2 border-purple-500 mb-8"
                            name="password"
                            type="password"
                        />
                    </div>
                    <div>
                        <button
                            className="rounded-lg shadow-lg bg-purple-500 hover:bg-purple-300 transition text-white uppercase tracking-widest font-medium text-xl border-solid border-2 border-white w-28 h-8 text-center absolute"
                            type="submit"
                        >
                            Login
                        </button>
                    </div>
                    {error && error.response && <div> {error.response.data} </div>}
                </form>
            </div>
        </div>
    );
};

export const Signup = () => {
    const error = useSelector(state => state.auth.error);
    const dispatch = useDispatch();
    const history = useHistory();

    const handleSubmit = evt => {
        evt.preventDefault();
        const email = evt.target.email.value.toLowerCase();
        const password = evt.target.password.value;
        const firstname = evt.target.firstname.value;
        const lastname = evt.target.lastname.value;
        dispatch(authenticate(email, password, "signup", firstname, lastname));

        if (email && password && firstname && lastname) {
            history.push("/quickstart");
        }

    };

    return (
        <div className="flex align-center">
            <img
                className="w-3/4 absolute left-1/2 transform -translate-x-1/2 mt-10"
                src="/welcome.png"
            />
            <img
                className="w-1/3 absolute left-10 top-1/2 transform"
                src="/logoPanda.png"
            />
            <div className="absolute left-1/2 top-1/3 transform -translate-x-1/2 -translate-y-8 mt-4 font-bold text-gray-800 p-2">
                <form onSubmit={handleSubmit}>
                    <div>
                        <label className="mr-12" htmlFor="email">
                            Email:
                        </label>
                        <input
                            className="border-2 border-purple-500 mb-5"
                            name="email"
                            type="text"
                        />
                    </div>
                    <div>
                        <label className="mr-4" htmlFor="password">
                            Password:
                        </label>
                        <input
                            className="border-2 border-purple-500 mb-5"
                            name="password"
                            type="password"
                        />
                    </div>
                    <div>
                        <label className="mr-2" htmlFor="firstname">
                            First Name:
                        </label>
                        <input
                            className="border-2 border-purple-500 mb-5"
                            name="firstname"
                            type="text"
                        />
                    </div>
                    <div>
                        <label className="mr-3" htmlFor="lastname">
                            Last Name:
                        </label>
                        <input
                            className="border-2 border-purple-500 mb-5"
                            name="lastname"
                            type="text"
                        />
                    </div>
                    <div className="flex grid grid-cols-1 justify-items-center">
                        <button
                            className="inline-block px-4 py-1 rounded-lg shadow-lg bg-purple-500 hover:bg-purple-300 hover:-translate-y-0.5 transform transition text-white mt-3 uppercase tracking-wider font-semibold text-md border-solid border-2 border-black w-44 h-10"
                            type="submit"
                        >
                            Sign Up
                        </button>
                    </div>
                    {error && error.response && <div> {error.response.data} </div>}
                </form>
            </div>
        </div>
    );
};
