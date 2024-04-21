<script lang="ts">
	import "./Chooser.css";
	import { createEventDispatcher } from 'svelte';
	import { t, locale } from '$lib/language/translate';
	import ChevronIcon from "$lib/icons/chevron.svg";
	import ChooserBody from './ChooserBody.svelte';

	export let options = [];

	let chosenOption = options[0];
	let dropdownHidden = true;
	let innerWidth: number;

	$: isEnglish = $locale === 'en';

	const dispatch = createEventDispatcher();

	const toggleDropdown = () => {
		dropdownHidden = !dropdownHidden;

		if (innerWidth < 768) {
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

<div class="relative h-11" on:click|stopPropagation={() => {}} on:keypress={() => {}}>
	<button
		on:click={toggleDropdown}
		class="chooser-button bg-white hover:bg-indigo-50 rounded-md border border-gray-500 shadow-high h-full w-48"
	>
		<img
			class="inline mr-1"
			src={ChevronIcon}
			alt="Dropdown"
		/>
		<span>{isEnglish ? chosenOption : $t(chosenOption)}</span>
	</button>
	<ChooserBody
		hidden={dropdownHidden}
		title={$t('Category')}
		{chosenOption}
		{options}
		onOptionClick={optionChosen}
		onClose={toggleDropdown}
	/>
</div>