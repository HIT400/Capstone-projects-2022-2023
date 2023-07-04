import * as fp from "fingerpose";

const letterW = new fp.GestureDescription("W");

letterW.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1.0);
letterW.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 0.9);
letterW.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterW.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);

for (let finger of [fp.Finger.Index, fp.Finger.Middle, fp.Finger.Ring]) {
    letterW.addCurl(finger, fp.FingerCurl.NoCurl, 1.0);
    letterW.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterW.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1.0);
    letterW.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1.0);
}

for (let finger of [fp.Finger.Pinky]) {
    letterW.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterW.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterW.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterW.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
}

export default letterW;
