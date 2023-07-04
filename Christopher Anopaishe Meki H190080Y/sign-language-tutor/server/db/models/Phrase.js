const Sequelize = require("sequelize");
const db = require("../db");

const Phrase = db.define("phrase", {
    tiers: {
        type: Sequelize.INTEGER,
        defaultValue: 1,
        allowNull: false,
        validate: {
            min: 1,
            notEmpty: true,
        },
    },
    letterwords: {
        type: Sequelize.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        },
    },
    url: {
        type: Sequelize.TEXT,
        allowNull: false,
        validate: {
            notEmpty: true,
        },
    },
    textUrl: {
        type: Sequelize.TEXT,
        allowNull: false,
    },
});

module.exports = Phrase;
