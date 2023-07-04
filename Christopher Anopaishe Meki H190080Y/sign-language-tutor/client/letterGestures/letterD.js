import * as fp from "fingerpose";

const letterD = new fp.GestureDescription("D");

//thumb
letterD.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl);
letterD.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1.0);

//index
letterD.addCurl(fp.Finger.Index, fp.FingerCurl.NoCurl);
letterD.addDirection(fp.Finger.Index, fp.FingerDirection.VerticalUp, 1.0);
letterD.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpLeft, 1.0);
letterD.addDirection(fp.Finger.Index, fp.FingerDirection.DiagonalUpRight, 1.0);

//middle
letterD.addCurl(fp.Finger.Middle, fp.FingerCurl.FullCurl);
letterD.addDirection(fp.Finger.Middle, fp.FingerDirection.VerticalUp, 1.0);
letterD.addDirection(fp.Finger.Middle, fp.FingerDirection.DiagonalUpRight, 0.9);
letterD.addDirection(fp.Finger.Middle, fp.FingerDirection.DiagonalUpLeft, 0.9);

for (let finger of [fp.Finger.Ring, fp.Finger.Pinky]) {
    letterD.addCurl(finger, fp.FingerCurl.FullCurl, 1.0);
    letterD.addCurl(finger, fp.FingerCurl.HalfCurl, 0.9);
    letterD.addDirection(finger, fp.FingerDirection.VerticalUp, 1.0);
    letterD.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1.0);
    letterD.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1.0);
}

export default letterD;
