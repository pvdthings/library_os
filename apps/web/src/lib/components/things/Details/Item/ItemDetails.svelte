<script lang="ts">
	import { Badge } from '$lib/components/Badge';
	import Divider from '$lib/components/Divider.svelte';
	import Wrap from '$lib/components/Wrap.svelte';
  import BoxIcon from '$lib/icons/box.svg';
	import { locale, t } from '$lib/language/translate';
	import Section from '../Section.svelte';
	import Title from '../Title.svelte';

  let name: string = 'Hacksaw';
  let brand: string = 'DeWalt';
  let available: boolean = false;
  let availableDate: string = '10/01/2024';
  let attachmentUrls: string[] = [
    'https://pvdthings.coop/software',
    'https://pvdthings.coop/software'
  ];
</script>

<section
	class="flex-grow-0 flex-shrink-0 h-48 md:h-64 border-b border-base-300 overflow-hidden relative shadow-sm"
>
	<img
		src={BoxIcon}
		alt={'name'}
		class="object-center object-contain bg-white h-full w-full"
	/>
</section>
<div class="p-4 flex flex-col flex-grow overflow-y-scroll">
	<section>
		<Title>{name}</Title>
    <Wrap>
      {#if available}
        <Badge type='success'>{$t('Available')}</Badge>
      {/if}
      {#if !available}
        <Badge type='error'>{$t('Unavailable')}</Badge>
      {/if}
      {#if availableDate}
        <Badge>{$t('Due Back')} {new Date(availableDate).toLocaleDateString($locale)}</Badge>
      {/if}
    </Wrap>
	</section>
	<Divider />
  <Section title='Brand'>
    <span class="text-lg">{brand}</span>
  </Section>
  <Divider />
  <Section title='Attachments'>
    <div class="grid grid-cols-3 gap-4">
      {#each attachmentUrls as url}
        <a href={url} target="_blank" class="aspect-square p-2 bg-white card flex flex-row items-center justify-center border border-base-300 shadow active:shadow-sm">
          <span class="ph ph-file text-5xl" />
        </a>
      {/each}
    </div>
  </Section>
</div>