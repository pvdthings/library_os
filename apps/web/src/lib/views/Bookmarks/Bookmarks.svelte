<script lang="ts">
	import BookmarksRow from './BookmarksRow.svelte';
	import { locale, t } from '$lib/language/translate';
	import { bookmarks } from '$lib/stores/bookmarks';
	import type { Thing } from '$lib/models/Thing';

	$: isSpanish = $locale === 'es';

	const removeThing = (thing: Thing) => {
		bookmarks.addRemove(thing);
	};
</script>

{#if $bookmarks.length}
	<table class="table">
		<tbody>
			{#each $bookmarks as thing}
				{@const thingName = isSpanish ? thing.spanishName ?? thing.name : thing.name}
				<BookmarksRow
					on:remove={() => removeThing(thing)}
					{thingName}
					category={thing.categories[0]}
					available={thing.available}
					totalStock={thing.stock}
					imgSrc={thing.image}
				/>
			{/each}
		</tbody>
	</table>
{:else}
	<div class="min-h-12 font-bold uppercase text-lg text-center">{$t('No Bookmarks')}</div>
{/if}
