<script lang="ts">
	import AbsoluteCenter from '$lib/components/AbsoluteCenter.svelte';
	import { things } from '$lib/stores/things';
	import LoadingSpinner from '$lib/components/LoadingSpinner.svelte';
	import Details from './Details.svelte';
	import { locale } from '$lib/language/translate';

	export let id: string;

	$: details = things.details(id);
	$: loading = $details.loading;
	$: thing = $details.value;
	$: thingName = $locale === 'en' ? thing?.name : thing?.spanishName ?? thing?.name;
</script>

{#if loading}
	<AbsoluteCenter>
		<LoadingSpinner />
	</AbsoluteCenter>
{:else}
	<Details
		id={thing.id}
		name={thingName}
		image={thing.image}
		categories={thing.categories}
		stock={thing.stock}
		available={thing.available}
		availableDate={thing.availableDate}
		items={thing.items}
	/>
{/if}
