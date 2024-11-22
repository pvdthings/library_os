<script>
	import ShiftsView from '$lib/shifts/ShiftsView.svelte';

	let { data, form } = $props();
	const { shifts, authenticated } = data;
</script>

<ShiftsView
	{shifts}
	loggedIn={authenticated}
/>
