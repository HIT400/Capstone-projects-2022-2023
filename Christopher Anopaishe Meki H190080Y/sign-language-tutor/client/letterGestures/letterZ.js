import * as fp from "fingerpose";

const letterZ = new fp.GestureDescription("Z");

letterZ.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1.0);
letterZ.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterZ.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);

letterZ.addCurl(fp.Finger.Index, fp.FingerCurl.NoCurl, 1.0);
letterZ.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterZ.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpRight, 1.0);
letterZ.addDirection(fp.Finger.Index, fp.FingerDirection.VerticalUp, 1.0);

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky, fp.Finger.Middle]) {
    letterZ.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterZ.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterZ.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1.0);
    letterZ.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1.0);
    letterZ.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
}

export default letterZ;
