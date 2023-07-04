import * as fp from "fingerpose";

const letterO = new fp.GestureDescription("O");

letterO.addCurl(fp.Finger.Thumb, fp.FingerCurl.NoCurl, 1.0);
letterO.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 0.9);
letterO.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpRight, 1);
letterO.addDirection(fp.Finger.Thumb, fp.FingerDirection.DiagonalUpLeft, 1);

for (let finger of [
    fp.Finger.Index,
    fp.Finger.Middle,
    fp.Finger.Ring,
    fp.Finger.Pinky,
]) {
    letterO.addCurl(finger, fp.FingerCurl.HalfCurl, 1.0);
    letterO.addDirection(finger, fp.FingerDirection.DiagonalUpRight, 1);
    letterO.addDirection(finger, fp.FingerDirection.DiagonalUpLeft, 1);
}

export default letterO;
