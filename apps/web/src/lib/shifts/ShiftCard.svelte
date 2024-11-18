<script>
  let { id, date, time, title, selected, volunteers, onAdd, onRemove } = $props();
</script>

<div class="card bg-white border border-base-300 p-4 lg:p-8 shadow-sm">
	<div class="flex mb-4 lg:mb-6">
		<div class="flex-grow">
			<div class="font-display font-semibold">{date}</div>
      <div class="mb-2 text-sm">{time}</div>
			<div class="font-display text-xl lg:text-2xl">{title}</div>
		</div>
		<div class="flex justify-end">
      {#if selected}
        <button onclick={() => onRemove(id)} class="font-display btn btn-sm lg:btn-md btn-success border border-success shadow-sm">
          <span class="ph-bold ph-check text-xl"></span>
          <span>Added</span>
        </button>
      {:else}
        <button onclick={() => onAdd(id)} class="font-display btn btn-sm lg:btn-md btn-secondary border border-base-300 shadow-sm">
          <span class="ph-bold ph-user-plus text-xl"></span>
          <span>Add me</span>
        </button>
      {/if}
		</div>
	</div>

	<div>
		<div class="mb-1 font-display font-semibold text-sm lg:text-base">Volunteers</div>
		<div class="flex flex-wrap gap-2">
      {#each volunteers as volunteer}
			  <div class="badge badge-ghost lg:p-4 lg:text-lg">{volunteer}</div>
      {/each}
		</div>
	</div>
</div>
