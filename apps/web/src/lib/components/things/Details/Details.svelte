<script lang="ts">
	import BoxIcon from '$lib/icons/box.svg';
	import InventoryItem from './InventoryItem.svelte';
	import BookmarkButton from './BookmarkButton.svelte';
	import { bookmarks } from '$lib/stores/bookmarks';
	import { locale, t } from '$lib/language/translate';
	import Divider from '$lib/components/Divider.svelte';
	import Wrap from '$lib/components/Wrap.svelte';
	import Title from './Title.svelte';
	import List from './List.svelte';
	import Section from './Section.svelte';
	import { Badge, type BadgeType } from '$lib/components/Badge';
	import type { InventoryItemModel } from '$lib/models/ThingDetails';
	import { createEventDispatcher } from 'svelte';

	export let id: string;
	export let name: string;
	export let image: string | undefined;
	export let stock: number;
	export let available: number;
	export let availableDate: string | undefined;
	export let categories: string[];
	export let items: InventoryItemModel[];

	$: stockBadgeVariant = (available ? 'success' : 'error') as BadgeType;

	$: bookmarked = bookmarks.isBookmarked(id);
	$: isBookmarked = $bookmarked;

	const dispatch = createEventDispatcher();

	const onClickItem = (item: InventoryItemModel) => {
		dispatch('clickItem', item);
	};
</script>

<BookmarkButton {id} />
<section
	class="flex-grow-0 flex-shrink-0 h-48 md:h-64 border-b border-base-300 overflow-hidden relative shadow-sm"
>
	<img
		src={image ?? BoxIcon}
		alt={name}
		class="object-center object-contain bg-white h-full w-full"
	/>
</section>
<div class="p-4 flex flex-col flex-grow overflow-y-scroll">
	<section>
		<Title>{name}</Title>
		<Wrap>
			<Badge type={stockBadgeVariant}>{available} / {stock}</Badge>
			{#if !available && availableDate}
				<Badge>{$t('Due Back')} {new Date(availableDate).toLocaleDateString($locale)}</Badge>
			{/if}
			{#if isBookmarked}
				<Badge type="primary">{$t('Bookmarked')}</Badge>
			{/if}
		</Wrap>
	</section>
	<Divider />
	<Section title={$t('Categories')}>
		<Wrap>
			{#if categories.length}
				{#each categories as category}
					<Badge>{$t(category)}</Badge>
				{/each}
			{:else}
				<div>None</div>
			{/if}
		</Wrap>
	</Section>
	<Divider />
	<Section title={$t('Inventory')}>
		{@const availableItems = items.filter((i) => i.status === 'available' && !i.hidden)}
		{@const unavailableItems = items.filter((i) => i.status === 'checkedOut' || i.hidden)}

		{#if availableItems.length}
			<List title={$t('Available')}>
				{#each availableItems as item}
					<InventoryItem
						number={item.number}
						brand={item.brand}
						status={item.status}
						on:click={() => onClickItem(item)}
					/>
				{/each}
			</List>
		{/if}

		{#if unavailableItems.length}
			<List title={$t('Unavailable')}>
				{#each unavailableItems as item}
					<InventoryItem
						number={item.number}
						brand={item.brand}
						status={item.status}
						on:click={() => onClickItem(item)}
					/>
				{/each}
			</List>
		{/if}
	</Section>
</div>
