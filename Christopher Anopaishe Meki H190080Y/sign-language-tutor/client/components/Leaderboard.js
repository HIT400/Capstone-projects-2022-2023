import React, { useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import { fetchLeaders } from "../store/leaderboard";

const Leaderboard = props => {
    const dispatch = useDispatch();
    const currentLeaders = useSelector(state => state.leaderboard);

    useEffect(() => {
        dispatch(fetchLeaders());
    }, []);

    return (
        <div>
            <div className="flex">
                <img
                    className="absolute text-3xl left-1/2 transform -translate-x-1/2 w-96"
                    src="/leaderBoard_logo.png"
                />
                <hr />
            </div>
            <div className="flex grid grid-cols-2 w-full text-2xl mt-40">
                <img className="justify-start" src="/leaderboard.png" />
                <table className="w-8/12 m-auto h-1/2 -mt-4 text-3xl text-black">
                    <tbody>
                    <tr className="font-bold">
                        <td>Rank</td>
                        <td>Name</td>
                        <td>Points</td>
                    </tr>
                    </tbody>
                    {currentLeaders.map((leader, index) => {
                        return index === 0 ? (
                            <tbody key={index}>
                            <tr className="border-4 bg-purple-200 border-gray-500 font-semibold">
                                <td>
                                    <img className="w-16" src="/first.png" />
                                </td>
                                <td>{leader.firstname}</td>
                                <td>{leader.points}</td>
                            </tr>
                            </tbody>
                        ) : index === 1 ? (
                            <tbody key={index}>
                            <tr className="border-4 bg-purple-400 border-gray-500 font-semibold">
                                <td>
                                    <img className="w-16" src="/second.png" />
                                </td>
                                <td>{leader.firstname}</td>
                                <td>{leader.points}</td>
                            </tr>
                            </tbody>
                        ) : index === 2 ? (
                            <tbody key={index}>
                            <tr className="border-4 bg-purple-600 border-gray-500 font-semibold">
                                <td>
                                    <img className="w-16" src="/third.png" />
                                </td>
                                <td>{leader.firstname}</td>
                                <td>{leader.points}</td>
                            </tr>
                            </tbody>
                        ) : (
                            <tbody key={index}>
                            <tr className="border-4 bg-purple-700 border-gray-500 font-semibold">
                                <td className="pl-2">{index + 1}. </td>
                                <td>{leader.firstname}</td>
                                <td>{leader.points}</td>
                            </tr>
                            </tbody>
                        );
                    })}
                </table>
            </div>
        </div>
    );
};

export default Leaderboard;
