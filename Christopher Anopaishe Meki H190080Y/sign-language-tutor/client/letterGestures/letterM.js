import * as fp from "fingerpose";

const letterM = new fp.GestureDescription("M");

letterM.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 0.9);
letterM.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1);
letterM.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterM.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterM.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);

for (let finger of [
    fp.Finger.Ring,
    fp.Finger.Pinky,
    fp.Finger.Middle,
    fp.Finger.Index,
]) {
    letterM.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterM.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterM.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterM.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 0.9);
    letterM.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 0.9);
}

export default letterM;
