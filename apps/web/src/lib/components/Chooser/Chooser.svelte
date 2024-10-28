<script lang="ts">
	import './Chooser.css';
	import { createEventDispatcher } from 'svelte';
	import { t, locale } from '$lib/language/translate';
	import ChooserBody from './ChooserBody.svelte';
	import { Modal } from '../Modal';

	const tabletBreakpoint = 768;

	export let options = [];

	let chosenOption = options[0];
	let dropdownHidden = true;
	let innerWidth: number;

	$: isEnglish = $locale === 'en';

	const dispatch = createEventDispatcher();

	const toggleDropdown = () => {
		dropdownHidden = !dropdownHidden;

		if (innerWidth < tabletBreakpoint) {
			document.body.classList.toggle('overflow-hidden');
		} else {
			document.body.classList.remove('overflow-hidden');
		}
	};

	const optionChosen = (option) => {
		chosenOption = option;
		toggleDropdown();
		dispatch('chosen', option);
	};
</script>

<svelte:window bind:innerWidth on:click={() => (dropdownHidden = true)} />

<!-- svelte-ignore a11y-no-static-element-interactions -->
<div class="relative h-11" on:click|stopPropagation={() => {}} on:keypress={() => {}}>
	<button
		on:click={toggleDropdown}
		class="chooser-button bg-white hover:bg-neutral-50 rounded-md border border-neutral-400 shadow-high h-full w-48"
	>
		<span class="ml-1">{isEnglish ? chosenOption : $t(chosenOption)}</span>
		<span class="ml-2 ph-bold ph-caret-down text-xl" />
	</button>
	<ChooserBody
		hidden={innerWidth < tabletBreakpoint || dropdownHidden}
		title={$t('Category')}
		{chosenOption}
		{options}
		onOptionClick={optionChosen}
		onClose={toggleDropdown}
	/>
</div>

{#if innerWidth < tabletBreakpoint && !dropdownHidden}
	<Modal closeButton={false} show={!dropdownHidden} on:close={toggleDropdown}>
		<div class="flex flex-col items-stretch divide-y">
			{#each options as option}
				{@const isChosen = chosenOption === option}
				<button
					class="flex flex-row justify-between items-center p-2"
					on:click={() => optionChosen(option)}
				>
					<span class="font-display {isChosen ? 'font-semibold' : ''} text-xl">{$t(option)}</span>
					{#if isChosen}
						<span class="ph-bold ph-check text-2xl" />
					{/if}
				</button>
			{/each}
		</div>
	</Modal>
{/if}
