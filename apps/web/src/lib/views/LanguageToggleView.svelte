<script>
	import { locale } from '$lib/language/translate';

	$: otherLocale = $locale === 'en' ? 'es' : 'en';
</script>

<button
	on:click={() => $locale = otherLocale}
	class="btn btn-ghost btn-circle font-sans text-lg"
	aria-label="Language"
>
	{otherLocale.toUpperCase()}
</button>
