<script lang="ts">
	import { t } from "$lib/language/translate";

  export let number: number;
  export let brand: string|undefined;
  export let status: 'available'|'checkedOut';
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="card bg-white border border-base-300 flex flex-row gap-2 relative shadow-sm" role="button" tabindex="-1" on:click>
  {#if status === 'available'}
    <span class="absolute -top-1 -left-1 badge badge-sm badge-success border border-white shadow" />
  {/if}
  <div class="p-2 border-r border-base-300 font-display font-semibold">#{number}</div>
  {#if brand}
    <div class="p-2">{brand}</div>
  {:else}
    <div class="p-2 text-base-300">{$t('No Brand')}</div>
  {/if}
</div>