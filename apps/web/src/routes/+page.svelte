<script>
	import { onMount } from 'svelte';
	import { LoadingIndicator } from '$lib/components';
	import { categories, things, wishListFilter } from '$lib/stores/catalog';

	export let data;

	$things = data.things;
	$categories = data.categories;

	onMount(() => {
		const urlParams = new URLSearchParams(window.location.search);
		$wishListFilter = urlParams.get('showWishList') === 'true';
	});
</script>

<LoadingIndicator />
