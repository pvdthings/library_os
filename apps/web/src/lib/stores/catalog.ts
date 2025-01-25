import type { Thing, ThingID } from "$lib/api/models/Thing";
import { defaultFilterCategory, filter } from "$lib/utils/filters";
import { derived, get, writable } from "svelte/store";

export const categoryFilter = writable<string>(defaultFilterCategory);

export const searchFilter = writable<string>('');

export const wishListFilter = writable<boolean>(false);

export const things = writable<Thing[]>(undefined);

export const filteredThings = derived(
  [things, categoryFilter, searchFilter, wishListFilter],
  ([$things, $categoryFilter, $searchFilter, $wishListFilter]) => {
    return filter($things, {
			keyword: $searchFilter,
			onlyWishList: $wishListFilter,
			category: $categoryFilter
		});
  }
);

export const findThingById = (id: ThingID) => {
  return get(things).find(t => t.id === id);
};

export const categories = writable<string[]>(undefined);