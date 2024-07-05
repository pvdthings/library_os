<script lang="ts">
	import type { Thing } from '$lib/models/Thing';
	import ThingCardView from './ThingCardView.svelte';

	export let things: Thing[];
</script>

{#key things}
	<div class="grid grid-cols-2 md:grid-cols-6 gap-4 place-content-between">
		{#each things as thing}
			<ThingCardView {thing} />
		{/each}
	</div>
{/key}
