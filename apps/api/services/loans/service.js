const { base, Table } = require('../../db');
const { postWebhook } = require('../webhooks');
const mapLoan = require('./mapLoan');
const mapLoanDetails = require('./mapLoanDetails');

const loans = base(Table.Loans);
const items = base(Table.Inventory);

const loanDetailsFields = [
  'Loan',
  'Borrower',
  'Borrower Name',
  'Borrower Email',
  'Borrower Phone',
  'Notes',
  'Things',
  'Borrowed Things',
  'Returned Things',
  'Checked Out',
  'checked_in_date',
  'Due Back',
  'thing_numbers',
  'reminders_sent'
];

// Loan
const fetchLoans = async ({ includeClosed }) => {
  const view = includeClosed ? 'api_all_loans' : 'api_open_loans';
  const results = await loans.select({
    view: view,
    fields: loanDetailsFields,
    pageSize: 100
  }).all();

  const fetchedLoans = [];

  // Because of the Airtable schema, we have to map each record to multiple loans, one for each thing
  results.forEach(r => {
    const returnedThings = r.get('Returned Things') || [];
    const activeThings = r.get('Things').filter(t => !returnedThings.includes(t));

    activeThings.forEach(itemId => fetchedLoans.push(mapLoan(r, itemId)));
  });

  return fetchedLoans;
};

// Loan Details
const fetchLoan = async ({ loanId, itemId }) => {
  const [loan, item] = await Promise.all([
    loans.find(loanId),
    items.find(itemId)
  ]);

  return loan ? mapLoanDetails(loan, item) : null;
};

const createLoan = async ({
  borrowerId,
  thingIds,
  checkedOutDate,
  dueBackDate,
  notes
}) => {
  const loan = await loans.create({
    "Borrower": [borrowerId],
    "Things": thingIds,
    "Checked Out": checkedOutDate,
    "Due Back": dueBackDate,
    "Status": "Active",
    "Returned Things": [],
    "Notes": notes
  });

  return loan.id;
};

const updateLoan = async ({
  loanId,
  thingId,
  dueBackDate,
  checkedInDate, // <- We can't use the value until we shift to the [1 Loan]:[1 Thing] paradigm
  notes
}) => {
  const loan = await loans.find(loanId);

  const fields = {};

  if (dueBackDate && dueBackDate !== '') {
    fields["Due Back"] = dueBackDate;
  }

  if (notes != undefined) {
    fields["Notes"] = notes;
  }

  const returnedThings = loan.get("Returned Things") || [];

  if (checkedInDate === '') {
    fields["Returned Things"] = returnedThings.filter(t => t.id === thingId);
  }

  if (checkedInDate && checkedInDate !== '') {
    fields["Returned Things"] = [...returnedThings, thingId];
  }

  await loans.update([
    {
      "id": loanId,
      fields
    }
  ]);
};

const updateDueDates = async ({ dueDate }) => {
  const UPDATE_DUE_DATES_WEBHOOK_URL = process.env.UPDATE_DUE_DATES_WEBHOOK_URL;
  const response = await postWebhook(UPDATE_DUE_DATES_WEBHOOK_URL, { dueDate });
  const { success } = await response.json();
  return success;
};

module.exports = {
  fetchLoans,
  fetchLoan,
  createLoan,
  updateLoan,
  updateDueDates
};