<script>
	import { filteredThings } from '$lib/stores/catalog';
	import Things from '$lib/components/Things';
</script>

<Things things={$filteredThings} />
