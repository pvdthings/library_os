<script>
	import Thing from './Thing.svelte';

	export let things;
</script>

{#key things}
	<div class="grid grid-cols-2 md:grid-cols-6 gap-x-4 gap-y-6 place-content-between">
		{#each things as thing}
			<Thing {thing} />
		{/each}
	</div>
{/key}