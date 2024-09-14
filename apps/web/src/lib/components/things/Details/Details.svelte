<script>
	import CategoryBadge from './CategoryBadge.svelte';
	import BoxIcon from '$lib/icons/box.svg';
	import CloseButton from '$lib/components/CloseButton.svelte';
	import { getShellContext } from '$lib/components/Shell/ShellContext';
	import InventoryItem from './InventoryItem.svelte';
	import BookmarkButton from './BookmarkButton.svelte';
	import { bookmarks } from '$lib/stores/bookmarks';
	import { t } from '$lib/language/translate';

  // TODO: Refactor to accept Thing ID, then load from API

	export let id;
	export let name = 'Unnamed Thing';
	export let imageUrl = undefined;
	export let availableStock = 0;
	export let totalStock = 0;
	export let categories = [];

	const { drawer } = getShellContext();

	$: bookmarked = bookmarks.isBookmarked(id);
	$: isBookmarked = $bookmarked;

	const inventory = [
		{
			number: 1146,
			brand: 'DeWalt'
		},
		{
			number: 1147,
			brand: 'Milwaukee'
		},
		{
			number: 1148,
			brand: 'Ryobi'
		}
	];
</script>

<div class="h-full w-screen md:w-80 lg:w-96 relative">
	<BookmarkButton {id} />
	<section class="h-48 md:h-64 border-b border-base-300 overflow-hidden relative shadow-sm">
		<img
			src={imageUrl ?? BoxIcon}
			alt={name}
			class="object-center object-contain bg-white h-full w-full"
		/>
		<CloseButton class="absolute top-4 right-4" on:click={drawer.close} />
	</section>
	<div class="p-4 flex flex-col overflow-y-scroll">
		<section class="flex flex-col gap-2">
			<div class="font-display font-semibold text-2xl lg:text-3xl">{name}</div>
			<div class="flex flex-wrap gap-2">
				<div class="badge badge-success badge-lg">{availableStock} / {totalStock}</div>
				{#if isBookmarked}
					<div class="badge badge-primary badge-lg">{$t('Bookmarked')}</div>
				{/if}
			</div>
		</section>
		<div class="divider" />
		<section>
			<div class="section-title">{$t('Categories')}</div>
			<div class="flex flex-wrap gap-2">
				{#if categories.length}
					{#each categories as category}
						<CategoryBadge text={$t(category)} />
					{/each}
				{:else}
					<div>None</div>
				{/if}
			</div>
		</section>
		<div class="divider" />
		<section>
			<div class="section-title">{$t('Inventory')}</div>
			<div class="flex flex-col gap-2">
				{#each inventory as item}
					<InventoryItem number={item.number} brand={item.brand} available={false} />
				{/each}
			</div>
		</section>
	</div>
</div>

<style>
	.section-title {
		@apply font-display font-semibold text-xl mb-2;
	}
</style>
