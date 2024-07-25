<script>
	import { TextInput } from '$lib/components';
	import { t } from '$lib/language/translate';
	import { searchFilter } from '$lib/stores/catalog';
	import SearchIcon from '$lib/icons/magnifying-glass.svg';

	const clearSearch = () => {
		$searchFilter = '';
	};
</script>

<TextInput
	leadingIcon={SearchIcon}
	bind:value={$searchFilter}
	placeholder={$t('Input.Search')}
	clear={$searchFilter.length > 0}
	on:clear={clearSearch}
/>
