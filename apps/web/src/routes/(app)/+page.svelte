<script>
	import { onMount } from 'svelte';
	import { categories, things, wishListFilter } from '$lib/stores/catalog';
	import CatalogView from '$lib/views/CatalogView.svelte';

	export let data;

	$things = data.things;
	$categories = data.categories;

	onMount(() => {
		const urlParams = new URLSearchParams(window.location.search);
		$wishListFilter = urlParams.get('showWishList') === 'true';
	});
</script>

<CatalogView />
