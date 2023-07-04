const {
    models: { User },
} = require("../db");

//makes sure user is logged in
const requireToken = async (req, res, next) => {
    try {
        const user = await User.findByToken(req.headers.authorization);
        if (user) {
            req.user = user;
            next();
        } else {
            const error = new Error("User needs to be logged in");
            next(error);
        }
    } catch (error) {
        next(error);
    }
};

//makes sure user is an admin
const isAdmin = (req, res, next) => {
    if (!req.user) {
        const error = new Error("User needs to be logged in as Admin");
        next(error);
        return;
    }

    if (req.user.type !== "admin") {
        return res.sendStatus(403);
    } else {
        next();
    }
};

module.exports = {
    requireToken,
    isAdmin,
};
