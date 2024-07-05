<script>
	import { Modal } from '$lib/components/Modal';
	import { Bookmarks } from '../Bookmarks';
	import BookmarkIcon from '$lib/icons/bookmark.svg';
	import { bookmarks } from '$lib/stores/bookmarks';

	let showModal = false;

	const open = () => (showModal = true);
	const close = () => (showModal = false);
</script>

<button
	on:click={showModal ? undefined : open}
	class="btn btn-ghost btn-circle"
	aria-label="Bookmarks"
>
	<div class="indicator">
		{#if $bookmarks.length}
			<span class="indicator-item badge bg-indigo-500 border-indigo-600 text-white">
				{$bookmarks.length}
			</span>
		{/if}
		<img src={BookmarkIcon} alt="Bookmarks" class="h-6 w-6" />
	</div>
</button>

{#if showModal}
	<Modal title="Bookmarks" show={showModal} on:close={close}>
		<Bookmarks />
	</Modal>
{/if}
