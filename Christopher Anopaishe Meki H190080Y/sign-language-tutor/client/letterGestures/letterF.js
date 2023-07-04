import * as fp from "fingerpose";

const letterF = new fp.GestureDescription("F");

//thumb
letterF.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1.0);
letterF.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 0.9);
letterF.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);
letterF.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 0.9);
letterF.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 0.9);

//index
letterF.addCurl(fp.Finger.Index, fp.FingerCurl.FullCurl, 1.0);
letterF.addCurl(fp.Finger.Index, fp.FingerCurl.HalfCurl, 0.9);
letterF.addDirection(fp.Finger.Index, fp.FingerDirection.VerticalUp, 1.0);
letterF.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpLeft, 0.9);
letterF.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpRight, 0.9);

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky, fp.Finger.Middle]) {
    letterF.addCurl(finger, fp.FingerCurl.NoCurl, 1.0);
    letterF.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterF.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 0.9);
    letterF.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 0.9);
}

export default letterF;
