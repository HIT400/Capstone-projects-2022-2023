const Sequelize = require("sequelize");
const db = require("../db");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const axios = require("axios");
const Phrase = require("./Phrase");

const SALT_ROUNDS = 5;

const User = db.define("user", {
    email: {
        type: Sequelize.STRING,
        unique: true,
        allowNull: false,
        validate: {
            notEmpty: true,
            isEmail: true,
        },
    },
    password: {
        type: Sequelize.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        },
    },
    firstname: {
        type: Sequelize.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        },
    },
    lastname: {
        type: Sequelize.STRING,
        allowNull: false,
        validate: {
            notEmpty: true,
        },
    },
    points: {
        type: Sequelize.INTEGER,
        defaultValue: 0,
        validate: {
            min: 0,
        },
    },
    isAdmin: {
        type: Sequelize.BOOLEAN,
        defaultValue: false,
    },
});

module.exports = User;

/**
 * instanceMethods
 */
User.prototype.correctPassword = function (candidatePwd) {
    //we need to compare the plain version to an encrypted version of the password
    return bcrypt.compare(candidatePwd, this.password);
};
const JWT_SECRET = "secret"
User.prototype.generateToken = function () {
    return jwt.sign({ id: this.id }, JWT_SECRET);
};

/**
 * classMethods
 */
User.authenticate = async function ({ email, password }) {
    const user = await this.findOne({ where: { email } });
    if (!user || !(await user.correctPassword(password))) {
        const error = Error("Incorrect username/password");
        error.status = 401;
        throw error;
    }
    return user.generateToken();
};

User.findByToken = async function (token) {
    try {
        const { id } = await jwt.verify(token, JWT_SECRET);
        const user = User.findByPk(id);
        if (!user) {
            throw "nooo";
        }
        return user;
    } catch (ex) {
        const error = Error("bad token");
        error.status = 401;
        throw error;
    }
};

/**
 * hooks
 */
const hashPassword = async user => {
    //in case the password has been changed, we want to encrypt it with bcrypt
    if (user.changed("password")) {
        user.password = await bcrypt.hash(user.password, SALT_ROUNDS);
    }
};

const addFirstTier = async user => {
    const firstTier = await Phrase.findAll({
        where: {
            tiers: 1,
        },
    });
    await user.addPhrases(firstTier);
};

User.afterCreate(addFirstTier);
User.beforeCreate(hashPassword);
User.beforeUpdate(hashPassword);
User.beforeBulkCreate(users => Promise.all(users.map(hashPassword)));
