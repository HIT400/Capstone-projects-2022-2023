import { createStore, combineReducers, applyMiddleware } from "redux";
import { createLogger } from "redux-logger";
import thunkMiddleware from "redux-thunk";
import { composeWithDevTools } from "redux-devtools-extension";
import maxTiers from "./maxTiers";
import auth from "./auth";
import phrases from "./phrases";
import leaderboard from "./leaderboard";
import testPhrases from "./testPhrases";
import points from "./points";

const reducer = combineReducers({
    auth,
    phrases,
    maxTiers,
    leaderboard,
    testPhrases,
    points,
});
const middleware = composeWithDevTools(
    applyMiddleware(thunkMiddleware, createLogger({ collapsed: true }))
);
const store = createStore(reducer, middleware);

export default store;
export * from "./auth";
