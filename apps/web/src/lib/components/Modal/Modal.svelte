<script lang="ts">
	import { createEventDispatcher, onMount } from "svelte";
	import CloseButton from "../CloseButton.svelte";

  export let show: boolean = false;
  export let title: string = undefined;
  export let closeButton: boolean = true;

  const dispatch = createEventDispatcher();

  let dialog: HTMLDialogElement;

  onMount(() => {
    if (show) dialog.showModal();
  });

  const closeModal = () => {
    dialog.close();
    dispatch('close');
  };
</script>

<dialog bind:this={dialog} class="modal modal-bottom sm:modal-middle">
  <div class="modal-box relative modal-responsive">
    {#if closeButton}
      <CloseButton class="absolute right-2 top-2" on:click={closeModal} />
    {/if}
    {#if title}
      <h2 class="font-bold font-display text-2xl mb-3">{title}</h2>
    {/if}
    <slot />
  </div>
</dialog>

<style>
  .modal-responsive {
    padding-bottom: max(env(safe-area-inset-bottom, 0), 1.5rem);
  }
</style>