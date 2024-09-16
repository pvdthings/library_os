<script lang="ts">
  export let number: number;
  export let brand: string|undefined;
  export let hidden: boolean;
  export let status: 'available'|'checkedOut';

  const getBadgeVariant = () => {
    if (hidden) {
      return 'badge-error';
    }

    switch (status) {
      case 'available':
        return 'badge-success';
      default:
        return 'badge-warning';
    }
  };
</script>

<div class="card bg-white border border-base-300 flex flex-row gap-2 relative shadow-sm">
  <span class="absolute -top-1 -left-1 badge badge-sm {getBadgeVariant()} shadow" />
  <div class="p-2 border-r border-base-300 font-display font-semibold">#{number}</div>
  {#if brand}
    <div class="p-2">{brand}</div>
  {:else}
    <div class="p-2 text-base-300">No Brand</div>
  {/if}
</div>