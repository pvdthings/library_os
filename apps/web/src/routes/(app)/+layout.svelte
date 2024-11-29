<script>
	import '../../app.css';
	import '@phosphor-icons/web/light';
	import '@phosphor-icons/web/regular';
	import '@phosphor-icons/web/bold';
	import '@phosphor-icons/web/fill';
	import { navigating } from '$app/stores';
	import { Head } from '$lib/components';
	import { AppBar, Body, Shell } from '$lib/components/Shell';
	import BottomNavigationView from '$lib/views/BottomNavigationView.svelte';
	import HomeButton from '$lib/components/HomeButton.svelte';
	import { Actions } from '$lib/views/Actions';
	import LoadingSpinner from '$lib/components/LoadingSpinner.svelte';
	import AbsoluteCenter from '$lib/components/AbsoluteCenter.svelte';
</script>

<Head
	title="PVD Things"
	description="PVD Things Catalog"
	keywords="Providence, Library, Things, PVD, Tools, Rentals, Sharing"
	image="/PVD_Things_Twitter_Header.png"
	url="https://web.pvdthings.coop"
	twitterHandle="@pvdthings"
/>
<Shell>
	<AppBar>
		<HomeButton slot="start" />
		<Actions slot="end" />
	</AppBar>
	<Body>
		{#if $navigating}
			<AbsoluteCenter>
				<LoadingSpinner />
			</AbsoluteCenter>
		{:else}
			<slot />
		{/if}
	</Body>
	<BottomNavigationView />
</Shell>
