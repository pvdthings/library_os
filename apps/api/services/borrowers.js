const { base, Table, BorrowerIssue } = require('../db');

const borrowers = base(Table.Borrowers);

const mapBorrower = (record) => {
    return {
        id: record.id,
        name: record.get('Name'),
        contact: {
            email: record.get('Email'),
            phone: record.get('Phone')
        },
        issues: mapIssues(record)
    }
}

const mapIssues = (record) => {
    const issues = [];
    const numTransactions = Number(record.get('transactions_past_year'));

    if (!record.get('Dues Paid') && numTransactions < 1) issues.push(BorrowerIssue.DuesNotPaid);
    if (!record.get('Signed Liability Waiver')) issues.push(BorrowerIssue.NeedsLiabilityWaiver);
    if (record.get('Overdue Loans') > 0) issues.push(BorrowerIssue.OverdueLoan);
    if (record.get('Suspended')) issues.push(BorrowerIssue.Suspended);

    return issues;
}

const fetchBorrowers = async () => {
    const records = await borrowers.select({
        view: 'api',
        fields: [
            'Name',
            'Email',
            'Phone',
            'Active', 
            'Suspended', 
            'Overdue Loans', 
            'Dues Paid',
            'Signed Liability Waiver',
            'transactions_past_year'
        ],
        pageSize: 100
    }).all();

    return records.map(mapBorrower);
}

const fetchBorrower = async ({ id }) => {
    const record = await borrowers.find(id);
    return mapBorrower(record);
}

const findMember = async ({ email }) => {
    const matches = await borrowers.select({
        filterByFormula: `{Email} = '${email}'`
    }).all();

    return matches.length ? mapBorrower(matches[0]) : undefined;
};

const updateBorrower = async (id, { email, phone }) => {
    let updatedFields = {};

    if (email !== undefined) updatedFields['Email'] = email;
    if (phone !== undefined) updatedFields['Phone'] = phone;

    await borrowers.update(id, updatedFields);
}

module.exports = {
    fetchBorrowers,
    fetchBorrower,
    findMember,
    updateBorrower
};