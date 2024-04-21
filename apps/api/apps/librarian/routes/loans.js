const { fetchLoans, fetchLoan, createLoan, updateLoan, updateDueDates } = require('../../../services/loans');
const authorizeAdminUser = require('../../../middleware/adminAuthorization');

const express = require('express');
const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const includeClosedLoans = req.query['closed'];
        const loans = await fetchLoans({ includeClosed: includeClosedLoans });
        res.status(200).send(loans);
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send();
    }
});

router.get('/:loanId/:itemId', async (req, res) => {
    try {
        const loan = await fetchLoan({ loanId: req.params.loanId, itemId: req.params.itemId });
        if (loan) {
            res.status(200).send(loan);
        } else {
            res.status(404).send();
        }
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send();
    }
});

router.put('/', async (req, res) => {
    try {
        const newLoanId = await createLoan(req.body);
        res.status(201).send({ id: newLoanId });
    } catch (error) {
        console.error(error);
        res.status(500).send({ error });
    }
});

router.patch('/:loanId/:thingId', async (req, res) => {
    const { notes, dueBackDate, checkedInDate } = req.body;
    try {
        await updateLoan({
            loanId: req.params.loanId,
            thingId: req.params.thingId,
            notes,
            dueBackDate,
            checkedInDate
        });
        res.status(204).send();
    } catch (error) {
        console.error(error);
        res.status(500).send({ error });
    }
});

router.head('/extend', authorizeAdminUser, async (req, res) => {
    res.status(204).send();
});

router.post('/extend', authorizeAdminUser, async (req, res) => {
    const { dueDate } = req.body;
    try {
        const success = await updateDueDates({ dueDate });
        res.status(200).send({ success });
    } catch (error) {
        console.error(error);
        res.status(error.status || 500).send({ error });
    }
});

module.exports = router;