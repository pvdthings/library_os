<script>
    import Scroller from "./Scroller.svelte";
    import { filterByCategory } from "$lib/utils/filters";

    export let things;
    export let categories;
    export let shownCategory;
</script>

<div>
  {#key things}
    {#if shownCategory}
      <Scroller things={filterByCategory(things, shownCategory)} wrap={true} />
    {:else}
      {#each categories as category}
        {@const filteredThings = filterByCategory(things, category)}
        {#if filteredThings.length > 0}
          <div>
            <div class="pl-4 text-4xl lg:text-5xl font-display font-bold text-black">
              {category}
            </div>
            <Scroller things={filteredThings} />
          </div>
        {/if}
      {/each}
    {/if}
  {/key}
</div>
