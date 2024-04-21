<script>
	import BoxIcon from '$lib/icons/box.svg';
	import BookmarkIcon from './BookmarkIcon.svelte';
	import { t, locale } from '$lib/language/translate';
	import { things } from '$lib/stores/myList';
	import { showBorrowModal } from '../BorrowModal/stores';

	export let thing;

	let innerWidth = 0;
	let language;

	$: isMobile = innerWidth < 1024;
	$: fontSize = thing.name.length > 13 || isMobile ? 'text-sm' : 'text-base';
	$: isInList = $things.find(t => t.id === thing.id) !== undefined;

	const donateURL = `https://airtable.com/shrwMSrzvSLpQgQWC?prefill_Description=${encodeURIComponent(
		thing.name
	)}`;
	const hasZeroStock = thing.stock < 1;
	const noneAvailable = !hasZeroStock && (!thing.available || thing.available < 1);

	const getBackgroundColor = () => {
		if (isInList)
			return 'bg-indigo-300';
		if (hasZeroStock)
			return 'bg-yellow-300';
		if (noneAvailable)
			return 'bg-red-300';

		return 'bg-green-300';
	};

	const getShortName = (name) => {
		if (name.length < 30) return name;
		return name.substring(0, 29) + '...';
	};

	const onClick = () => {
		if (!hasZeroStock) {
			if (isMobile) {
				updateList();
			} else {
				showBorrowModal.set(true);
			}
		} else {
			window.open(donateURL, '_blank').focus();
		}
	};

	const updateList = () => {
		const existingThing = $things.find(t => t.id === thing.id);
		if (existingThing) {
			// remove
			things.update(value => value.filter(t => t.id !== thing.id));
		} else {
			// add
			things.update(value => [thing, ...value]);
		}
	};

	locale.subscribe((value) => {
		language = value;
	});
</script>

<svelte:window bind:innerWidth />

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
	class="relative flex flex-col justify-between bg-white border border-gray-500 rounded-md {isInList ? 'shadow-lowest' : 'shadow-low'} overflow-hidden cursor-pointer"
	on:click={onClick}
>
	{#if isInList}
		<div class="absolute -top-2 right-1">
			<BookmarkIcon class="h-8 w-8 fill-indigo-500" />
		</div>
	{/if}
	<div class="p-2">
		<img
			src={thing.image ?? BoxIcon}
			alt={thing.name}
			class="w-full aspect-square object-contain rounded"
		/>
		<div class="mt-3">
			<div class="{fontSize} uppercase font-bold font-sans text-center">
				{getShortName(language === 'en' ? thing.name : thing.spanishName ?? thing.name)}
			</div>
		</div>
	</div>
	{#key isInList}
		<div class="{getBackgroundColor()} py-1 text-center font-medium border-t border-gray-500">
			{#if hasZeroStock}
				<span class="text-yellow-900">{$t('Donate')}</span>
			{:else if isInList}
				<span class="text-indigo-900">{$t('Bookmarked')}</span>
			{:else if noneAvailable}
				<span class="text-red-900">
					{isMobile ? `${thing.available} / ${thing.stock}` : $t('Unavailable')}
				</span>
			{:else}
				<span class="text-green-900">
					{isMobile
						? `${thing.available} / ${thing.stock}`
						: `${thing.available} / ${thing.stock} ${$t('Available')}`}
				</span>
			{/if}
		</div>
	{/key}
</div>
