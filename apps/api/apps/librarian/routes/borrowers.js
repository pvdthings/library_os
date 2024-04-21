const { fetchBorrowers, fetchBorrower, updateBorrower } = require('../../../services/borrowers');

const express = require('express');
const router = express.Router();

router.get('/', async (req, res) => {
    res.send(await fetchBorrowers());
});

router.get('/:id', async (req, res) => {
    res.send(await fetchBorrower({ id: req.params.id }));
});

router.patch('/:id/contact', async (req, res) => {
    try {
        const { id } = req.params;
        const { email, phone } = req.body;

        await updateBorrower(id, { email, phone });
        res.status(204).send();
    } catch (error) {
        console.error(error);
        res.status(error.statusCode || 500).send({ errors: [error] });
    }
});

module.exports = router;