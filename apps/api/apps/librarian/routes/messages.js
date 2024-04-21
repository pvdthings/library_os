const { sendLoanReminder } = require('../../../services/messages');

const express = require('express');
const router = express.Router();

router.post('/loan-reminder', async (req, res) => {
  const { loanNumber } = req.body;

  try {
    await sendLoanReminder({ loanNumber });
    res.status(204).send();
  } catch (error) {
    console.error(error);
    res.status(error.status).send({ errors: [error] })
  }
});

module.exports = router;