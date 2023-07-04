import * as fp from "fingerpose";

const letterU = new fp.GestureDescription("U");

letterU.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 0.9);
letterU.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1.0);
letterU.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterU.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterU.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);

for (let finger of [fp.Finger.Index, fp.Finger.Middle]) {
    letterU.addCurl(finger, fp.FingerCurl.NoCurl, 1.0);
    letterU.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
}

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky]) {
    letterU.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterU.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterU.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
}

export default letterU;
