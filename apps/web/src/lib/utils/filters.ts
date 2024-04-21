// Will be automatically chosen on refresh as the filtered category
export const defaultFilterCategory = "All";

export const filter = (things, { keyword, onlyWishList, category }) => {
    let filtered = things ?? [];
    
    if (category && category.toLowerCase() !== "all")
        filtered = filtered.filter(thing => thing.categories.includes(category));

    if (keyword.length > 0)
        filtered = filtered.filter(thing => {
            return thing.name.toLowerCase().includes(keyword.toLowerCase()) 
                || (thing.spanishName && thing.spanishName?.toLowerCase().includes(keyword.toLowerCase()));
        });

    if (onlyWishList)
        filtered = filtered.filter(thing => thing.stock < 1);
    
    if (!onlyWishList)
        filtered = filtered.filter(thing => thing.stock !== 0);

    return filtered;
}

export const filterByCategory = (things, category) => {
    return category.toLowerCase() === "all" ? things : things.filter(thing => thing.categories?.includes(category));
}