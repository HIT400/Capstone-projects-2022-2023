import React from "react";
import { Link } from "react-router-dom";

const QuickStartGuide = () => {
    return (
        <div className="grid grid-cols-2 flex space-x-8">
            <img className="border-2 border-black w-11/12 m-auto" src="QSG.png" />
            <div>
                <h4 className="font-bold text-2xl my-4">
                    Tips and Tricks for the best user experience:
                </h4>
                <ul className="text-xl">
                    <li>• Be sure to allow camera access</li>
                    <li>
                        • Keep your hand in the middle of the screen and{" "}
                        <span className="font-bold text-red-300">parallel</span> to the
                        camera while making the gestures
                    </li>
                    <li>• Make sure your hand isn't too far away from the camera</li>
                    <li>
                        • If it does not capture right away, do not worry! Adjust your hand
                        to mimic the gesture as closely as possible
                    </li>
                </ul>
                <h4 className="font-bold font-bold text-xl mt-4">
                    When ready, click the button below to start learning!
                </h4>
                <Link to="allLearning">
                    <button className="inline-block px-4 py-1 rounded-lg shadow-lg bg-purple-500 hover:bg-purple-300 hover:-translate-y-0.5 transform transition text-white mt-3 uppercase tracking-wider font-semibold text-sm border-solid border-2 border-black w-44 h-10">
                        Begin Learning
                    </button>
                </Link>
            </div>
        </div>
    );
};

export default QuickStartGuide;
