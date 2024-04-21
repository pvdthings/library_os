<script lang="ts">
	import MyListTableRow from './MyListTableRow.svelte';
  import { locale, t } from '$lib/language/translate';
  import { things } from '$lib/stores/myList';

  $: isSpanish = $locale === 'es';

  const removeThing = (id: String) => {
    things.update(value => value.filter(t => t.id !== id));
  };
</script>

{#if $things.length > 0}
  <table class="table">
    <tbody>
      {#each $things as thing}
        {@const thingName = isSpanish ? thing.spanishName ?? thing.name : thing.name}
        <MyListTableRow
          on:remove={() => removeThing(thing.id)}
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