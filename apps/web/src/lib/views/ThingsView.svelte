<script>
	import { filteredThings } from '$lib/stores/catalog';
	import Things from '$lib/components/Things/Things.svelte';
</script>

<Things things={$filteredThings} />
