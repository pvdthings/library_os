<script lang="ts">
  export let selected: boolean = false;
	export let title: string;
  export let date: string;
  export let volunteers: string[];
</script>

<div class="card bg-white border border-base-300 p-4 lg:p-8 shadow-sm">
	<div class="grid grid-cols-2 mb-4 lg:mb-6">
		<div>
			<div class="mb-1 font-display font-semibold">{date}</div>
			<div class="font-display text-xl lg:text-2xl">{title}</div>
		</div>
		<div class="flex justify-end">
      {#if selected}
      <button class="font-display btn btn-sm lg:btn-md btn-success border border-success shadow-sm">
        <span class="ph-bold ph-check text-xl" />
        <span>Added</span>
      </button>
      {:else}
        <button class="font-display btn btn-sm lg:btn-md btn-secondary border border-base-300 shadow-sm">
          <span class="ph-bold ph-user-plus text-xl" />
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
