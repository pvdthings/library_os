const { fetchItem } = require("../../../services/inventory");
const mapItemStatus = require("./mapItemStatus");

async function getItemDetails(id) {
  const details = await fetchItem(null, { recordId: id });

  return {
    id: details.id,
    name: details.name,
    number: details.number,
    spanishName: details.name_es,
    available: details.available,
    availableDate: details.dueBack,
    brand: details.brand,
    condition: details.condition,
    eyeProtection: details.eyeProtection,
    totalLoans: details.totalLoans,
    image: details.images.length ? details.images[0] : undefined,
    manuals: details.manuals?.map((m) => m.url) || [],
    status: mapItemStatus(details)
  };
}

module.exports = {
  getItemDetails
}