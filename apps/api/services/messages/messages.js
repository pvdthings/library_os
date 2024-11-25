const LOAN_REMINDER_WEBHOOK_URL = process.env.LOAN_REMINDER_WEBHOOK_URL;
const JOBS_NOTIFICATION_WEBHOOK_URL = process.env.JOBS_NOTIFICATION_WEBHOOK_URL;

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

async function sendJobsNotification({ recipient, ids }) {
  await fetch(JOBS_NOTIFICATION_WEBHOOK_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      recipient,
      jobs: ids
    })
  });
}

module.exports = {
  sendLoanReminder,
  sendJobsNotification
};