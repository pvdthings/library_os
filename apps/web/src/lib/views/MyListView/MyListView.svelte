<script lang="ts">
	import MyListTableRow from './MyListTableRow.svelte';
  import { locale, t } from '$lib/language/translate';
  import { bookmarks } from '$lib/stores/myList';
	import type { Thing } from '$lib/models/Thing';

  $: isSpanish = $locale === 'es';

  const removeThing = (thing: Thing) => {
    bookmarks.addRemove(thing);
  };
</script>

{#if $bookmarks.length > 0}
  <table class="table">
    <tbody>
      {#each $bookmarks as thing}
        {@const thingName = isSpanish ? thing.spanishName ?? thing.name : thing.name}
        <MyListTableRow
          on:remove={() => removeThing(thing)}
          {thingName}
          category={thing.categories[0]}
          available={thing.available}
          imgSrc={thing.image}
        />
      {/each}
    </tbody>
  </table>
{:else}
  <div class="fixed top-1/2 left-1/2 -translate-x-1/2">{$t('No Bookmarks')}</div>
{/if}