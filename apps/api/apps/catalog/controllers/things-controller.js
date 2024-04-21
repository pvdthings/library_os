const minify = require('../lib/minify');
const { categories } = require('../lib/constants');

const Airtable = require('airtable');
const base = new Airtable({ apiKey: process.env.AIRTABLE_KEY }).base(process.env.AIRTABLE_BASE_ID);
const table = base('Things');

const getThings = async (_, res) => {
    const records = await table.select({
        view: 'api_by_popularity',
        pageSize: 100,
        filterByFormula: '{Hidden} = 0'
    }).all();

    res.send({
        things: records.map(minify),
        categories: ["All", ...categories]
    });
}

module.exports = {
    getThings
}