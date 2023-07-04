"use strict";

const {
    db,
    models: { User, Phrase },
} = require("../server/db");

/**
 * seed - this function clears the database, updates tables to
 *      match the models, and populates the database.
 */
async function syncDB() {
    await db.sync({ force: true }); // clears db and matches models to tables
    console.log("db synced!");
}
// Creating Users
async function createUsers() {
    const users = await Promise.all([
        User.create({
            email: "cody@gmail.com",
            password: "123",
            firstname: "cody",
            lastname: "coder",
            points: 0,
            isAdmin: false,
        }),
        User.create({
            email: "murphy@gmail.com",
            password: "123",
            firstname: "murphy",
            lastname: "coder",
            points: 0,
            isAdmin: true,
        }),
    ]);
}

const letters = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
];

const letterLinks = [
    "letterA.png",
    "letterB.png",
    "letterC.png",
    "letterD.png",
    "letterE.png",
    "letterF.png",
    "letterG.png",
    "letterH.png",
    "letterI.png",
    "letterJ.png",
    "letterK.png",
    "letterL.png",
    "letterM.png",
    "letterN.png",
    "letterO.png",
    "letterP.png",
    "letterQ.png",
    "letterR.png",
    "letterS.png",
    "letterT.png",
    "letterU.png",
    "letterV.png",
    "letterW.png",
    "letterX.png",
    "letterY.png",
    "letterZ.png",
];

const textLinks = [
    "texta.png",
    "textb.png",
    "textc.png",
    "textd.png",
    "texte.png",
    "textf.png",
    "textg.png",
    "texth.png",
    "texti.png",
    "textj.png",
    "textk.png",
    "textl.png",
    "textm.png",
    "textn.png",
    "texto.png",
    "textp.png",
    "textq.png",
    "textr.png",
    "texts.png",
    "textt.png",
    "textu.png",
    "textv.png",
    "textw.png",
    "textx.png",
    "texty.png",
    "textz.png",
];

const tiers = [
    "1",
    "1",
    "1",
    "1",
    "2",
    "2",
    "2",
    "2",
    "3",
    "3",
    "3",
    "3",
    "3",
    "4",
    "4",
    "4",
    "4",
    "5",
    "5",
    "5",
    "5",
    "6",
    "6",
    "6",
    "6",
    "6",
];

async function createPhrases() {
    for (let i = 0; i < letters.length; i++) {
        await Phrase.create({
            tiers: tiers[i],
            letterwords: letters[i],
            url: letterLinks[i],
            textUrl: textLinks[i],
        });
    }
}

async function createConnections() {
    const user1 = await User.findByPk(1);
    const user2 = await User.findByPk(2);
    for (let i = 1; i < 5; i++) {
        await user1.addPhrase([i]);
        await user2.addPhrase([i]);
    }
}

const seedWithRandom = async () => {
    try {
        await createUsers();
        await createPhrases();
        await createConnections();
        console.log(`seeded successfully`);
    } catch (error) {
        console.error(error);
    }
};

/*
 We've separated the `seed` function from the `runSeed` function.
 This way we can isolate the error handling and exit trapping.
 The `seed` function is concerned only with modifying the database.
*/
async function runSeed() {
    console.log("seeding...");
    try {
        await syncDB();
        await seedWithRandom();
    } catch (err) {
        console.error(err);
        process.exitCode = 1;
    } finally {
        console.log("closing db connection");
        await db.close();
        console.log("db connection closed");
    }
}

/*
  Execute the `seed` function, IF we ran this module directly (`node seed`).
  `Async` functions always return a promise, so we can use `catch` to handle
  any errors that might occur inside of `seed`.
*/
if (module === require.main) {
    runSeed();
}

// we export the seed function for testing purposes (see `./seed.spec.js`)
module.exports = runSeed;
