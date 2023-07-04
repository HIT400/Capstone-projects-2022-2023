import axios from "axios";
import history from "../history";
import { authenticateRequest } from "./gateKeepingMiddleware";

const TOKEN = "token";

/**
 * ACTION TYPES
 */
const SET_AUTH = "SET_AUTH";
const UPDATE_USER = "UPDATE_USER";

/**
 * ACTION CREATORS
 */
const setAuth = auth => ({ type: SET_AUTH, auth });
const updateUser = user => ({ type: UPDATE_USER, user });

/**
 * THUNK CREATORS
 */
export const me = () => async dispatch => {
    const token = window.localStorage.getItem(TOKEN);
    if (token) {
        const res = await axios.get("/auth/me", {
            headers: {
                authorization: token,
            },
        });
        return dispatch(setAuth(res.data));
    }
};

export const authenticate =
    (email, password, method, firstname, lastname) => async dispatch => {
        try {
            const res = await axios.post(`/auth/${method}`, {
                email,
                password,
                firstname,
                lastname,
            });
            window.localStorage.setItem(TOKEN, res.data.token);
            dispatch(me());
        } catch (authError) {
            return dispatch(setAuth({ error: authError }));
        }
    };

export const logout = () => {
    window.localStorage.removeItem(TOKEN);
    history.push("/");
    return {
        type: SET_AUTH,
        auth: {},
    };
};

export const setUser = newUserInfo => async dispatch => {
    try {
        const res = await authenticateRequest(
            "put",
            "/api/users/user",
            newUserInfo
        );

        dispatch(updateUser(res));
    } catch (error) {
        console.log(error);
    }
};

/**
 * REDUCER
 */
export default function (state = {}, action) {
    switch (action.type) {
        case SET_AUTH:
            return action.auth;
        case UPDATE_USER:
            return action.user;
        default:
            return state;
    }
}
