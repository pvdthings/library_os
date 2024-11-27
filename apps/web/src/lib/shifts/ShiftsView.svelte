<script>
	import { pluralize, toBe } from '$lib/utils/pluralize';
	import ShiftCard from '$lib/shifts/ShiftCard.svelte';
	import { setContext } from 'svelte';

	let { email, firstName, shifts, loggedIn, keyholder, unauthorized } = $props();
	let modifiedShifts = $state([]);
	let localEmail = $state(undefined);

	setContext('user', { keyholder });

	const cancel = (event) => {
		event.preventDefault();
		modifiedShifts = [];
	};

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
	<div class="flex items-start justify-between mb-4">
		{#if !loggedIn}
			<form class="flex flex-grow gap-2" method="POST" action="?/authenticate">
				<label class="input input-bordered flex flex-grow items-center gap-3 shadow">
					<span class="ph ph-envelope text-xl"></span>
					<input bind:value={localEmail} class="grow" type="email" name="email" placeholder="Enter your email to sign in">
				</label>
				<button class="btn btn-accent lg:self-center shadow font-display" type="submit" class:btn-disabled={!localEmail}>
					Sign in
				</button>
			</form>
		{:else}
			<div>
				{#if firstName}
					<div class="font-display text-4xl lg:text-5xl mb-4 lg:mb-6">
						Hi, {firstName}.
					</div>
				{/if}
				<div class="font-display mr-4 text-xl">
					<span class="py-1 px-2 bg-black rounded shadow-sm text-white">{pluralize(totalAssigned(), 'shift')}</span>
					<span class="hidden lg:inline">{toBe(totalAssigned())} assigned to you.</span>
				</div>
			</div>
			<form class="flex justify-center" method="POST" action="?/confirm">
				{#each modifiedShifts as shift}
					<input name="shifts" value={JSON.stringify(shift)} hidden />
				{/each}
				<button class="btn btn-secondary border border-base-300 font-display mr-2 shadow" class:hidden={!modifiedShifts.length} onclick={cancel}>Cancel</button>
				<button class="btn btn-primary gap-0 font-display shadow" class:btn-disabled={!modifiedShifts.length} type="submit"><span>Save</span> <span class="hidden sm:inline">&nbsp;Changes</span></button>
			</form>
		{/if}
	</div>

	{#if unauthorized}
		<div class="alert alert-error">
			<span>
				<span class="font-semibold">{email}</span> could not be matched to any existing member.
				Please show up for the shift you wanted to join and we'll get you set up.
			</span>
		</div>
	{/if}

	{#each shifts as shift}
		<ShiftCard
			id={shift.id}
			selected={isSelected(shift.id)}
			date={shift.date}
			description={shift.description}
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