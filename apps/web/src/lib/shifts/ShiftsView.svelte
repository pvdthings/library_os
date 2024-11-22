<script>
	import { pluralize, toBe } from '$lib/utils/pluralize';
	import ShiftCard from '$lib/shifts/ShiftCard.svelte';

	let { shifts, loggedIn } = $props();
	let modifiedShifts = $state([]);

	const isSelected = (id) => {
		return modifiedShifts.some((s) => s.id === id && !s.remove);
	};

	const isRemoved = (id) => {
		return modifiedShifts.some((s) => s.id == id && s.remove);
	};

	const totalSelected = () => {
		// TODO: account for shifts already assigned
		return modifiedShifts.filter((s) => !s.remove).length;
	};

	const modify = (id, remove = false) => {
		modifiedShifts = [...modifiedShifts.filter((s) => s.id !== id), { id, remove }];
	};
</script>

<div class="flex flex-col flex-grow items-stretch gap-4">
	<form class="flex gap-2 mb-8" method="POST" action={loggedIn ? "?/unauthenticate" : "?/authenticate"}>
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
	{#each shifts as shift}
		<ShiftCard
			id={shift.id}
			selected={isSelected(shift.id)}
			date={shift.date}
			enrolled={shift.enrolled}
			removed={isRemoved(shift.id)}
			time={shift.timespan}
			title={shift.title}
			volunteers={shift.volunteers.map((v) => v.firstName)}
			onAdd={loggedIn
				? (id) => modify(id)
				: undefined}
			onRemove={loggedIn
				? (id) => modify(id, true)
				: undefined}
		/>
	{/each}
	<div class="font-display py-4 text-xl text-center">
		<span class="font-semibold">{pluralize(totalSelected(), 'shift')}</span>
		{toBe(totalSelected())} assigned to me.
	</div>
	<form class="flex justify-center" method="POST" action="?/confirm">
		{#each modifiedShifts as shift}
			<input name="shifts" value={JSON.stringify(shift)} hidden />
		{/each}
		<button class="btn btn-lg btn-primary font-display shadow" class:btn-disabled={!loggedIn} type="submit">Confirm</button>
	</form>
</div>
