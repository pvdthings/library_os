<script>
	import ShiftCard from '$lib/shifts/ShiftCard.svelte';
	import { pluralize, toBe } from '$lib/utils/pluralize';

	let loggedIn = $state(false);
	let selectedShifts = $state([]);

	const shifts = [
		{
			id: '0',
			date: 'February 24, 2025',
			time: '11:00am - 2:00pm',
			title: 'Saturday Librarian Shift',
			volunteers: ['Alice', 'Bob']
		},
		{
			id: '1',
			date: 'March 2, 2025',
			time: '4:00pm - 6:00pm',
			title: 'Tuesday Mechanic Shift',
			volunteers: ['Bob', 'Charlie']
		},
		{
			id: '2',
			date: 'March 3, 2025',
			time: '6:00pm - 8:00pm',
			title: 'Wednesday Librarian Shift',
			volunteers: ['Alice']
		}
	];

	const onLogIn = () => {
		loggedIn = !loggedIn;
	};
</script>

<div class="flex flex-col items-stretch gap-4">
	<button class="btn btn-lg btn-accent lg:self-center shadow" onclick={onLogIn}>
		{loggedIn ? 'Sign out' : 'Sign in'}
	</button>
	{#each shifts as shift}
		<ShiftCard
			id={shift.id}
			selected={selectedShifts.includes(shift.id)}
			date={shift.date}
			time={shift.time}
			title={shift.title}
			volunteers={shift.volunteers}
			onAdd={loggedIn
				? (id) => {
						selectedShifts.push(id);
					}
				: undefined}
			onRemove={loggedIn
				? (id) => {
						selectedShifts = selectedShifts.filter((s) => s !== id);
					}
				: undefined}
		/>
	{/each}
	<div class="font-display py-4 text-xl text-center">
		<span class="font-semibold">{pluralize(selectedShifts.length, 'shift')}</span>
		{toBe(selectedShifts.length)} assigned to me.
	</div>
	<button class="btn btn-lg btn-primary lg:self-center shadow" class:btn-disabled={!loggedIn}>Confirm</button>
</div>

<div class="toast toast-center toast-end hidden">
	<div class="alert alert-info shadow-lg">
		<span class="ph-bold ph-warning"></span>
		<span class="font-display">Unsaved changes</span>
	</div>
</div>
