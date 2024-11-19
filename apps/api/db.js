const Airtable = require('airtable');
const base = new Airtable({ apiKey: process.env.AIRTABLE_KEY }).base(process.env.AIRTABLE_BASE_ID);

const Table = {
    Inventory: 'Inventory',
    Things: 'Things',
    Borrowers: 'Members',
    Jobs: 'Jobs',
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
    'Automotive',
    'Books',
    'Cleaning',
    'Cooking',
    'Crafts',
    'DIY',
    'Entertainment',
    'Games',
    'Health',
    'Household',
    'Media',
    'Outdoors',
    'Pet',
    'Sports',
    'Yard'
];

module.exports = {
    Table,
    base,
    BorrowerIssue,
    ThingCategories
};