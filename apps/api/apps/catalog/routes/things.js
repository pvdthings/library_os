const express = require('express');
const router = express.Router();
const { getCatalogData } = require('../services/catalog');
const { getThingDetails } = require('../services/thingDetails');
const { getItemDetails } = require('../services/itemDetails');
// const { enroll, getShifts } = require('../services/shifts');
// const { findMember } = require('../../../services/borrowers');

router.get('/', async (req, res) => {
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

// router.get('/volunteer/shifts', async (req, res) => {
//     const email = req.headers['x-email'];
//     try {
//         res.send(await getShifts({ email }));
//     } catch (error) {
//         console.error(error);
//         res.status(error.status || 500).send({ errors: [error] });
//     }
// });

// router.post('/volunteer/auth', async (req, res) => {
//     const { email } = req.body;
//     try {
//         const member = await findMember({ email });

//         if (member) {
//             res.send(member);
//         } else {
//             res.sendStatus(403);
//         }
//     } catch (error) {
//         console.error(error);
//         res.status(error.status || 500).send({ errors: [error] });
//     }
// });

// router.post('/volunteer/shifts/enroll', async (req, res) => {
//     const email = req.headers['x-email'];
//     const { shifts } = req.body;
//     try {
//         await enroll(email, shifts);
//         res.sendStatus(204);
//     } catch (error) {
//         console.error(error);
//         res.status(error.status || 500).send({ errors: [error] });
//     }
// });

module.exports = router;