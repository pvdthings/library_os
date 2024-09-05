import { browser } from "$app/environment";
import type { ThingID } from "$lib/models/Thing";
import { derived, writable } from "svelte/store";

const defaultValue = [];

function createBookmarks() {
  const initialValue = browser ? JSON.parse(window.localStorage.getItem('myList'))
  ?? defaultValue : defaultValue;

  const things = writable<ThingID[]>(initialValue);

  things.subscribe((value) => {
    if (browser) {
      window.localStorage.setItem('myList', JSON.stringify(value));
    }
  });

  const length = derived([things], ([$things]) => $things.length);

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
    addRemove
  };
}

export const bookmarks = createBookmarks();