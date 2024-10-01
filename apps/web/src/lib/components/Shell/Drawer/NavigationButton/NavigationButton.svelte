<script lang="ts">
	import BackButton from "./BackButton.svelte";
	import CloseButton from "./CloseButton.svelte";
  import { poppable } from "../drawer";

  let className: string = '';
  export { className as class };
</script>

{#if $poppable}
  <BackButton class={className} />
{:else}
  <CloseButton class={className} />
{/if}