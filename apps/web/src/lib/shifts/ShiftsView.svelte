<script>
	import ShiftCard from '$lib/shifts/ShiftCard.svelte';
	import { pluralize, toBe } from '$lib/utils/pluralize';

	let selectedShifts = $state([]);

	const shifts = [
		{
			id: '0',
			date: 'February 24, 2024',
			time: '11:00am - 2:00pm',
			title: 'Saturday Librarian Shift',
			volunteers: ['Alice', 'Bob']
		},
		{
			id: '1',
			date: 'March 2, 2024',
			time: '4:00pm - 6:00pm',
			title: 'Tuesday Mechanic Shift',
			volunteers: ['Bob', 'Charlie']
		},
		{
			id: '2',
			date: 'March 3, 2024',
			time: '6:00pm - 8:00pm',
			title: 'Wednesday Librarian Shift',
			volunteers: ['Alice']
		}
	];
</script>

<div class="flex flex-col items-stretch gap-4">
	{#each shifts as shift}
		<ShiftCard
			id={shift.id}
			selected={selectedShifts.includes(shift.id)}
			date={shift.date}
			time={shift.time}
			title={shift.title}
			volunteers={shift.volunteers}
			onAdd={(id) => {
				selectedShifts.push(id);
			}}
			onRemove={(id) => {
				selectedShifts = selectedShifts.filter((s) => s !== id);
			}}
		/>
	{/each}
	<div class="font-display py-4 text-xl text-center">
		<span class="font-semibold">{pluralize(selectedShifts.length, 'shift')}</span>
		{toBe(selectedShifts.length)} assigned to me.
	</div>
	<button class="btn btn-lg btn-primary lg:self-center shadow">Confirm</button>
</div>

<div class="toast toast-center toast-end hidden">
	<div class="alert alert-info shadow-lg">
		<span class="ph-bold ph-warning"></span>
		<span class="font-display">Unsaved changes</span>
	</div>
</div>
