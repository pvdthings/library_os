<script>
	import { pluralize, toBe } from '$lib/utils/pluralize';
	import ShiftCard from '$lib/shifts/ShiftCard.svelte';
	import { setContext } from 'svelte';

	let { shifts, loggedIn, keyholder } = $props();
	let modifiedShifts = $state([]);

	setContext('user', { keyholder });

	const isSelected = (id) => {
		return modifiedShifts.some((s) => s.id === id && !s.remove);
	};

	const isRemoved = (id) => {
		return modifiedShifts.some((s) => s.id == id && s.remove);
	};

	const totalAssigned = () => {
		const enrolled = shifts.filter((s) => s.enrolled).map((s) => s.id);
		const addedShifts = modifiedShifts.filter((s) => !s.remove && !enrolled.includes(s.id));
		const removedShifts = modifiedShifts.filter((s) => s.remove && enrolled.includes(s.id));
		return addedShifts.length + enrolled.length - removedShifts.length;
	};

	const modify = (id, remove = false) => {
		modifiedShifts = [...modifiedShifts.filter((s) => s.id !== id), { id, remove }];
	};
</script>

<div class="flex flex-col flex-grow items-stretch gap-4">
	<div class="flex justify-between">
		<form class="flex flex-grow gap-2 mb-4" method="POST" action={loggedIn ? "?/unauthenticate" : "?/authenticate"}>
			{#if !loggedIn}
				<label class="input input-bordered flex flex-grow items-center gap-2">
					<span class="ph ph-envelope text-xl"></span>
					<input class="grow" type="text" name="email" placeholder="Enter your email">
				</label>
			{/if}
			<button class="btn btn-accent lg:self-center shadow font-display" type="submit">
				{loggedIn ? 'Sign out' : 'Sign in'}
			</button>
		</form>
		{#if loggedIn}
			<form class="flex justify-center" method="POST" action="?/confirm">
				{#each modifiedShifts as shift}
					<input name="shifts" value={JSON.stringify(shift)} hidden />
				{/each}
				<button class="btn btn-primary font-display shadow" class:btn-disabled={!modifiedShifts.length} type="submit">Save Changes</button>
			</form>
		{/if}
	</div>
	{#if loggedIn}
		<div class="font-display py-4 text-xl text-center">
			<span class="py-1 px-2 bg-black rounded text-white font-semibold">{pluralize(totalAssigned(), 'shift')}</span>
			{toBe(totalAssigned())} assigned to me.
		</div>
	{/if}
	{#each shifts as shift}
		<ShiftCard
			id={shift.id}
			selected={isSelected(shift.id)}
			date={shift.date}
			enrolled={shift.enrolled}
			removed={isRemoved(shift.id)}
			time={shift.timespan}
			title={shift.title}
			volunteers={shift.volunteers}
			onAdd={loggedIn
				? (id) => modify(id)
				: undefined}
			onRemove={loggedIn
				? (id) => modify(id, true)
				: undefined}
		/>
	{/each}
</div>
