const { fetchThing } = require("../../../services/things");
const mapItemStatus = require("./mapItemStatus");

async function getThingDetails(id) {
  const details = await fetchThing(id);

  return {
    id: details.id,
    name: details.name,
    spanishName: details.name_es,
    categories: details.categories,
    availableDate: details.availableDate,
    available: details.available,
    stock: details.stock,
    image: details.images?.length ? details.images[0].url : undefined,
    items: details.items.filter((i) => i.location !== 'Providence Public Library').map(item => ({
      id: item.id,
      number: item.number,
      brand: item.brand,
      hidden: item.hidden,
      status: mapItemStatus(item)
    }))
  };
}

module.exports = {
  getThingDetails
}