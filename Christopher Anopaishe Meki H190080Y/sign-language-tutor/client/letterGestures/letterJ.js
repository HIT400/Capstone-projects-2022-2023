import * as fp from "fingerpose";

const letterJ = new fp.GestureDescription("J");

//start of j
letterJ.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 0.9);
letterJ.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1);
letterJ.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterJ.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);

letterJ.addCurl(fp.Finger.Pinky, fp.FingerCurl.NoCurl, 1.0);
letterJ.addDirection(fp.Finger.Pinky, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterJ.addDirection(fp.Finger.Pinky, fp.FingerDirection.DiagonalUpRight, 1.0);
letterJ.addDirection(fp.Finger.Pinky, fp.FingerDirection.HorizontalRight, 1.0);
letterJ.addDirection(fp.Finger.Pinky, fp.FingerDirection.HorizontalLeft, 1.0);
letterJ.addDirection(fp.Finger.Pinky, fp.FingerDirection.VerticalUp, 1.0);
letterJ.addDirection(fp.Finger.Pinky, fp.FingerDirection.DiagonalDownLeft, 1.0);
letterJ.addDirection(
    fp.Finger.Pinky,
    fp.FingerDirection.DiagonalDownRight,
    1.0
);

for (let finger of [fp.Finger.Ring, fp.Finger.Index, fp.Finger.Middle]) {
    letterJ.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterJ.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterJ.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1.0);
    letterJ.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1.0);
    letterJ.addDirection(finger, fp.FingerDirection.HorizontalLeft, 1.0);
    letterJ.addDirection(finger, fp.FingerDirection.HorizontalRight, 1.0);
    letterJ.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
}

export default letterJ;
