const { fetchCategories, fetchThings, fetchThing, createThing, updateThing, deleteThingImage, updateThingCategories, deleteThing } = require('../../../services/things');

const express = require('express');
const router = express.Router();

router.get('/categories', async (req, res) => {
    try {
        res.send(fetchCategories());
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.get('/', async (req, res) => {
    try {
        res.send(await fetchThings());
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.get('/:id', async (req, res) => {
    try {
        res.send(await fetchThing(req.params.id));
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.put('/', async (req, res) => {
    const { name, spanishName, eyeProtection, hidden, image } = req.body;

    try {
        res.send(await createThing({ name, spanishName, eyeProtection, hidden, image }));
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.patch('/:id', async (req, res) => {
    const { id } = req.params;
    const { name, spanishName, eyeProtection, hidden, image } = req.body;

    try {
        await updateThing(id, { name, spanishName, eyeProtection, hidden, image });
        res.status(204).send();
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.patch('/:id/categories', async (req, res) => {
    const { id } = req.params;
    const { categories } = req.body;

    try {
        await updateThingCategories(id, { categories });
        res.status(204).send();
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.delete('/:id', async (req, res) => {
    const { id } = req.params;

    try {
        await deleteThing(id);
        res.status(204).send();
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

router.delete('/:id/image', async (req, res) => {
    const { id } = req.params;

    try {
        res.send(await deleteThingImage(id));
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ errors: [error] });
    }
});

module.exports = router;