const { base, Table, ThingCategories } = require('../../db');
const mapThing = require('./mapThing');
const mapThingDetails = require('./mapThingDetails');
const { mapItem } = require('../inventory');
const things = base(Table.Things);
const inventory = base(Table.Inventory);

const thingFields = ['Name', 'name_es', 'Stock', 'Available', 'Image', 'Category', 'Hidden'];

const fetchCategories = () => ThingCategories;

const fetchThings = async () => {
  const records = await things.select({
      view: 'api_by_name',
      fields: thingFields,
      pageSize: 100
  }).all();

  return records.map(mapThing);
}

const fetchThing = async (id) => {
  const record = await things.find(id);

  const itemIds = record.get('Inventory');

  const itemPromises = itemIds?.map(id => {
      return inventory.find(id)
  });

  const items = (await Promise.all(itemPromises || [])).map(mapItem);

  return record ? mapThingDetails(record, items) : null;
}

const createThing = async ({ name, spanishName, hidden, image, eyeProtection }) => {
  const record = await things.create({
      'Name': name,
      'name_es': spanishName,
      'Eye Protection': eyeProtection,
      'Hidden': hidden,
      'Image': image?.url ? [{ url: image.url }] : []
  });

  return record ? mapThingDetails(record, []) : null;
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