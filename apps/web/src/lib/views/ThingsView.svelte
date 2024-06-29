<script>
	import { filteredThings } from '$lib/stores/catalog';
	import { Things } from '$lib/components/things';
</script>

<Things things={$filteredThings} />
