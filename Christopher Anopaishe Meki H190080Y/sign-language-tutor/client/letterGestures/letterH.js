import * as fp from "fingerpose";

const letterH = new fp.GestureDescription("H");

letterH.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1.0);
letterH.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 0.9);
letterH.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalLeft, 1.0);
letterH.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalRight, 1.0);
letterH.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 0.9);
letterH.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 0.9);

letterH.addCurl(fp.Finger.Index, fp.FingerCurl.NoCurl, 1.0);
letterH.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalLeft, 1.0);
letterH.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalRight, 1.0);

letterH.addCurl(fp.Finger.Middle, fp.FingerCurl.NoCurl, 1.0);
letterH.addDirection(fp.Finger.Middle, fp.FingerDirection.HorizontalLeft, 1.0);
letterH.addDirection(fp.Finger.Middle, fp.FingerDirection.HorizontalRight, 1.0);

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky]) {
    letterH.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterH.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterH.addDirection(finger, fp.FingerDirection.HorizontalRight, 1.0);
    letterH.addDirection(finger, fp.FingerDirection.HorizontalLeft, 1.0);
}

export default letterH;
