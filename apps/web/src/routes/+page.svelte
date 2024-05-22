<script>
	import { onMount } from 'svelte';
	import { LoadingIndicator } from '$lib/components';
	import { activeScreen, Screen } from '$lib/stores/app';
	import { categories, things, wishListFilter } from '$lib/stores/catalog';
	import CatalogView from '$lib/views/CatalogView.svelte';
	import MyListView from '$lib/views/MyListView';
	import InfoView from '$lib/views/InfoView';

	export let data;

	$things = data.things;
	$categories = data.categories;

	const screens = {
		[Screen.catalog]: CatalogView,
		[Screen.myList]: MyListView,
		[Screen.info]: InfoView
	};

	$: currentScreen = screens[$activeScreen];

	onMount(() => {
		const urlParams = new URLSearchParams(window.location.search);
		$wishListFilter = urlParams.get('showWishList') === 'true';
	});
</script>

<div class="mx-3 lg:mx-auto lg:w-3/4">
	{#if !data}
		<LoadingIndicator />
	{:else}
		<div id="AppView" class="relative">
			<svelte:component this={currentScreen} />
		</div>
	{/if}
</div>
