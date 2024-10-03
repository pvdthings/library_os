import type { ThingDetailsModel } from "$lib/models/ThingDetails";
import { derived, get, readable, writable, type Readable } from "svelte/store";
import type { Async } from "./types";

function createThingsRepository() {
  const things = writable(new Map());
  const subscribe = things.subscribe;
  const unsubscribe = things.subscribe(_ => {});

  const details = (id: string): Readable<Async<ThingDetailsModel>> => {
    const thingsValue = get(things);

    if (thingsValue.has(id)) {
      return readable({
        loading: false,
        value: thingsValue[id]
      });
    }

    const result = writable({
      loading: true,
      value: undefined
    });

    fetch(`/api/things/${id}`).then((r) => r.json()).then((model) => {
      result.update((r) => ({
        loading: false,
        value: model
      }));
    });

    return derived(result, (r) => r);
  };

  return {
    subscribe,
    unsubscribe,
    details
  };
}

export const things = createThingsRepository();