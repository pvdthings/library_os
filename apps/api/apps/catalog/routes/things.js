const express = require('express');
const router = express.Router();
const { getCatalogData } = require('../services/catalog');

router.get('/', async (req, res) => {
    try {
        res.send(await getCatalogData());
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

module.exports = router;