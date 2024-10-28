<script lang="ts">
  export let selected: boolean;
</script>

<button
  on:click
  class:selected
  class="flex flex-row text-2xl md:text-sm p-4 md:px-4 md:py-2 font-display font-medium text-left hover:bg-neutral-200 items-center justify-between overflow-hidden"
  >
    <span>
      <slot />
    </span>
    {#if selected}
      <span class="ph-bold ph-check text-xl" />
    {/if}
  </button
>