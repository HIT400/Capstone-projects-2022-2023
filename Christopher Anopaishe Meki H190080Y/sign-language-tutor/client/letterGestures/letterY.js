import * as fp from "fingerpose";

const letterY = new fp.GestureDescription("Y");

letterY.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1.0);
letterY.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterY.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);

for (let finger of [fp.Finger.Ring, fp.Finger.Middle, fp.Finger.Index]) {
    letterY.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterY.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterY.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterY.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1.0);
    letterY.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1.0);
}

letterY.addCurl(fp.Finger.Pinky, fp.FingerCurl.NoCurl, 1.0);
letterY.addDirection(fp.Finger.Pinky, fp.FingerDirection.DiagonalUpRight, 1.0);
letterY.addDirection(fp.Finger.Pinky, fp.FingerDirection.DiagonalUpLeft, 1.0);

export default letterY;
