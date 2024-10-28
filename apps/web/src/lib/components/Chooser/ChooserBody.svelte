<script lang="ts">
  import "./Chooser.css";
	import ChooserItem from './ChooserItem.svelte';
	import { t } from "$lib/language/translate";

  export let title: string;
  export let chosenOption: string;
  export let options: string[];
  export let hidden: boolean;
  export let onOptionClick: (option: string) => void;
  export let onClose: () => void;
</script>

<div
  class:body-hidden={hidden}
  class="fixed top-0 left-0 w-full h-full overflow-hidden md:h-fit md:absolute bg-neutral-50 md:border md:border-neutral-400 md:shadow-highest md:rounded-md flex flex-col z-50 md:z-40"
>
  <div class="md:hidden">
    <div class="p-4 bg-primary text-2xl font-bold text-left sticky top-0">
      {title}
      <button class="float-right" on:click={onClose}>
        <span class="ph-bold ph-x text-2xl" />
      </button>
    </div>
    <hr class="border-neutral-500" />
  </div>
  <button
		on:click={onClose}
		class="chooser-button !hidden md:!flex bg-primary h-11 w-full border-b border-neutral-400"
	>
    <span class="ml-1">{$t(chosenOption)}</span>
    <span class="ml-2 ph-bold ph-caret-up text-xl" />
	</button>
  <div class="flex flex-col overflow-y-scroll">
    {#each options as option}
      <hr />
      <ChooserItem
        on:click={() => onOptionClick(option)}
        selected={chosenOption == option}
      >
        {$t(option)}
      </ChooserItem>
    {/each}
  </div>
</div>

<style lang="postcss">
	.body-hidden {
		@apply hidden;
	}
</style>