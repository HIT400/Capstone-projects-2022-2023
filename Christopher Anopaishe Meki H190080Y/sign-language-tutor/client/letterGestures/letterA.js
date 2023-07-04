import * as fp from "fingerpose";

const letterA = new fp.GestureDescription("A");

letterA.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl);
letterA.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterA.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);

letterA.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 0.9);

for (let finger of [
    fp.Finger.Index,
    fp.Finger.Middle,
    fp.Finger.Ring,
    fp.Finger.Pinky,
]) {
    letterA.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterA.addDirection(finger, fp.FingerDirection.VerticalUp, 1);
    letterA.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 0.9);
    letterA.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 0.9);
}

export default letterA;
