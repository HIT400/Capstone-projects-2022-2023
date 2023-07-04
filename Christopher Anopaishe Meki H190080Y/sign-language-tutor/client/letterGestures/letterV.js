import * as fp from "fingerpose";

const letterV = new fp.GestureDescription("V");

letterV.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 0.9);
letterV.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1);
letterV.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterV.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterV.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);

for (let finger of [fp.Finger.Index, fp.Finger.Middle]) {
    letterV.addCurl(finger, fp.FingerCurl.NoCurl, 1.0);
    letterV.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterV.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1.0);
    letterV.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1.0);
}

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky]) {
    letterV.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterV.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterV.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterV.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
}

export default letterV;
