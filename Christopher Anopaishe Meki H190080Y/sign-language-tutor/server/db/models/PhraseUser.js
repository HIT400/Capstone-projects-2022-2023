const Sequelize = require("sequelize");
const db = require("../db");

const PhraseUser = db.define("phraseUser", {
    isComplete: {
        type: Sequelize.BOOLEAN,
        defaultValue: false,
    },
});

module.exports = PhraseUser;
