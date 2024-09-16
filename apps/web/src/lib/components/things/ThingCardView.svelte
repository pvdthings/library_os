<script lang="ts">
	import { locale } from '$lib/language/translate';
	import { bookmarks } from '$lib/stores/bookmarks';
	import type { Thing } from '$lib/models/Thing';
	import ThingCard from './ThingCard.svelte';
	import { vibrate } from '$lib/utils/haptics';
	import { getShellContext } from '../Shell/ShellContext';
	import Details from './Details';

	export let thing: Thing;

	$: bookmarked = $bookmarks.find((t) => t === thing.id) !== undefined;
	$: thingName = $locale === 'en' ? thing.name : thing.spanishName ?? thing.name;

	const { drawer } = getShellContext();

	const openThingDetails = () => {
		drawer.open(Details, { id: thing.id });
		vibrate();
	};
</script>

<ThingCard
	image={thing.image}
	name={thingName}
	bookmarked={bookmarked}
	totalStock={thing.stock}
	remainingStock={thing.available}
	on:click={openThingDetails}
/>