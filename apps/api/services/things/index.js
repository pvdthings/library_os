const mapThing = require('./mapThing');
const mapThingDetails = require('./mapThingDetails');
const service = require('./service');

module.exports = {
  mapThing,
  mapThingDetails,
  ...service
};