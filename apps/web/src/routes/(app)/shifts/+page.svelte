<script>
	import ShiftsView from '$lib/shifts/ShiftsView.svelte';

	let { data, form } = $props();

	const { shifts, authenticated, keyholder } = data;
	const { email, unauthorized } = form ?? {};
</script>

<ShiftsView
	{shifts}
	{keyholder}
	loggedIn={authenticated}
	{email}
	{unauthorized}
/>
