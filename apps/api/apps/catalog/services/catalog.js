const minify = require('../lib/minify');
const { fetchThings, fetchCategories } = require('../../../services/things');

const getCatalogData = async () => {
    const things = (await fetchThings({ byPopularity: true })).filter(t => t.categories);
    const categories = fetchCategories();

    return {
        things: things.map(minify),
        categories: ["All", ...categories]
    };
}

module.exports = {
    getCatalogData
}