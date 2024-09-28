import { getContext } from "svelte";

export function getAppContext() {
  return getContext('App');
}