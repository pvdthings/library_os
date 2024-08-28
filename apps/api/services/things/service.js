const { base, Table, ThingCategories } = require('../../db');
const mapThing = require('./mapThing');
const mapThingDetails = require('./mapThingDetails');
const { mapItem } = require('../inventory');
const things = base(Table.Things);
const inventory = base(Table.Inventory);

const thingFields = ['Name', 'name_es', 'Stock', 'Available', 'Image', 'Category', 'Hidden', 'Next Due Back'];

const fetchCategories = () => ThingCategories;

const fetchThings = async ({ byPopularity } = {}) => {
  const records = await things.select({
    view: byPopularity ? 'api_by_popularity' : 'api_by_name',
    fields: thingFields,
    pageSize: 100
  }).all();

  return records.map(mapThing);
}

const fetchThing = async (id) => {
  const record = await things.find(id);

  const itemPromises = record?.get('Inventory')?.map(id => inventory.find(id)) || [];
  const linkedThingPromises = record?.get('Linked Things')?.map(id => things.find(id)) || [];

  const [itemRecords, linkedThingRecords] = await Promise.all([
    Promise.all(itemPromises),
    Promise.all(linkedThingPromises)
  ]);

  return record ? mapThingDetails(record, itemRecords, linkedThingRecords) : null;
}

const createThing = async ({ name, spanishName, hidden, image, eyeProtection }) => {
  const record = await things.create({
    'Name': name,
    'name_es': spanishName,
    'Eye Protection': eyeProtection,
    'Hidden': hidden,
    'Image': image?.url ? [{ url: image.url }] : []
  });

  return record ? mapThingDetails(record) : null;
}

const updateThing = async (id, { name, spanishName, hidden, image, eyeProtection }) => {
  let updatedFields = {};

  if (name) {
    updatedFields['Name'] = name;
  }

  if (spanishName) {
    updatedFields['name_es'] = spanishName;
  }

  if (hidden !== null) {
    updatedFields['Hidden'] = hidden;
  }

  if (image?.url) {
    updatedFields['Image'] = [{ url: image.url }];
  }

  if (eyeProtection !== null) {
    updatedFields['Eye Protection'] = eyeProtection;
  }

  await things.update(id, updatedFields);
}

const deleteThing = async (id) => {
  await things.destroy(id);
}

const updateThingCategories = async (id, { categories }) => {
  await things.update(id, { 'Category': categories });
}

const deleteThingImage = async (id) => {
  const record = await things.update(id, { 'Image': [] });
  return mapThingDetails(record);
}

module.exports = {
  fetchCategories,
  fetchThings,
  fetchThing,
  createThing,
  updateThing,
  updateThingCategories,
  deleteThingImage,
  deleteThing,
};