<script>
	import AbsoluteCenter from "$lib/components/AbsoluteCenter.svelte";
	import CategoryBadge from './CategoryBadge.svelte';
	import BoxIcon from '$lib/icons/box.svg';
	import CloseButton from '$lib/components/CloseButton.svelte';
	import { getShellContext } from '$lib/components/Shell/ShellContext';
	import InventoryItem from './InventoryItem.svelte';
	import BookmarkButton from './BookmarkButton.svelte';
	import { bookmarks } from '$lib/stores/bookmarks';
	import { locale, t } from '$lib/language/translate';
	import { things } from '$lib/stores/things';
	import LoadingSpinner from '$lib/components/LoadingSpinner.svelte';
	import Divider from "$lib/components/Divider.svelte";
	import Wrap from "$lib/components/Wrap.svelte";
	import Title from "./Title.svelte";
	import List from "./List.svelte";
	import Contents from "$lib/components/Drawer";
	import Section from "./Section.svelte";

	export let id;

	$: details = things.details(id);
	$: loading = $details.loading;
	$: thing = $details.value;

	const { drawer } = getShellContext();

	$: stockBadgeVariant = thing?.available ? 'badge-success' : 'badge-error';

	$: bookmarked = bookmarks.isBookmarked(id);
	$: isBookmarked = $bookmarked;
</script>

<Contents>
	{#if loading}
		<AbsoluteCenter>
			<LoadingSpinner />
		</AbsoluteCenter>
	{:else}
		<BookmarkButton {id} />
		<section class="flex-grow-0 flex-shrink-0 h-48 md:h-64 border-b border-base-300 overflow-hidden relative shadow-sm">
			<img
				src={thing.image ?? BoxIcon}
				alt={thing.name}
				class="object-center object-contain bg-white h-full w-full"
			/>
			<CloseButton class="absolute top-4 right-4" on:click={drawer.close} />
		</section>
		<div class="p-4 flex flex-col flex-grow overflow-y-scroll">
			<section>
				<Title>{thing.name}</Title>
				<Wrap>
					<div class="badge {stockBadgeVariant} badge-lg">{thing.available} / {thing.stock}</div>
					{#if !thing.available && thing.availableDate}
						<div class="badge badge-neutral badge-lg">{$t('Due Back')} {new Date(thing.availableDate).toLocaleDateString($locale)}</div>
					{/if}
					{#if isBookmarked}
						<div class="badge badge-primary badge-lg">{$t('Bookmarked')}</div>
					{/if}
				</Wrap>
			</section>
			<Divider />
			<Section title={$t('Categories')}>
				<Wrap>
					{#if thing.categories.length}
						{#each thing.categories as category}
							<CategoryBadge text={$t(category)} />
						{/each}
					{:else}
						<div>None</div>
					{/if}
				</Wrap>
			</Section>
			<Divider />
			<Section title={$t('Inventory')}>
				<List>
					{#each thing.items as item}
						<InventoryItem number={item.number} brand={item.brand} hidden={item.hidden} status={item.status} />
					{/each}
				</List>
			</Section>
		</div>
	{/if}
</Contents>
