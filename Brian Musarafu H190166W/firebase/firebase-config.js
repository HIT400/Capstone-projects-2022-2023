import {initializeApp} from 'firebase/app';
import {getAuth, createUserWithEmailAndPassword} from 'firebase/auth';

// TODO: Replace the following with your app's Firebase project configuration

const firebaseConfig = {
  apiKey: 'AIzaSyCDfemkfMbAyU9l6Iq1vPphnZAkEC705rM',
  authDomain: 'museum-tour-acd2c.firebaseapp.com',
  databaseURL: 'https://museum-tour-acd2c-default-rtdb.firebaseio.com',
  projectId: 'museum-tour-acd2c',
  storageBucket: 'museum-tour-acd2c.appspot.com',
  messagingSenderId: '784191897687',
  appId: '1:784191897687:web:23e706e0b136e399526312',
  measurementId: 'G-3G2PWWQ3ME',
};

if (!firebase.apps.length) {
  firebase.initializeApp(firebaseConfig);
}

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase Authentication and get a reference to the service
const auth = getAuth(app);
export const authentication = getAuth(app);
