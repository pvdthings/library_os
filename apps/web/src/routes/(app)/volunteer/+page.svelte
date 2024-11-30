<script>
	import ShiftsView from '$lib/volunteer/ShiftsView.svelte';

	let { data, form } = $props();

	const { shifts, authenticated, firstName, keyholder } = data;
	const { email, unauthorized } = form ?? {};
</script>

<div class="pb-20 lg:pb-0">
	<ShiftsView {shifts} {keyholder} loggedIn={authenticated} {email} {firstName} {unauthorized} />
</div>
