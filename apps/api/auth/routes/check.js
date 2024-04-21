const { isWhitelisted } = require('../../services/auth');

const express = require('express');
const router = express.Router();

router.post('/', async (req, res) => {
    const email = req.body['email'];

    if (isWhitelisted(email)) {
        res.status(200).send();
    } else {
        res.status(401).send();
    }
});

module.exports = router;