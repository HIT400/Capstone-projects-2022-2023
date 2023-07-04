import * as fp from "fingerpose";

const letterN = new fp.GestureDescription("N");

letterN.addCurl(fp.Finger.Thumb, fp.FingerCurl.FullCurl, 0.9);
letterN.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1);
letterN.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1.0);
letterN.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1.0);

for (let finger of [
    fp.Finger.Ring,
    fp.Finger.Pinky,
    fp.Finger.Middle,
    fp.Finger.Index,
]) {
    letterN.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterN.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterN.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterN.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterN.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 0.9);
    letterN.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 0.9);
}

export default letterN;
