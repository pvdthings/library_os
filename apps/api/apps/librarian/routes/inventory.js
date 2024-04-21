const { fetchItems, fetchItem, createItems, updateItem, deleteItem } = require('../../../services/inventory');

const express = require('express');
const router = express.Router();

router.get('/', async (req, res) => {
    try {
        res.send(await fetchItems());
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.get('/:id', async (req, res) => {
    try {
        res.send(await fetchItem(req.params.id));
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.put('/', async (req, res) => {
    const { thingId, quantity, brand, condition, description, estimatedValue, hidden, image, manuals } = req.body;

    try {
        res.send(await createItems(thingId, { quantity, brand, condition, description, estimatedValue, hidden, image, manuals }));
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.patch('/:id', async (req, res) => {
    const { brand, description, estimatedValue, hidden, condition, image, manuals } = req.body;

    try {
        await updateItem(req.params.id, { brand, description, estimatedValue, hidden, condition, image, manuals });
        res.status(204).send();
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.delete('/:id', async (req, res) => {
    const { id } = req.params;

    try {
        await deleteItem(id);
        res.status(204).send();
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

module.exports = router;