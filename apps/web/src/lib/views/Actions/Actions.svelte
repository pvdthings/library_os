<script lang="ts">
	import BookmarksButton from "./BookmarksButton.svelte";
  import LanguageToggleButton from "./LanguageToggleButton.svelte";

  let innerWidth: number;

  $: isMobile = innerWidth < 1024;
</script>

<svelte:window bind:innerWidth />

<div class="flex flex-row gap-1">
  <LanguageToggleButton />

  {#if !isMobile}
    <BookmarksButton />
  {/if}
</div>