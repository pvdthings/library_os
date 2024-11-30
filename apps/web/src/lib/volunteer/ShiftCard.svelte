<script>
	import { getContext } from 'svelte';

	let {
		id,
		date,
		description,
		enrolled,
		removed,
		selected,
		time,
		title,
		unsavedChanges,
		volunteers,
		onAdd,
		onRemove
	} = $props();
</script>

<div class="card bg-white border border-base-300 p-4 lg:p-8 shadow-sm">
	<div class="flex mb-4 lg:mb-6">
		<div class="flex-grow">
			<div class="font-display font-semibold lg:text-lg">{date}</div>
			<div class="mb-2 text-sm lg:text-base">{time}</div>
			<div class="font-display text-xl lg:text-2xl">{title}</div>
			{#if description?.length}
				<div class="mt-1 text-sm max-w-prose">{description}</div>
			{/if}
		</div>
		<div>
			<div class="flex justify-end">
				{#if (selected || enrolled) && !removed}
					<button
						onclick={() => onRemove(id)}
						class="font-display btn btn-sm lg:btn-md btn-success border border-success shadow-sm"
						class:btn-disabled={!onRemove}
					>
						<span class="ph-bold ph-check text-xl"></span>
						<span>Added</span>
					</button>
				{:else}
					<button
						onclick={() => onAdd(id)}
						class="font-display btn btn-sm lg:btn-md btn-secondary border border-base-300 shadow-sm"
						class:btn-disabled={!onAdd}
					>
						<span class="ph-bold ph-user-plus text-xl"></span>
						<span>Add me</span>
					</button>
				{/if}
			</div>

			{#if unsavedChanges}
				<div class="mt-2 text-end text-sm text-neutral-400">*not saved</div>
			{/if}
		</div>
	</div>

	<div>
		<div class="mb-1 font-display font-semibold text-sm lg:text-base">Volunteers</div>
		<div class="flex flex-wrap items-center gap-2">
			{#if !volunteers.some((v) => v.keyholder) && !enrolled}
				<div class="flex items-center gap-1">
					<span class="ph-bold ph-warning text-warning lg:text-lg"></span>
					<span class="text-sm lg:text-lg">No Keyholder</span>
				</div>
			{/if}

			{#if enrolled}
				<div class="badge badge-success flex items-center gap-1 lg:p-4 lg:text-lg select-none">
					{#if getContext('user')?.keyholder}
						<span class="ph-fill ph-key text-base-content"></span>
					{/if}
					Me
				</div>
			{/if}

			{#each volunteers as volunteer}
				<div class="badge flex items-center gap-1 lg:p-4 lg:text-lg select-none">
					{#if volunteer.keyholder}
						<span class="ph-fill ph-key text-amber-500"></span>
					{/if}
					{volunteer.firstName}
				</div>
			{/each}
		</div>
	</div>
</div>
