import * as fp from "fingerpose";

const letterK = new fp.GestureDescription("K");

letterK.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1.0);
letterK.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 0.9);
letterK.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterK.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterK.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);

for (let finger of [fp.Finger.Index, fp.Finger.Middle]) {
    letterK.addCurl(finger, fp.FingerCurl.NoCurl, 1.0);
    letterK.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterK.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1.0);
    letterK.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1.0);
}

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky]) {
    letterK.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterK.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterK.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterK.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
}

export default letterK;
