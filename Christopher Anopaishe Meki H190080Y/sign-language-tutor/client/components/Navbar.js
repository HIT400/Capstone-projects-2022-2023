import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { Link } from "react-router-dom";
import { logout } from "../store";

const Navbar = () => {
    const isLoggedIn = useSelector(state => !!state.auth.id);
    const dispatch = useDispatch();

    const handleClick = () => {
        dispatch(logout());
    };

    return (
        <div className="flex bg-yellow-50 justify-center">
            <nav>
                {isLoggedIn ? (
                    <div className="flex container grid grid-flow-col mx-auto p-12 tracking-wider space-x-7 text-xl text-gray-900 transition duration-500  ">
                        {/* The navbar will show these links after you log in */}
                        <div className="flex container grid grid-flow-col mx-auto p-12 tracking-wider space-x-7 text-xl text-gray-900 transition duration-500 border-b-2 border-gray-600">
                            <Link to="/allLearning">
                                <img
                                    className="w-44 hover:-translate-y-1.5 transform transition"
                                    src="/books.png"
                                ></img>
                            </Link>
                            <Link to="/allTests">
                                <img
                                    className="w-44 hover:-translate-y-1.5 transform transition"
                                    src="/tests.png"
                                ></img>
                            </Link>
                            <Link to="/commonphrases">
                                <img
                                    className="w-44 hover:-translate-y-1.5 transform transition"
                                    src="/phrases.png"
                                ></img>
                            </Link>
                            <Link to="/studyguide">
                                <img
                                    className="w-44 hover:-translate-y-1.5 transform transition"
                                    src="/alphabet.png"
                                ></img>
                            </Link>
                        </div>
                        <h1 className="w-48">
                            <img src="/logo.png" />
                        </h1>
                        <div className="flex container grid grid-flow-col mx-auto p-12 tracking-wider space-x-7 text-xl text-gray-900 transition duration-500 border-b-2 border-gray-600">
                            <Link to="/leaderboard">
                                <img
                                    className="w-44 hover:-translate-y-1.5 transform transition"
                                    src="/leaders.png"
                                ></img>
                            </Link>
                            <Link to="/quickstart">
                                <img
                                    className="w-44 hover:-translate-y-1.5 transform transition"
                                    src="/guide.png"
                                ></img>
                            </Link>
                            <Link to="/user">
                                <img
                                    className="w-44 hover:-translate-y-1.5 transform transition"
                                    src="/profile.png"
                                ></img>
                            </Link>
                            <a href="#" onClick={handleClick}>
                                <img
                                    className="w-44 hover:-translate-y-1.5 transform transition"
                                    src="/logout.png"
                                ></img>
                            </a>
                        </div>
                    </div>
                ) : (
                    ""
                )}
            </nav>
            <hr />
        </div>
    );
};

export default Navbar;
