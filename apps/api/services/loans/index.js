const mapLoan = require('./mapLoan');
const mapLoanDetails = require('./mapLoanDetails');
const service = require('./service');

module.exports = {
  mapLoan,
  mapLoanDetails,
  ...service
};