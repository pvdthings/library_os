<script>
	import { TextInput } from '$lib/components';
	import { t } from '$lib/language/translate';
	import { searchFilter } from '$lib/stores/catalog';
	import XMarkIcon from '$lib/icons/x-mark.svg';
	import SearchIcon from '$lib/icons/magnifying-glass.svg';

	const clearSearch = () => {
		$searchFilter = '';
	};
</script>

<div class="relative">
	<img src={SearchIcon} alt="searchIcon" class="w-6 h-6 absolute top-2.5 left-2 transform" />
	<TextInput bind:value={$searchFilter} placeholder={$t('Input.Search')} />
	{#if $searchFilter.length > 0}
		<button class="btn btn-circle btn-sm btn-ghost absolute right-2 top-1.5" on:click={clearSearch}>
			<img src={XMarkIcon} alt="searchIcon" class="w-5 h-5 absolute top-1.75 left-2.25 transform" />
		</button>
	{/if}
</div>
