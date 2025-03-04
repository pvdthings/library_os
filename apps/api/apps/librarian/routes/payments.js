const { fetchPayments, recordCashPayment } = require('../../../services/payments/payments');

const express = require('express');
const router = express.Router();

router.get('/:borrowerId', async (req, res) => {
    const { borrowerId } = req.params;
    try {
        const payments = await fetchPayments(borrowerId);
        res.status(200).send(payments);
    } catch (error) {
        console.error(error);
        res.status(error.statusCode || 500).send({ error: error.toString() });
    }
});

router.put('/:borrowerId', async (req, res) => {
    const { borrowerId } = req.params;
    try {
        const paymentId = await recordCashPayment({ borrowerId });
        res.status(201).send({ id: paymentId });
    } catch (error) {
        console.error(error);
        res.status(500).send({ error });
    }
});

module.exports = router;