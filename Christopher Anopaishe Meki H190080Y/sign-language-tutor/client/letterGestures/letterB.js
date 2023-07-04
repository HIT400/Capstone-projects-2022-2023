import * as fp from "fingerpose";

const letterB = new fp.GestureDescription("B");

letterB.addCurl(fp.Finger.Thumb, fp.FingerCurl.HalfCurl, 1);
letterB.addDirection(fp.Finger.Thumb, fp.FingerDirection.VerticalUp, 1);

for (let finger of [
    fp.Finger.Index,
    fp.Finger.Middle,
    fp.Finger.Ring,
    fp.Finger.Pinky,
]) {
    letterB.addCurl(finger, fp.FingerCurl.NoCurl, 1.0);
    letterB.addCurl(finger, fp.FingerDirection.VerticalUp, 1.0);
}

export default letterB;
