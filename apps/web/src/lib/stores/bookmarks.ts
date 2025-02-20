import { browser } from "$app/environment";
import type { ThingID } from "$lib/api/models/Thing";
import { derived, writable } from "svelte/store";

const defaultValue = [];

function createBookmarks() {
  let initialValue = browser ? JSON.parse(window.localStorage.getItem('myList'))
  ?? defaultValue : defaultValue;

  // convert from old format to new
  if (initialValue.length && (typeof initialValue[0]) !== 'string') {
    console.log('Converting old bookmarks...');
    initialValue = initialValue.map(b => b.id);
    window.localStorage.setItem('myList', JSON.stringify(initialValue));
  }

  const things = writable<ThingID[]>(initialValue);

  things.subscribe((value) => {
    if (browser) {
      window.localStorage.setItem('myList', JSON.stringify(value));
    }
  });

  const length = derived([things], ([$things]) => $things.length);

  const isBookmarked = (id: ThingID) => {
    return derived([things], ([$things]) => $things.includes(id));
  };

  const addRemove = (id: ThingID) => {
    things.update((value) => {
      const existingThing = value.find(t => t === id);
      if (existingThing) {
        // remove
        return value.filter(t => t !== id);
      } else {
        // add
        return [id, ...value];
      }
    });
  };

  return {
    length,
    subscribe: things.subscribe,
    isBookmarked,
    addRemove
  };
}

export const bookmarks = createBookmarks();