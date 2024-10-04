<script lang="ts">
	import AbsoluteCenter from '$lib/components/AbsoluteCenter.svelte';
	import LoadingSpinner from '$lib/components/LoadingSpinner.svelte';
	import { locale } from '$lib/language/translate';
	import { items } from '$lib/stores/items';
	import ItemDetails from './ItemDetails.svelte';

	export let id: string;

	$: details = items.details(id);
	$: loading = $details.loading;
	$: item = $details.value;
	$: thingName = $locale === 'en' ? item?.name : item?.spanishName ?? item?.name;
</script>

{#if loading}
	<AbsoluteCenter>
		<LoadingSpinner />
	</AbsoluteCenter>
{:else}
	<ItemDetails
    number={item.number}
		image={item.image}
    name={thingName}
		brand={item.brand}
		available={item.available}
		availableDate={item.availableDate}
		manuals={item.manuals}
	/>
{/if}
