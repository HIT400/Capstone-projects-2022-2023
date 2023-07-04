import React, { useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { withRouter, Route, Switch, Redirect } from "react-router-dom";
import { Login, Signup, Main } from "./components/AuthForm";
import Home from "./components/Home";
import { me } from "./store";
import SingleLearning from "./components/SingleLearning";
import CompletionPage from "./components/CompletionPage";
import AllLearning from "./components/AllLearning";
import QuickStartGuide from "./components/QuickStartGuide";
import UserProfile from "./components/UserProfile";
import SingleTest from "./components/SingleTest";
import AllTests from "./components/AllTests";
import Leaderboard from "./components/Leaderboard";
import CommonPhrases from "./components/CommonPhrases";
import StudyGuide from "./components/StudyGuide";
import TestCompletionPage from "./components/TestCompletionPage";

const Routes = () => {
    const isLoggedIn = useSelector(state => !!state.auth.id);
    const dispatch = useDispatch();

    useEffect(() => {
        dispatch(me());
    }, []);

    return (
        <div>
            {isLoggedIn ? (
                <Switch>
                    <Route exact path="/allLearning" component={AllLearning} />
                    <Route exact path="/allTests" component={AllTests} />
                    <Route exact path="/learning/:tier" component={SingleLearning} />
                    <Route exact path="/test/:tier" component={SingleTest} />
                    <Route path="/completionPage" component={CompletionPage} />
                    <Route path="/quickstart" component={QuickStartGuide} />
                    <Route path="/user" component={UserProfile} />
                    <Route path="/leaderboard" component={Leaderboard} />
                    <Route path="/commonphrases" component={CommonPhrases} />
                    <Route path="/studyguide" component={StudyGuide} />
                    <Route path="/testcompletionpage" component={TestCompletionPage} />
                    <Redirect to="/allLearning" />
                </Switch>
            ) : (
                <Switch>
                    <Route path="/" exact component={Main} />
                    <Route path="/login" component={Login} />
                    <Route path="/signup" component={Signup} />
                </Switch>
            )}
        </div>
    );
};

export default withRouter(Routes);
