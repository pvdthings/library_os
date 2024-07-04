<script lang="ts">
	import BoxIcon from '$lib/icons/box.svg';
	import ThingCardBookmark from './ThingCardBookmark.svelte';
	import ThingCardStock from './ThingCardStock.svelte';

	export let image: string | undefined;
	export let name: string;
	export let totalStock: number;
	export let remainingStock: number;
	export let bookmarked: boolean;
	export let onTap: () => void;
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
	class="h-max relative flex flex-col bg-white border border-neutral-400 rounded-md shadow-low overflow-hidden cursor-pointer"
	on:click={onTap}
	role="button"
	tabindex="-1"
>
	<ThingCardStock remaining={remainingStock} total={totalStock} />
	{#if bookmarked}
		<ThingCardBookmark />
	{/if}
	<img src={image ?? BoxIcon} alt={name} class="p-2 w-full aspect-square object-contain" />
	{#if bookmarked}
		<div class="bg-indigo-200 text-indigo-900 name">
			{name}
		</div>
	{:else}
		<div class="name">
			{name}
		</div>
	{/if}
</div>

<style>
	.name {
		@apply px-2 py-1;
		@apply text-center text-ellipsis font-display font-medium;
		@apply border-t border-neutral-400;
	}
</style>
