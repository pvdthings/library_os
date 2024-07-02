<script lang="ts">
  import CloseIcon from "$lib/icons/x-mark.svg";
	import { createEventDispatcher, onMount } from "svelte";

  export let show: boolean = false;

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
  <div class="modal-box">
    <button class="btn btn-circle btn-ghost outline-none absolute right-2 top-2" on:click={closeModal}>
      <img src={CloseIcon} alt="Close" height="24" width="24" />
    </button>
    <slot />
  </div>
</dialog>