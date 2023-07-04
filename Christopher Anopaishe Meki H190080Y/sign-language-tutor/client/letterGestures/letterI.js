import * as fp from "fingerpose";

const letterI = new fp.GestureDescription("I");

letterI.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1.0);
letterI.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterI.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);

letterI.addCurl(fp.Finger.Pinky, fp.FingerCurl.NoCurl, 1.0);
letterI.addDirection(fp.Finger.Index, fp.FingerDirection.VerticalUp, 1.0);
letterI.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalLeft, 1.0);
letterI.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalRight, 1.0);

for (let finger of [fp.Finger.Ring, fp.Finger.Index, fp.Finger.Middle]) {
    letterI.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterI.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterI.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterI.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1.0);
    letterI.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1.0);
}

export default letterI;
