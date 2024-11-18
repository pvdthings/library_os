<script>
	import { onMount } from 'svelte';
	import { LoadingIndicator } from '$lib/components';
	import { activeScreen, Screen } from '$lib/stores/app';
	import { categories, things, wishListFilter } from '$lib/stores/catalog';
	import CatalogView from '$lib/views/CatalogView.svelte';
	import { Bookmarks } from '$lib/views/Bookmarks';
	import InfoView from '$lib/views/InfoView';
	import ShiftsView from '$lib/shifts/ShiftsView.svelte';

	export let data;

	$things = data.things;
	$categories = data.categories;

	onMount(() => {
		const urlParams = new URLSearchParams(window.location.search);
		$wishListFilter = urlParams.get('showWishList') === 'true';
	});
</script>

{#if !data}
	<LoadingIndicator />
{:else}
	{#if $activeScreen === Screen.catalog}
		<CatalogView />
	{/if}

	{#if $activeScreen === Screen.myList}
		<Bookmarks />
	{/if}

	{#if $activeScreen === Screen.info}
		<InfoView />
	{/if}

	{#if $activeScreen === Screen.shifts}
		<ShiftsView />
	{/if}
{/if}
