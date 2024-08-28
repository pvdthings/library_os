const { mapItem } = require("../inventory");

function mapThingDetails(record, items = [], linkedThings = []) {
  return {
      id: record.id,
      name: record.get('Name'),
      name_es: record.get('name_es'),
      stock: Number(record.get('Stock')),
      available: Number(record.get('Available')),
      hidden: Boolean(record.get('Hidden')),
      categories: record.get('Category') || [],
      eyeProtection: Boolean(record.get('Eye Protection')),
      images: record.get('Image')?.map(mapImage) || [],
      items: items.map(mapItem),
      linkedThings: linkedThings.map(mapLinkedThing)
  };
}

function mapImage(image) {
  return {
    id: image.id,
    url: image.thumbnails.large.url,
    width: image.thumbnails.large.width,
    height: image.thumbnails.large.height,
    type: image.type
  };
}

function mapLinkedThing(thing) {
  return {
    id: thing.id,
    name: thing.get('Name')
  };
}

module.exports = mapThingDetails;