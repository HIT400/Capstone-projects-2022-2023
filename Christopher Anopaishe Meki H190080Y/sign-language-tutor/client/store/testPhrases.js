import axios from "axios";

const SET_TEST_PHRASES = "SET_TEST_PHRASES";

//action creators
const setTestPhrases = phrases => {
    return {
        type: SET_TEST_PHRASES,
        phrases,
    };
};

//thunk creators
export const fetchTestPhrases = tierId => async dispatch => {
    try {
        const secondTier = tierId * 2;
        const { data: currentPhrases1 } = await axios.get(
            `/api/phrases/${secondTier - 1}`
        );
        const { data: currentPhrases2 } = await axios.get(
            `/api/phrases/${secondTier}`
        );
        const currentPhrases = currentPhrases1.concat(currentPhrases2);

        dispatch(setTestPhrases(currentPhrases));
    } catch (error) {
        console.log(error);
    }
};

//reducer
export default function (state = [], action) {
    switch (action.type) {
        case SET_TEST_PHRASES:
            return action.phrases;
        default:
            return state;
    }
}
