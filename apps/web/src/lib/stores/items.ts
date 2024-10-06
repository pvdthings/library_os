import type { ItemDetailsModel } from "$lib/models/ItemDetails";
import { derived, get, readable, writable, type Readable } from "svelte/store";
import type { Async } from "./types";

function createItemsRepository() {
  const items = writable(new Map());
  const subscribe = items.subscribe;
  const unsubscribe = items.subscribe(_ => {});

  const details = (id: string): Readable<Async<ItemDetailsModel>> => {
    const itemsValue = get(items);

    if (itemsValue.has(id)) {
      return readable({
        loading: false,
        value: itemsValue[id]
      });
    }

    const result = writable({
      loading: true,
      value: undefined
    });

    fetch(`/api/items/${id}`).then((r) => r.json()).then((model) => {
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

export const items = createItemsRepository();