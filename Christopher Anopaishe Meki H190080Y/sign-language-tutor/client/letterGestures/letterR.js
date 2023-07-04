import * as fp from "fingerpose";

const letterR = new fp.GestureDescription("R");

letterR.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1.0);
letterR.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);

letterR.addCurl(fp.Finger.Index, fp.FingerCurl.NoCurl, 1.0);
letterR.addDirection(fp.Finger.Index, fp.FingerDirection.VerticalUp, 1.0);

letterR.addCurl(fp.Finger.Middle, fp.FingerCurl.NoCurl, 1.0);
letterR.addCurl(fp.Finger.Middle, fp.FingerCurl.HalfCurl, 0.9);
letterR.addDirection(fp.Finger.Middle, fp.FingerDirection.VerticalUp, 1.0);
letterR.addDirection(fp.Finger.Middle, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterR.addDirection(fp.Finger.Middle, fp.FingerDirection.DiagonalUpRight, 1.0);

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky]) {
    letterR.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterR.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterR.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
}

export default letterR;
