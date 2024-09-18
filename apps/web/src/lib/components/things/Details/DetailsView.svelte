<script lang="ts">
	import AbsoluteCenter from '$lib/components/AbsoluteCenter.svelte';
	import { things } from '$lib/stores/things';
	import LoadingSpinner from '$lib/components/LoadingSpinner.svelte';
	import Details from './Details.svelte';

	export let id: string;

	$: details = things.details(id);
	$: loading = $details.loading;
	$: thing = $details.value;
</script>

{#if loading}
	<AbsoluteCenter>
		<LoadingSpinner />
	</AbsoluteCenter>
{:else}
	<Details
		id={thing.id}
		name={thing.name}
		image={thing.image}
		categories={thing.categories}
		stock={thing.stock}
		available={thing.available}
		availableDate={thing.availableDate}
		items={thing.items}
	/>
{/if}
