import { writable } from "svelte/store";

export enum Screen {
  catalog,
  myList,
  info,
  shifts
}

export const activeScreen = writable<Screen>(Screen.catalog);