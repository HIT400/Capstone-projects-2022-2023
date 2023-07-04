import * as fp from "fingerpose";

const letterG = new fp.GestureDescription("G");

letterG.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1.0);
letterG.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 0.9);
letterG.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalLeft, 1.0);
letterG.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalRight, 1.0);
letterG.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 0.9);
letterG.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 0.9);

letterG.addCurl(fp.Finger.Index, fp.FingerCurl.NoCurl, 1.0);
letterG.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalLeft, 1.0);
letterG.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalRight, 1.0);

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky, fp.Finger.Middle]) {
    letterG.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterG.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterG.addDirection(finger, fp.FingerDirection.HorizontalRight, 1.0);
    letterG.addDirection(finger, fp.FingerDirection.HorizontalLeft, 1.0);
}

export default letterG;
