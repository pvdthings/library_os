const express = require('express')
const router = express.Router()
const ThingsController = require('../controllers/things-controller')

router.get('/', async (req, res) => {
    await ThingsController.getThings(req, res)
})

module.exports = router