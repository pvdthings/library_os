<script lang="ts">
  import "./Chooser.css";
  import ChevronIcon from "$lib/icons/chevron.svg";
  import CloseIcon from '$lib/icons/x-mark.svg';
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
  class="fixed top-0 left-0 w-full h-full overflow-hidden md:h-fit md:absolute bg-indigo-50 md:border md:border-gray-500 md:shadow-highest md:rounded-md flex flex-col z-50 md:z-40"
>
  <div class="md:hidden">
    <div class="p-4 bg-primary text-2xl font-bold text-left sticky top-0">
      {title}
      <button class="float-right" on:click={onClose}>
        <img class="w-[30px] h-[30px]" src={CloseIcon} alt="close" />
      </button>
    </div>
    <hr class="border-black border-opacity-20" />
  </div>
  <button
		on:click={onClose}
		class="chooser-button hidden md:block bg-primary h-11 w-full border-b border-gray-500"
	>
    <img
      class="inline rotate-180 mr-1"
      src={ChevronIcon}
      alt="Dropdown"
    />
		<span>{$t(chosenOption)}</span>
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