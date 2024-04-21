<script>
	import { Button } from "$lib/components";
	import { t } from "$lib/language/translate";
</script>

<div class="bg-yellow-100 border border-gray-500 shadow-high rounded-md">
  <div class="container">
    <h3 class="font-bold text-2xl">{$t('How to Borrow')}</h3>
    <ol class="pl-4 pt-4 text-lg list-decimal">
      <li class="mb-2">{$t('How to Borrow.Step1')}</li>
      <li class="mb-2">{$t('How to Borrow.Step2')}</li>
    </ol>
    <div class="mt-4">
      <Button on:click={() => window.open("https://www.pvdthings.coop/membership", '_blank').focus()}>
        {$t('Learn More')}
      </Button>
    </div>
  </div>
  <hr class="border-gray-500" />
  <div class="container">
    <h4 class="font-bold">{$t('Hours')}</h4>
    <ul class="pt-1">
      <li>{$t('Wednesday')} 6PM - 8PM</li>
      <li>{$t('Saturday')} 11AM - 2PM</li>
    </ul>
  </div>
</div>

<style>
  .container {
    @apply p-4 lg:p-6;
  }
</style>