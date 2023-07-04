import * as fp from "fingerpose";

const letterC = new fp.GestureDescription("C");

//thumb
letterC.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1);
letterC.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalRight, 1);
letterC.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalLeft, 1);

//pinky
letterC.addCurl(fp.Finger.Pinky, fp.FingerCurl.NoCurl, 1);
letterC.addCurl(fp.Finger.Pinky, fp.FingerCurl.HalfCurl, 1);
letterC.addDirection(fp.Finger.Pinky, fp.FingerDirection.DiagonalUpRight, 1);
letterC.addDirection(fp.Finger.Pinky, fp.FingerDirection.DiagonalUpLeft, 1);

for (let finger of [fp.Finger.Index, fp.Finger.Middle, fp.Finger.Ring]) {
    letterC.addCurl(finger, fp.FingerCurl.HalfCurl, 1);
    letterC.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1);
    letterC.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1);
}

export default letterC;
