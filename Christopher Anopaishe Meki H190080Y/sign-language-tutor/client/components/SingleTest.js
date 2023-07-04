import React, { useRef, useState, useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import * as tf from "@tensorflow/tfjs";
import * as handpose from "@tensorflow-models/handpose";
import Webcam from "react-webcam";
import * as fp from "fingerpose";
import { fetchTestPhrases } from "../store/testPhrases";
import { addPoints } from "../store/points";
import { allGestures } from "../letterGestures";
import { useHistory } from "react-router-dom";

function shuffleArray(arr) {
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
}

const SingleTest = props => {
    const testPoints = 20;
    const dispatch = useDispatch();
    const history = useHistory();
    const webcamRef = useRef(null);
    const canvasRef = useRef(null);
    const [currentLetter, setLetter] = useState("");
    const [emoji, setEmoji] = useState(null);
    const [ifTextBox, setTextBox] = useState(false);
    let textCheck = false;
    const [mixedImages, setMixedImages] = useState({});
    const [userTextInput, setTextInput] = useState("");
    const [didSubmit, setDidSubmit] = useState(false);
    let allLetters = useSelector(state => state.testPhrases);
    let lettersOnly = allLetters.map(letter => letter.letterwords);

    //Object is now 2d array: [[key1,value1], [key2,value2]]
    const currentGestures = Object.entries(allGestures)
        .filter(entry => {
            //key = key1 & value = value1  ..etc
            const [key, value] = entry;
            return lettersOnly.includes(key);
        })
        .map(entry => {
            const [key, value] = entry;
            return value;
        });
    const gestureAccuracyMany = 10;
    const gestureAccuracyOne = 9.5;

    //setTimeout ids to clear
    let timerBetweenLetterId;
    let timerBetweenCompletionId;
    let didSubmitTimerId;

    const handleUpdate = async event => {
        setTextInput(event.target.value);
    };
    const handleSubmit = async event => {
        event.preventDefault();
        runTextBox();
        setTextInput("");
    };

    //Like componentDidMount
    useEffect(() => {
        dispatch(fetchTestPhrases(Number(props.match.params.tier)));
    }, []);

    //Like componentWillUpdate
    useEffect(() => {
        if (
            currentLetter !== lettersOnly[0] &&
            mixedImages[currentLetter] &&
            mixedImages[currentLetter].includes("letter")
        ) {
            setTextBox(true);
            textCheck = true;
        } else {
            setTextBox(false);
            textCheck = false;
        }
        let intervalId;
        const runHandModel = async () => {
            intervalId = await runHandpose();
            return intervalId;
        };
        if (textCheck) {
            runTextBox();
        } else {
            intervalId = runHandModel();
        }

        // Like componentWillUnmount
        return async () => {
            clearInterval(await intervalId);
            clearTimeout(timerBetweenLetterId);
            clearTimeout(timerBetweenCompletionId);
            clearTimeout(didSubmitTimerId);
        };
    }, [currentLetter]);

    //componentWillUpdate to get allLetters
    useEffect(() => {
        allLetters = shuffleArray(allLetters);

        allLetters[0] ? setLetter(allLetters[0].letterwords) : "";

        setMixedImages(
            allLetters.reduce((accu, letter) => {
                if (letter === allLetters[0]) {
                    accu[letter.letterwords] = letter.textUrl;
                } else if (Math.random() > 0.45) {
                    accu[letter.letterwords] = letter.url;
                } else {
                    accu[letter.letterwords] = letter.textUrl;
                }
                return accu;
            }, {})
        );
    }, [allLetters]);

    const runTextBox = async () => {
        const net = await handpose.load(); //just to run camera
        await detect(net); //just to run camera

        if (userTextInput.toUpperCase() === currentLetter && userTextInput) {
            let letterIndex = lettersOnly.indexOf(currentLetter) + 1;
            setEmoji(userTextInput.toUpperCase());
            setDidSubmit(false);
            if (letterIndex < lettersOnly.length) {
                timerBetweenLetterId = setTimeout(() => {
                    setLetter(lettersOnly[letterIndex]);
                }, 3000); // timer for between gestures
            } else {
                dispatch(addPoints(testPoints));
                timerBetweenCompletionId = setTimeout(() => {
                    history.push({
                        pathname: "/testcompletionPage",
                        state: { tier: Number(props.match.params.tier) },
                    });
                }, 3000);
            }
        } else {
            if (userTextInput) {
                setDidSubmit(true);
                didSubmitTimerId = setTimeout(() => {
                    setDidSubmit(false);
                }, 2000);
            }
        }
    };

    const runHandpose = async () => {
        const net = await handpose.load();
        //Loop and detect hands
        let intervalId = setInterval(async () => {
            let result = await detect(net);
            //getresultfrom text box
            if (result === currentLetter) {
                clearInterval(intervalId);
                let letterIndex = lettersOnly.indexOf(currentLetter) + 1;
                if (letterIndex < lettersOnly.length) {
                    timerBetweenLetterId = setTimeout(() => {
                        setLetter(lettersOnly[letterIndex]);
                    }, 3000); // timer for between gestures
                } else {
                    dispatch(addPoints(testPoints));
                    timerBetweenCompletionId = setTimeout(() => {
                        history.push({
                            pathname: "/testcompletionPage",
                            state: { tier: Number(props.match.params.tier) },
                        });
                    }, 3000);
                }
            }
        }, 100);
        return intervalId;
    };

    const detect = async net => {
        //Check data is available
        if (
            typeof webcamRef.current !== "undefined" &&
            webcamRef.current !== null &&
            webcamRef.current.video.readyState === 4
        ) {
            //Get video properties
            const video = webcamRef.current.video;
            const videoWidth = webcamRef.current.video.videoWidth;
            const videoHeight = webcamRef.current.video.videoHeight;
            //Set video height and width
            webcamRef.current.video.width = videoWidth;
            webcamRef.current.video.height = videoHeight;
            //Set canvas height and width
            canvasRef.current.width = videoWidth;
            canvasRef.current.height = videoHeight;
            // Make detections
            const hand = await net.estimateHands(video);
            // Gesture detections
            if (hand.length > 0) {
                const GE = new fp.GestureEstimator(currentGestures);
                //second argument is the confidence level
                const gesture = await GE.estimate(hand[0].landmarks, 8);
                if (gesture.gestures !== undefined && gesture.gestures.length > 0) {
                    const confidence = gesture.gestures.map(
                        prediction => prediction.score
                    );
                    const maxConfidence = confidence.indexOf(
                        Math.max.apply(null, confidence)
                    );

                    // prints current hand gesture
                    // console.log(gesture);

                    const maxGesture = gesture.gestures[maxConfidence];
                    if (
                        (gesture.gestures.length === 1 &&
                            maxGesture.score >= gestureAccuracyOne) ||
                        maxGesture.score >= gestureAccuracyMany
                    ) {
                        if (
                            (maxGesture.name === "N" ||
                                maxGesture.name === "M" ||
                                maxGesture.name === "T" ||
                                maxGesture.name === "S") &&
                            (currentLetter === "M" ||
                                currentLetter === "N" ||
                                currentLetter === "S" ||
                                currentLetter === "T")
                        ) {
                            setEmoji(currentLetter);
                            return currentLetter;
                        } else if (
                            (maxGesture.name === "R" || maxGesture.name === "U") &&
                            (currentLetter === "R" || currentLetter === "U")
                        ) {
                            setEmoji(currentLetter);
                            return currentLetter;
                        } else {
                            setEmoji(maxGesture.name);
                            return maxGesture.name;
                        }
                    }
                }
            }
        }
    };

    let checkMark =
        emoji === currentLetter ? (
            <img
                src="/CheckMark.png"
                style={{
                    position: "relative",
                    marginLeft: "auto",
                    marginRight: "auto",
                    left: 150,
                    bottom: -325,
                    right: 0,
                    textAlign: "center",
                    height: 100,
                }}
            />
        ) : (
            ""
        );

    let redCheck =
        emoji !== currentLetter && ifTextBox && didSubmit ? (
            <img
                src="/redCircle.png"
                style={{
                    position: "relative",
                    marginLeft: "auto",
                    marginRight: "auto",
                    left: 150,
                    bottom: -325,
                    right: 0,
                    textAlign: "center",
                    height: 100,
                }}
            />
        ) : (
            ""
        );

    let textBoxx =
        ifTextBox || textCheck ? (
            <div>
                <img className="ml-60" src="/guessLetter.png"></img>
                <form
                    className="text-xl font-semibold"
                    style={{
                        position: "relative",
                        marginLeft: "auto",
                        marginRight: "auto",
                        left: -230,
                        bottom: -140,
                        right: -50,
                        textAlign: "center",
                        height: 100,
                    }}
                    onSubmit={handleSubmit}
                >
                    <label htmlFor="userGuess"></label>
                    <input
                        className="w-1/12 border-4 border-yellow-300 border-opacity-75 border-solid"
                        type="text"
                        onChange={handleUpdate}
                        name="userGuess"
                        value={userTextInput}
                        placeholder="guess"
                    />
                </form>
            </div>
        ) : (
            ""
        );

    return (
        <div className="App">
            <header className="App-header">
                <Webcam
                    ref={webcamRef}
                    className=" bg-yellow-300 border-4 border-gray-600"
                    style={{
                        position: "absolute",
                        marginLeft: "auto",
                        marginRight: "auto",
                        left: 0,
                        right: 0,
                        textAlign: "center",
                        zindex: 9,
                        width: 640,
                        height: 400,
                    }}
                />
                <canvas
                    ref={canvasRef}
                    style={{
                        position: "absolute",
                        marginLeft: "auto",
                        marginRight: "auto",
                        left: 0,
                        right: 0,
                        textAlign: "center",
                        zindex: 9,
                        width: 640,
                        height: 380,
                    }}
                />
                <img
                    src={"/" + mixedImages[currentLetter]}
                    style={{
                        position: "relative",
                        marginLeft: "auto",
                        marginRight: "auto",
                        left: 0,
                        bottom: -420,
                        right: 180,
                        textAlign: "center",
                        height: 100,
                    }}
                />
                {checkMark}
                {redCheck}
                {textBoxx}
            </header>
        </div>
    );
};
export default SingleTest;
