import * as fp from "fingerpose";

const letterQ = new fp.GestureDescription("Q");

letterQ.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1.0);
letterQ.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalLeft, 1.0);
letterQ.addDirection(fp.Finger.Thumb, fp.FingerDirection.HorizontalRight, 1.0);
letterQ.addDirection(
    fp.Finger.Thumb,
    fp.FingerDirection.DiagonalDownRight,
    1.0
);
letterQ.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalDownLeft, 1.0);

letterQ.addCurl(fp.Finger.Index, fp.FingerCurl.NoCurl, 1);
letterQ.addCurl(fp.Finger.Index, fp.FingerCurl.HalfCurl, 1);
letterQ.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalDownLeft, 1.0);
letterQ.addDirection(
    fp.Finger.Index,
    fp.FingerDirection.DiagonalDownRight,
    1.0
);
letterQ.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalLeft, 0.9);
letterQ.addDirection(fp.Finger.Index, fp.FingerDirection.HorizontalRight, 0.9);

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky, fp.Finger.Middle]) {
    letterQ.addCurl(finger, fp.FingerCurl.HalfCurl, 1);
    letterQ.addCurl(finger, fp.FingerCurl.FullCurl, 1);
    letterQ.addDirection(finger, fp.FingerDirection.HorizontalRight, 1.0);
    letterQ.addDirection(finger, fp.FingerDirection.HorizontalLeft, 1.0);
}

export default letterQ;
