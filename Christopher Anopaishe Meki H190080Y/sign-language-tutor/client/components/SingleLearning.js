import React, { useRef, useState, useEffect, useReducer } from "react";
import { useSelector, useDispatch } from "react-redux";
import * as tf from "@tensorflow/tfjs";
import * as handpose from "@tensorflow-models/handpose";
import Webcam from "react-webcam";
import * as fp from "fingerpose";
import { fetchPhrases, unlockPhrases } from "../store/phrases";
import { addPoints } from "../store/points";
import { allGestures } from "../letterGestures";
import { useHistory } from "react-router-dom";

const SingleLearning = props => {
    const learningPoints = 10;
    const dispatch = useDispatch();
    const history = useHistory();
    const webcamRef = useRef(null);
    const canvasRef = useRef(null);

    const [currentLetter, setLetter] = useState("");
    const [emoji, setEmoji] = useState(null);
    const [images, setImages] = useState({});
    let allLetters = useSelector(state => state.phrases);

    const lettersOnly = allLetters.map(letter => letter.letterwords);
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

    //Like componentDidMount
    useEffect(() => {
        dispatch(fetchPhrases(Number(props.match.params.tier)));
    }, []);

    //Like componentWillUpdate
    useEffect(() => {
        const run = async () => {
            const intervalIds = await runHandpose();
            return intervalIds;
        };
        const intervalId = run();

        // Like componentWillUnmount
        return async () => {
            clearInterval(await intervalId);
            clearTimeout(timerBetweenLetterId);
            clearTimeout(timerBetweenCompletionId);
        };
    }, [currentLetter]);

    //componentWillUpdate to get allLetters
    useEffect(() => {
        allLetters[0] ? setLetter(allLetters[0].letterwords) : "";
        setImages(
            allLetters.reduce((accu, letter) => {
                accu[letter.letterwords] = [letter.url, letter.textUrl];
                return accu;
            }, {})
        );
    }, [allLetters]);

    const runHandpose = async () => {
        const net = await handpose.load();
        //Loop and detect hands
        let intervalId = setInterval(async () => {
            let result = await detect(net);

            if (result === currentLetter) {
                clearInterval(intervalId);

                const letterIndex = lettersOnly.indexOf(currentLetter) + 1;

                if (letterIndex < lettersOnly.length) {
                    timerBetweenLetterId = setTimeout(() => {
                        setLetter(lettersOnly[letterIndex]);
                    }, 3000); // timer for between gestures
                } else {
                    dispatch(unlockPhrases(Number(props.match.params.tier)));
                    dispatch(addPoints(learningPoints));
                    timerBetweenCompletionId = setTimeout(() => {
                        history.push({
                            pathname: "/completionPage",
                            state: { tier: Number(props.match.params.tier) },
                        });
                    }, 3000);
                }
            }
        }, 100);

        //return id of timer to clear when component unmounts
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
                            (maxGesture.name === "T" || maxGesture.name === "S") &&
                            (currentLetter === "T" || currentLetter === "S")
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

    let emojiPrint =
        emoji === currentLetter ? (
            <img
                src="/CheckMark.png"
                style={{
                    position: "relative",
                    marginLeft: "auto",
                    marginRight: "auto",
                    left: 150,
                    bottom: -240,
                    right: 0,
                    textAlign: "center",
                    height: 100,
                }}
            />
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
                    src={images[currentLetter] ? "/" + images[currentLetter][0] : null}
                    style={{
                        position: "relative",
                        marginLeft: "auto",
                        marginRight: "auto",
                        left: 30,
                        bottom: -440,
                        right: 100,
                        textAlign: "center",
                        height: 100,
                    }}
                />

                <img
                    src={images[currentLetter] ? "/" + images[currentLetter][1] : null}
                    style={{
                        position: "relative",
                        marginLeft: "auto",
                        marginRight: "auto",
                        left: -100,
                        bottom: -340,
                        right: 100,
                        textAlign: "center",
                        height: 100,
                    }}
                />

                {emojiPrint}
            </header>
        </div>
    );
};

export default SingleLearning;
