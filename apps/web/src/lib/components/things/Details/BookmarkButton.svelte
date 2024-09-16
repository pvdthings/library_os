<script lang="ts">
	import type { ThingID } from "$lib/models/Thing";
	import { bookmarks } from "$lib/stores/bookmarks";

  export let id: ThingID;

  $: bookmarked = bookmarks.isBookmarked(id);
  $: iconVariant = $bookmarked ? 'ph-fill' : 'ph-bold';

  const toggle = () => {
    bookmarks.addRemove(id);
  };
</script>

<button on:click={toggle} class="fixed bottom-4 right-4 btn btn-circle btn-lg btn-primary shadow-lg z-50">
  <span class="{iconVariant} ph-bookmark-simple text-white text-4xl" />
</button>