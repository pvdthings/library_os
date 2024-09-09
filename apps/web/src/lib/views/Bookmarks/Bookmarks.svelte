<script lang="ts">
	import BookmarksRow from './BookmarksRow.svelte';
	import { locale, t } from '$lib/language/translate';
	import { bookmarks } from '$lib/stores/bookmarks';
	import { findThingById } from '$lib/stores/catalog';

	$: isSpanish = $locale === 'es';
</script>

{#if $bookmarks.length}
	<table class="table">
		<tbody>
			{#each $bookmarks as thingId}
				{@const thing = findThingById(thingId)}
				{@const thingName = isSpanish ? thing.spanishName ?? thing.name : thing.name}
				<BookmarksRow
					on:remove={() => bookmarks.addRemove(thing.id)}
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
