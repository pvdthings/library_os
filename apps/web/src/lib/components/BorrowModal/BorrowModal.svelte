<script lang="ts">
  import { Button } from "$lib/components";
	import { ButtonTheme } from "$lib/components/Button/button";
  import { showBorrowModal } from "./stores";
  import CloseIcon from "$lib/icons/x-mark.svg";
	import { onDestroy } from "svelte";
	import { t } from "$lib/language/translate";

  let dialog: HTMLDialogElement;

  const unsubscribe = showBorrowModal.subscribe((value) => {
    if (value) dialog.showModal();
  });

  const closeModal = () => showBorrowModal.set(false);

  const learnMore = () => {
    closeModal();
    window.open("https://www.pvdthings.coop/membership", '_blank').focus();
  };

  onDestroy(unsubscribe);
</script>

<dialog bind:this={dialog} id="borrow-modal" class="modal modal-bottom sm:modal-middle">
  <form method="dialog" class="modal-box">
    <button class="btn btn-circle btn-ghost outline-none absolute right-2 top-2" on:click={() => showBorrowModal.set(false)}>
      <img src={CloseIcon} alt="Close" height="24" width="24" />
    </button>
    <h3 class="font-bold text-lg">{$t('How to Borrow')}</h3>
    <ol class="py-4">
      <li class="mb-2">1. {$t('How to Borrow.Step1')}</li>
      <li class="mb-2">2. {$t('How to Borrow.Step2')}</li>
    </ol>
    <h4 class="font-bold">{$t('Hours')}</h4>
    <ul class="pt-1 pb-6">
      <li>{$t('Wednesday')} 6PM - 8PM</li>
      <li>{$t('Saturday')} 11AM - 2PM</li>
    </ul>
    <div class="modal-bottom flex flex-row justify-between">
      <Button on:click={learnMore}>
        {$t('Learn More')}
      </Button>
      <Button theme={ButtonTheme.primary} on:click={closeModal}>
        {$t('OK')}
      </Button>
    </div>
  </form>
</dialog>