<script>
	import CategoryBadge from "./CategoryBadge.svelte";
  import BoxIcon from '$lib/icons/box.svg';

  export let name = 'Unnamed Thing';
  export let imageUrl = undefined;
  export let availableStock = 0;
  export let totalStock = 0;
  export let categories = [];
</script>

<div class="p-4 flex flex-col min-w-80">
  <section class="flex flex-row gap-4">
    <div class="avatar">
      <div class="bg-neutral-400 border border-neutral-400 w-32 rounded">
        <img src={imageUrl ?? BoxIcon} alt={name} />
      </div>
    </div>
    <div class="flex flex-col gap-1">
      <div class="font-display font-semibold text-xl">{name}</div>
      <div class="badge badge-success badge-lg">{availableStock} / {totalStock}</div>
    </div>
  </section>
  <div class="divider" />
  <section>
    <div class="section-title">Categories</div>
    <div class="flex flex-wrap gap-2">
      {#if categories.length}
        {#each categories as category}
          <CategoryBadge text={category} />
        {/each}
      {:else}
        <div>None</div>
      {/if}
    </div>
  </section>
  <div class="divider" />
  <section>
    <div class="section-title">Inventory</div>
    <div>Item 1</div>
    <div>Item 2</div>
  </section>
</div>

<style>
  .section-title {
    @apply font-display font-semibold text-lg mb-1;
  }
</style>