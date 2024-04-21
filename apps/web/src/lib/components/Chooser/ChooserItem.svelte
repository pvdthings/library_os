<script lang="ts">
  import CheckIcon from "$lib/icons/check.svg";

  export let selected: boolean;
</script>

<button
  on:click
  class:selected
  class="text-2xl md:text-lg p-4 md:py-2 text-left hover:bg-gray-300 align-middle"
  >
    <slot />
    {#if selected}
      <img class="inline-block float-right mt-1 w-[20px] h-[20px]" src={CheckIcon} alt="Selected" />
    {/if}
  </button
>