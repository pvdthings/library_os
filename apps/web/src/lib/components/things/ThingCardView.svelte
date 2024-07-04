<script lang="ts">
	import { locale } from '$lib/language/translate';
	import { bookmarks } from '$lib/stores/bookmarks';
	import type { Thing } from '$lib/models/Thing';
	import ThingCard from './ThingCard.svelte';
	import { Modal } from '../Modal';
	import ThingDetails from './ThingDetails.svelte';

	export let thing: Thing;

  let showModal = false;
</script>

<ThingCard
	image={thing.image}
	name={$locale === 'en' ? thing.name : thing.spanishName ?? thing.name}
	bookmarked={$bookmarks.find((t) => t.id === thing.id) !== undefined}
	totalStock={thing.stock}
	remainingStock={thing.available}
	onTap={() => {
    showModal = true;
  }}
/>

{#if showModal}
  <Modal show={showModal} on:close={() => showModal = false}>
    <ThingDetails {thing} />
  </Modal>
{/if}