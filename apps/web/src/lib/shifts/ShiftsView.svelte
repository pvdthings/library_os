<script>
	import { pluralize, toBe } from '$lib/utils/pluralize';
	import ShiftCard from '$lib/shifts/ShiftCard.svelte';
	import { setContext } from 'svelte';

	let { email, shifts, loggedIn, keyholder, unauthorized } = $props();
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
	<div class="flex items-center justify-between mb-4">
		{#if !loggedIn}
		<form class="flex flex-grow gap-2" method="POST" action="?/authenticate">
			<label class="input input-bordered flex flex-grow items-center gap-2 shadow">
				<span class="ph ph-envelope text-xl"></span>
				<input class="grow" type="text" name="email" placeholder="Enter your email">
			</label>
			<button class="btn btn-accent lg:self-center shadow font-display" type="submit">
				Sign in
			</button>
		</form>
		{:else}
			<div class="font-display mr-4 text-xl text-center">
				<span class="py-1 px-2 bg-black rounded shadow-sm text-white">{pluralize(totalAssigned(), 'shift')}</span>
				<span class="hidden lg:inline">{toBe(totalAssigned())} assigned to you.</span>
			</div>
			<form class="flex justify-center" method="POST" action="?/confirm">
				{#each modifiedShifts as shift}
					<input name="shifts" value={JSON.stringify(shift)} hidden />
				{/each}
				<button class="btn btn-primary font-display shadow" class:btn-disabled={!modifiedShifts.length} type="submit">Save Changes</button>
			</form>
		{/if}
	</div>

	{#if unauthorized}
		<div class="alert alert-error">
			<span>
				<span class="font-semibold">{email}</span> could not be matched to any existing member.
				Please come in during the shift you want to join and we'll get you set up.
			</span>
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
			onAdd={loggedIn ? (id) => modify(id) : undefined}
			onRemove={loggedIn ? (id) => modify(id, true) : undefined}
		/>
	{/each}
</div>

{#if loggedIn}
	<form class="flex justify-center my-12" method="POST" action="?/unauthenticate">
		<button class="btn lg:btn-lg btn-accent shadow font-display" type="submit">
			Sign out
			<span class="ph-bold ph-sign-out text-xl lg:text-2xl"></span>
		</button>
	</form>
{/if}