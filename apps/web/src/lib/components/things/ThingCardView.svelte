<script lang="ts">
	import { locale } from '$lib/language/translate';
	import { bookmarks } from '$lib/stores/bookmarks';
	import type { Thing } from '$lib/models/Thing';
	import ThingCard from './ThingCard.svelte';
	// import ThingDetails from './ThingDetails.svelte';
	import { vibrate } from '$lib/utils/haptics';
	import { getContext } from 'svelte';
	import type { ShellContext } from '../Shell/ShellContext';

	export let thing: Thing;

	const { drawer }: ShellContext = getContext('shell');

	$: bookmarked = $bookmarks.find((t) => t === thing.id) !== undefined;
	$: thingName = $locale === 'en' ? thing.name : thing.spanishName ?? thing.name;

  // let showModal = false;

	const openThingDetails = () => {
		console.log('Drawer:', drawer);
		drawer.open();
	};

	// const closeModal = () => {
	// 	showModal = false;
	// };
</script>

<ThingCard
	image={thing.image}
	name={thingName}
	bookmarked={bookmarked}
	totalStock={thing.stock}
	remainingStock={thing.available}
	on:click={() => {
    openThingDetails();
		vibrate();
  }}
/>

<!-- {#if showModal}
  <Modal title={thingName} show={showModal} on:close={closeModal}>
    <ThingDetails {thing} {bookmarked} on:click={closeModal} />
  </Modal>
{/if} -->