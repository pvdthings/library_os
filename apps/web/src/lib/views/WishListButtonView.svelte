<script>
	import { Button } from "$lib/components";
	import { ButtonTheme } from "$lib/components/Button";
  import EyeOffIcon from '$lib/icons/eye-off.svg';
	import EyeIcon from '$lib/icons/eye.svg';
	import { t } from "$lib/language/translate";
	import { wishListFilter } from "$lib/stores/catalog";

  let innerWidth;
  $: showIcon = innerWidth > 376;

  const toggleWishList = () => {
    $wishListFilter = !$wishListFilter;
	};
</script>

<svelte:window bind:innerWidth />

{#key $wishListFilter}
  <Button
    on:click={toggleWishList}
    icon={showIcon ? EyeOffIcon : undefined}
    selectedIcon={showIcon ? EyeIcon : undefined}
    theme={ButtonTheme.default}
    text={$t('Button.WishList')}
    selected={$wishListFilter}
  >
    {$t('Button.WishList')}
  </Button>
{/key}