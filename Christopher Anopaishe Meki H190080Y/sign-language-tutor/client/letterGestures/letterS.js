import * as fp from "fingerpose";

const letterS = new fp.GestureDescription("S");

letterS.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1);
letterS.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);

for (let finger of [
    fp.Finger.Ring,
    fp.Finger.Pinky,
    fp.Finger.Middle,
    fp.Finger.Index,
]) {
    letterS.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterS.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterS.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterS.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1.0);
    letterS.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1.0);
}

export default letterS;
