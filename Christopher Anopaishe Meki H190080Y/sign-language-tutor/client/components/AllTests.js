import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { Link } from "react-router-dom";
import { fetchMaxTiers } from "../store/maxTiers";

const AllTests = () => {
    const dispatch = useDispatch();
    const maxTestTier = useSelector(state => state.maxTiers.highestTestTier);

    const highestTestingTier = 3;

    useEffect(() => {
        dispatch(fetchMaxTiers());
    }, []);

    const allTiers = [];
    for (let i = 1; i <= highestTestingTier; i++) {
        let testNumber = i;
        if (i <= maxTestTier) {
            allTiers.push([
                <div key={i}>
                    <Link to={`/test/${i}`}>Test {testNumber}</Link>
                </div>,
                true,
            ]);
        } else {
            allTiers.push([<div key={i}>Test {testNumber}</div>, false]);
        }
    }

    return (
        <div>
            <img
                className="absolute object-cover h-full w-full z-0 mt-12"
                src="background3.png"
            />
            <div className="flex">
                <div className="grid z-0 grid-cols-2 flex-grow flex-wrap justify-items-center my-8 p-5 mt-16">
                    {allTiers.map((tier, index) => {
                        return tier[1] === true ? (
                            <button
                                key={index}
                                className="inline-block  rounded-lg shadow-lg bg-green-700 hover:bg-green-300 hover:-translate-y-0.5 transform transition text-white uppercase tracking-widest font-medium text-3xl border-solid border-2 border-white w-96 h-20 mx-48 mt-16"
                            >
                                {tier}
                            </button>
                        ) : (
                            <button
                                key={index}
                                className="inline-block px-4 py-1 rounded-lg shadow-lg bg-gray-500 line-through text-opacity-40 transform transition text-white mt-3 uppercase tracking-widest font-medium text-3xl border-solid border-2 border-white w-96 h-20 mx-48 mt-16"
                            >
                                {tier}
                            </button>
                        );
                    })}
                </div>
            </div>
        </div>
    );
};

export default AllTests;
