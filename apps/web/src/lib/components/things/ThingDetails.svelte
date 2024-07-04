<script lang="ts">
	import type { Thing } from "$lib/models/Thing";
  import { t } from '$lib/language/translate';
  import Button from '../Button/Button.svelte';
	import { ButtonTheme } from '../Button';
  import { bookmarks } from "$lib/stores/myList";

  export let thing: Thing;

  const stockContainerStyle = (available: number) => {
    if (available === 0) {
      return 'bg-red-200 text-red-900';
    }

    return 'bg-green-200 text-green-900';
  };

  const addRemoveBookmark = () => {
    bookmarks.addRemove(thing);
  };
</script>

<h2 class="font-bold font-display text-2xl mb-3">{thing.name}</h2>

<div class="rounded-md overflow-hidden text-xl border border-neutral-400 flex flex-row items-center">
  <div class="px-2 py-1 border-r border-neutral-400 {stockContainerStyle(thing.available)}">
    {thing.available} / {thing.stock}
  </div>
  <div class="px-2 py-1 text-right flex-grow">
    {#if thing.availableDate}
      <span class="float-left font-display text-neutral-500">{$t('Due Back')}</span>
      <span class="float-right">{thing.availableDate}</span>
    {:else}
      <span class="float-left font-display text-neutral-500">{$t('Available')}</span>
    {/if}
  </div>
</div>

{#if thing.availableDate}
  <p class="p-1 my-3 text-sm">
    {$t('Due Back Disclaimer')}
  </p>
{/if}

<div class="mt-8 float-right">
  <Button theme={ButtonTheme.primary} on:click={addRemoveBookmark}>
    <span class="text-xl">{$t('Bookmark')}</span>
  </Button>
</div>