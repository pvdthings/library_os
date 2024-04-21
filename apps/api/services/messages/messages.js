const LOAN_REMINDER_WEBHOOK_URL = process.env.LOAN_REMINDER_WEBHOOK_URL;

async function sendLoanReminder({ loanNumber }) {
  await fetch(LOAN_REMINDER_WEBHOOK_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      loanNumber
    })
  });
}

module.exports = {
  sendLoanReminder
};