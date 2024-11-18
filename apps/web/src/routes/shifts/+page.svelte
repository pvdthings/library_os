<script>
	import ShiftCard from '$lib/shifts/ShiftCard.svelte';
	import { pluralize, toBe } from '$lib/utils/pluralize';

	const shifts = [
		{
			id: '0',
			date: 'February 24, 2024',
			title: 'Saturday Librarian Shift',
			volunteers: ['Alice', 'Bob']
		},
		{
			id: '1',
			date: 'March 2, 2024',
			title: 'Tuesday Mechanic Shift',
			volunteers: ['Bob', 'Charlie']
		},
		{
			id: '2',
			date: 'March 3, 2024',
			title: 'Wednesday Librarian Shift',
			volunteers: ['Alice']
		}
	];

  const selectedShifts = ['1'];
</script>

<div class="flex flex-col gap-4">
	{#each shifts as shift}
		<ShiftCard selected={selectedShifts.includes(shift.id)} date={shift.date} title={shift.title} volunteers={shift.volunteers} />
	{/each}
	<div class="font-display py-4 text-xl text-center">
    <span class="font-semibold">{pluralize(selectedShifts.length, 'shift')}</span> {toBe(selectedShifts.length)} assigned to me.
  </div>
	<button class="btn btn-lg btn-primary shadow">Confirm</button>
</div>

<div class="toast toast-center toast-end hidden">
	<div class="alert alert-info shadow-lg">
		<span class="ph-bold ph-warning" />
		<span class="font-display">Unsaved changes</span>
	</div>
</div>
