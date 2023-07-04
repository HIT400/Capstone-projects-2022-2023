import axios from "axios";
import { authenticateRequest } from "./gateKeepingMiddleware";

//action types
const GET_POINTS = "GET_POINTS";

//action creators
const getPointsAC = points => {
    return {
        type: GET_POINTS,
        points,
    };
};

//thunk creators
export const getPoints = () => async dispatch => {
    try {
        const userPoints = await authenticateRequest("get", `/api/users/points`);
        dispatch(getPointsAC(userPoints));
    } catch (error) {
        console.log(error);
    }
};

export const addPoints = incrementalQty => async () => {
    try {
        await authenticateRequest("put", `/api/users/points`, { incrementalQty });
    } catch (error) {
        console.log(error);
    }
};

//reducer
export default function (state = 0, action) {
    switch (action.type) {
        case GET_POINTS:
            return action.points;
        default:
            return state;
    }
}
