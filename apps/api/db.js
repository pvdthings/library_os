const Airtable = require('airtable');
const base = new Airtable({ apiKey: process.env.AIRTABLE_KEY }).base(process.env.AIRTABLE_BASE_ID);

const Table = {
    Inventory: 'Inventory',
    Things: 'Things',
    Borrowers: 'Members',
    Loans: 'Loans',
    Payments: 'Transactions'
};

const BorrowerIssue = {
    DuesNotPaid: 'duesNotPaid',
    OverdueLoan: 'overdueLoan',
    Suspended: 'suspended',
    NeedsLiabilityWaiver: 'needsLiabilityWaiver'
};

const ThingCategories = [
    'Media',
    'Games',
    'Outdoors',
    'DIY',
    'Sports',
    'Entertainment',
    'Yard',
    'Cleaning',
    'Cooking',
    'Crafts',
    'Pet',
    'Automotive',
    'Health',
    'Household'
];

module.exports = {
    Table,
    base,
    BorrowerIssue,
    ThingCategories
};