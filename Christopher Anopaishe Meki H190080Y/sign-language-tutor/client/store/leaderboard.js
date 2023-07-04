import axios from "axios";
import { authenticateRequest } from "./gateKeepingMiddleware";

//ACTION TYPES
const SET_LEADERS = "SET_LEADERS";

//ACTION CREATORS
const setLeaders = leaders => {
    return {
        type: SET_LEADERS,
        leaders,
    };
};

//zTHUNK CREATOR
export const fetchLeaders = () => async dispatch => {
    try {
        const leaders = await authenticateRequest("get", "/api/users");

        dispatch(setLeaders(leaders));
    } catch (error) {
        console.log(error);
    }
};

//REDUCER
export default function (state = [], action) {
    switch (action.type) {
        case SET_LEADERS:
            return action.leaders;
        default:
            return state;
    }
}
