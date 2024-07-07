<script lang="ts">
  import CloseIcon from "$lib/icons/x-mark.svg";
	import { createEventDispatcher, onMount } from "svelte";

  export let show: boolean = false;
  export let title: string = undefined;

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

<dialog bind:this={dialog} class="modal modal-bottom sm:modal-middle modal-responsive">
  <div class="modal-box relative">
    <button class="btn btn-circle btn-ghost outline-none absolute right-2 top-2" on:click={closeModal}>
      <img src={CloseIcon} alt="Close" height="24" width="24" />
    </button>
    {#if title}
      <h2 class="font-bold font-display text-2xl mb-3">{title}</h2>
    {/if}
    <slot />
  </div>
</dialog>

<style>
  .modal-responsive {
    padding-bottom: env(safe-area-inset-bottom, 0);
  }
</style>