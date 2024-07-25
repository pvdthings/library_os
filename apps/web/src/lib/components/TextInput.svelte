<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import XMarkIcon from '$lib/icons/x-mark.svg';
	import { vibrate } from '$lib/utils/haptics';

	export let clear: boolean = false;
	export let value: string = '';
	export let invalid: boolean = false;
	export let leadingIcon: string = undefined;

	const dispatch = createEventDispatcher();

	const keyReleased = (event: { key: string }) => {
		if (event.key === 'Enter') dispatch('enter');
	};

	const onClear = () => {
		vibrate();
		dispatch('clear');
	};
</script>

<div
	class="bg-white flex flex-row items-center px-2 rounded-md border border-neutral-400 shadow-high overflow-hidden"
>
	{#if leadingIcon}
		<img src={leadingIcon} alt="" class="w-6 h-6 mr-2" />
	{/if}
	<input
		{...$$props}
		bind:value
		on:input
		on:change
		on:keyup={keyReleased}
		class:invalid
		class="flex-grow py-2 outline-none"
	/>
	<button class="btn btn-circle btn-sm btn-ghost" class:invisible={!clear} disabled={!clear} on:click={onClear}>
        <img src={XMarkIcon} alt="Clear" class="w-5 h-5" />
    </button>
</div>

<style lang="postcss">
	.invalid {
		@apply bg-red-200;
	}

    button.invisible {
        visibility: hidden;
    }
</style>
