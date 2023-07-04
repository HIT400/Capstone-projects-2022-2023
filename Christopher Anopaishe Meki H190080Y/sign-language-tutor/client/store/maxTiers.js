import axios from "axios";
import { authenticateRequest } from "./gateKeepingMiddleware";

//action types
const GET_MAX_TIERS = "GET_MAX_TIERS";

//action creators
const setMaxTiers = tiers => {
    return {
        type: GET_MAX_TIERS,
        tiers,
    };
};

//thunk creators
export const fetchMaxTiers = () => async dispatch => {
    try {
        const maxTiers = await authenticateRequest("get", "/api/users/maxTier");
        dispatch(setMaxTiers(maxTiers));
    } catch (error) {
        console.log(error);
    }
};

//reducer
export default function (state = {}, action) {
    switch (action.type) {
        case GET_MAX_TIERS:
            return action.tiers;
        default:
            return state;
    }
}
