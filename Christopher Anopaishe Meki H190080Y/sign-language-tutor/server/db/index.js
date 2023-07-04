//this is the access point for all things database related!

const db = require("./db");

const User = require("./models/User");
const Phrase = require("./models/Phrase");
const PhraseUser = require("./models/PhraseUser");

User.belongsToMany(Phrase, { through: PhraseUser });
Phrase.belongsToMany(User, { through: PhraseUser });

module.exports = {
    db,
    models: {
        User,
        Phrase,
        PhraseUser,
    },
};
