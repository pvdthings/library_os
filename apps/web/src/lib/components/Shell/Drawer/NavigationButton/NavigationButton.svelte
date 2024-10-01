<script lang="ts">
	import BackButton from "./BackButton.svelte";
	import CloseButton from "./CloseButton.svelte";
  import { state as drawer } from "../drawer";

  let className: string = '';
  export { className as class };
</script>

{#if $drawer.views.length > 1}
  <BackButton class={className} />
{:else}
  <CloseButton class={className} />
{/if}