<script lang="ts">
	import SectionTitle from "./SectionTitle.svelte";

  export let title: string;
</script>

<section>
  <SectionTitle>{title}</SectionTitle>
  <slot />
</section>