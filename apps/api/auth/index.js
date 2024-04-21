const express = require('express');
const router = express.Router();
const checkEndpoint = require('./routes/check');

router.use('/check', checkEndpoint);

module.exports = router;