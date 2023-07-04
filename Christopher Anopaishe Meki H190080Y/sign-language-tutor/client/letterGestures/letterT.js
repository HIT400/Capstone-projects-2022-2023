import * as fp from "fingerpose";

const letterT = new fp.GestureDescription("T");

letterT.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1.0);
letterT.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 0.9);
letterT.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);
letterT.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);
letterT.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 0.9);
letterT.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 0.9);

letterT.addCurl(fp.Finger.Index, fp.FingerCurl.HalfCurl, 1.0);
letterT.addCurl(fp.Finger.Index, fp.FingerCurl.FullCurl, 1.0);
letterT.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpRight, 1.0);
letterT.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterT.addDirection(fp.Finger.Index, fp.FingerDirection.VerticalUp, 0.9);

for (let finger of [fp.Finger.Middle, fp.Finger.Ring, fp.Finger.Pinky]) {
    letterT.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterT.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterT.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 0.9);
    letterT.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 0.9);
}

export default letterT;
