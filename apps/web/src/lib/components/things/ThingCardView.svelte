<script lang="ts">
	import { locale } from '$lib/language/translate';
	import { bookmarks } from '$lib/stores/bookmarks';
	import type { Thing } from '$lib/models/Thing';
	import ThingCard from './ThingCard.svelte';
	import { vibrate } from '$lib/utils/haptics';
	import { getShellContext } from '../Shell/ShellContext';

	export let thing: Thing;

	const { drawer } = getShellContext();

	const openThingDetails = () => {
		drawer.open();
		vibrate();
	};

	$: bookmarked = $bookmarks.find((t) => t === thing.id) !== undefined;
	$: thingName = $locale === 'en' ? thing.name : thing.spanishName ?? thing.name;
</script>

<ThingCard
	image={thing.image}
	name={thingName}
	bookmarked={bookmarked}
	totalStock={thing.stock}
	remainingStock={thing.available}
	on:click={openThingDetails}
/>