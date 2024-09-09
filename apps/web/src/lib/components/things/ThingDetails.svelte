<script lang="ts">
	import type { Thing } from "$lib/models/Thing";
  import { t, locale } from '$lib/language/translate';
  import Button from '../Button/Button.svelte';
	import { ButtonTheme } from '../Button';
  import { bookmarks } from "$lib/stores/bookmarks";
	import { createEventDispatcher } from "svelte";
	import { openDonationForm } from "$lib/utils/donations";

  export let thing: Thing;
  export let bookmarked: boolean;

  const dispatch = createEventDispatcher();

  const stockContainerStyle = (available: number) => {
    if (available === 0) {
      return 'bg-red-200 text-red-900';
    }

    return 'bg-green-200 text-green-900';
  };

  const addRemoveBookmark = () => {
    bookmarks.addRemove(thing.id);
    dispatch('click');
  };
</script>

<div class="rounded-md overflow-hidden text-lg border border-neutral-400 flex flex-row items-stretch">
  <div class="px-2 py-1 flex flex-row items-center flex-grow-0 border-r border-neutral-400 {stockContainerStyle(thing.available)}">
    {thing.available} / {thing.stock}
  </div>
  <div class="px-2 py-1 flex-grow flex flex-row justify-between items-center">
    {#if thing.availableDate}
      <div class="font-display text-neutral-500">{$t('Due Back')}</div>
      <div class="text-right text-xl">{new Date(thing.availableDate).toLocaleDateString($locale)}</div>
    {:else if thing.stock === 0}
      <div class="font-display text-neutral-500">{$t('Wanted')}</div>
    {:else if thing.available === 0}
      <div class="font-display text-neutral-500">{$t('Unavailable')}</div>
    {:else}
      <div class="font-display text-neutral-500">{$t('Available')}</div>
    {/if}
  </div>
</div>

{#if thing.availableDate}
  <p class="p-1 my-3 text-sm">
    {$t('Due Back Disclaimer')}
  </p>
{/if}

<div class="mt-8 grid grid-cols-1 sm:flex sm:flex-row justify-end gap-3">
  {#if thing.stock === 0}
    <Button on:click={() => openDonationForm(thing.name)}>
      <span class="text-xl">{$t('Donate')}</span>
    </Button>
  {/if}

  <Button theme={ButtonTheme.primary} on:click={addRemoveBookmark}>
    <span class="text-xl">
        {bookmarked ? $t('Unbookmark') : $t('Bookmark')}
    </span>
  </Button>
</div>