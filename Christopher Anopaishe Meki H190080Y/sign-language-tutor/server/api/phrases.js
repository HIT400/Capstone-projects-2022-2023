const router = require("express").Router();
const {
    models: { User, Phrase },
} = require("../db");
module.exports = router;

//will get all phrases for a tier
router.get("/:tierId", async (req, res, next) => {
    try {
        const tier = await Phrase.findAll({
            where: {
                tiers: req.params.tierId,
            },
            order: [["letterwords", "ASC"]],
        });

        res.json(tier);
    } catch (error) {
        next(error);
    }
});

