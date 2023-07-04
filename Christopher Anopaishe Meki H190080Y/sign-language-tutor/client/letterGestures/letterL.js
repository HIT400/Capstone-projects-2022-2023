import * as fp from "fingerpose";

const letterL = new fp.GestureDescription("L");

letterL.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1.0);
letterL.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalLeft, 1.0);
letterL.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalRight, 1.0);
letterL.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterL.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);

letterL.addCurl(fp.Finger.Index, fp.FingerCurl.NoCurl, 1.0);
letterL.addDirection(fp.Finger.Index, fp.FingerDirection.VerticalUp, 1.0);
letterL.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalLeft, 1.0);
letterL.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalRight, 1.0);

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky, fp.Finger.Middle]) {
    letterL.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterL.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterL.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterL.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1);
    letterL.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1);
}

export default letterL;
