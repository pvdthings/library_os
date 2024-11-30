<script lang="ts">
	export let active: boolean = undefined;
	export let icon: string = undefined;
	export let iconStyle: string = undefined;
	export let indicatorValue: any = undefined;
	export let label: string;
</script>

<button class="bg-transparent" class:active on:click>
	<div class="indicator">
		{#if indicatorValue}
			<span class="indicator-item badge bg-indigo-500 border-indigo-600 text-white">
				{indicatorValue}
			</span>
		{/if}
		{#if icon}
			<img src={icon} alt={label} class="w-5 h-5" />
		{/if}
		{#if iconStyle}
			<span class={iconStyle} />
		{/if}
	</div>
	<div class="text-xs font-display font-semibold">
		{label}
	</div>
</button>
