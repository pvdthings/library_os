<script lang="ts">
	import { Badge } from '$lib/components/Badge';
	import Divider from '$lib/components/Divider.svelte';
	import Wrap from '$lib/components/Wrap.svelte';
  import BoxIcon from '$lib/icons/box.svg';
	import { locale, t } from '$lib/language/translate';
	import Section from '../Section.svelte';
	import SectionTitle from '../SectionTitle.svelte';
	import Title from '../Title.svelte';

  export let number: number;
  export let image: string = undefined;
  export let name: string;
  export let brand: string = undefined;
  export let available: boolean;
  export let availableDate: string = undefined;
  export let manuals: string[];
</script>

<section
	class="flex-grow-0 flex-shrink-0 h-48 md:h-64 border-b border-base-300 overflow-hidden relative shadow-sm"
>
	<img
		src={image ?? BoxIcon}
		alt={'name'}
		class="object-center object-contain bg-white h-full w-full"
	/>
</section>
<div class="p-4 flex flex-col flex-grow overflow-y-scroll">
	<section>
		<Title>#{number}</Title>
    <SectionTitle>{name}</SectionTitle>
    <Wrap>
      {#if available}
        <Badge type='success'>{$t('Available')}</Badge>
      {/if}
      {#if !available}
        <Badge type='error'>{$t('Unavailable')}</Badge>
      {/if}
      {#if !available && availableDate}
        <Badge>{$t('Due Back')} {new Date(availableDate).toLocaleDateString($locale)}</Badge>
      {/if}
    </Wrap>
	</section>
	<Divider />
  <Section title={$t('Brand')}>
    <span>{brand ?? $t('None')}</span>
  </Section>
  <Divider />
  <Section title={$t('Attachments')}>
    <div class="grid grid-cols-3 gap-4">
      {#each manuals as url}
        <a href={url} target="_blank" class="aspect-square p-2 bg-white card flex flex-row items-center justify-center border border-base-300 shadow active:shadow-sm">
          <span class="ph ph-file text-5xl" />
        </a>
      {/each}
      {#if !manuals.length}
        <span>{$t('None')}</span>
      {/if}
    </div>
  </Section>
</div>