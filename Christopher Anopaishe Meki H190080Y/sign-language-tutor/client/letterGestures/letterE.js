import * as fp from "fingerpose";

const letterE = new fp.GestureDescription("E");

//thumb
letterE.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1);
letterE.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterE.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);

//index
letterE.addCurl(fp.Finger.Index, fp.FingerCurl.FullCurl, 1);
letterE.addDirection(fp.Finger.Index, fp.FingerDirection.VerticalUp, 0.9);
letterE.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpRight, 1);
letterE.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpLeft, 1);

//middle
letterE.addCurl(fp.Finger.Middle, fp.FingerCurl.FullCurl, 1);
letterE.addDirection(fp.Finger.Middle, fp.FingerDirection.VerticalUp, 1.0);
letterE.addDirection(fp.Finger.Middle, fp.FingerDirection.DiagonalUpRight, 0.9);
letterE.addDirection(fp.Finger.Middle, fp.FingerDirection.DiagonalUpLeft, 0.9);

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky]) {
    letterE.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterE.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterE.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterE.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 0.9);
    letterE.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 0.9);
}

export default letterE;
