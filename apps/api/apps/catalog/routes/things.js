const express = require('express');
const router = express.Router();
const { getCatalogData } = require('../services/catalog');
const { getThingDetails } = require('../services/thingDetails');
const { getItemDetails } = require('../services/itemDetails');

router.get('/catalog', async (req, res) => {
    try {
        res.send(await getCatalogData());
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.get('/things/:id', async (req, res) => {
    const { id } = req.params;
    try {
        res.send(await getThingDetails(id));
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.get('/items/:id', async (req, res) => {
    const { id } = req.params;
    try {
        res.send(await getItemDetails(id));
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

module.exports = router;