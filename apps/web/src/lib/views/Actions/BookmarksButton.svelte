<script>
	import { Modal } from "$lib/components/Modal";
	import { Bookmarks } from "../Bookmarks";
  import BookmarkIcon from '$lib/icons/bookmark.svg';

  let showModal = false;

  const open = () => showModal = true;
  const close = () => showModal = false;
</script>

<button
  on:click={showModal ? undefined : open}
	class="btn btn-ghost btn-circle"
	aria-label="Bookmarks"
>
	<img src={BookmarkIcon} alt="Bookmarks" class="h-6 w-6" />
</button>

{#if showModal}
  <Modal title="Bookmarks" show={showModal} on:close={close}>
    <Bookmarks />
  </Modal>
{/if}