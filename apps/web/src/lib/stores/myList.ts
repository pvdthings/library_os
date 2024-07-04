import { browser } from "$app/environment";
import type { Thing } from "$lib/models/Thing";
import { derived, writable } from "svelte/store";

const defaultValue = [];

function createBookmarks() {
  const initialValue = browser ? JSON.parse(window.localStorage.getItem('myList'))
  ?? defaultValue : defaultValue;

  const things = writable<Thing[]>(initialValue);

  things.subscribe((value) => {
    if (browser) {
      window.localStorage.setItem('myList', JSON.stringify(value));
    }
  });

  const length = derived([things], ([$things]) => $things.length);

  const addRemove = (thing: Thing) => {
    things.update((value) => {
      const existingThing = value.find(t => t.id === thing.id);
      if (existingThing) {
        // remove
        return value.filter(t => t.id !== thing.id);
      } else {
        // add
        return [thing, ...value];
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