<script>
	import BorrowModal from '$lib/components/BorrowModal/BorrowModal.svelte';
	import { t } from '$lib/language/translate';
	import { filteredThings } from '$lib/stores/catalog';
	import CategoryChooserView from './CategoryChooserView.svelte';
	import SearchInputView from './SearchInputView.svelte';
	import ThingsView from './ThingsView.svelte';
	import WishListButtonView from './WishListButtonView.svelte';
</script>

<div class="flex flex-col-reverse gap-3 md:h-11 md:w-full md:flex-row md:justify-between">
	<div class="flex flex-row gap-4 justify-between md:justify-start">
		<CategoryChooserView />
		<WishListButtonView />
	</div>
	<SearchInputView />
</div>
<hr class="border-black border-opacity-20 my-6" />
<BorrowModal />
{#if $filteredThings.length > 0}
	<ThingsView />
{:else}
	<div class="text-lg text-center font-bold uppercase">{$t('No Results')}</div>
{/if}
