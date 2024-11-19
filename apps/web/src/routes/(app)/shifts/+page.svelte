<script>
	import ShiftsView from "$lib/shifts/ShiftsView.svelte";

	let { data } = $props();
	const { shifts } = data;
</script>

<ShiftsView {shifts} />