<script>
	import '../app.css';
	import { Head } from '$lib/components';
	import BottomNavigationView from '$lib/views/BottomNavigationView.svelte';
	import HomeButton from '$lib/components/HomeButton.svelte';
	import { Actions } from '$lib/views/Actions';
	import { AppBar, Shell } from '$lib/components/Shell';
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
	<AppBar slot="top">
		<HomeButton slot="start" />
		<Actions slot="end" />
	</AppBar>
	<svelte:fragment slot="body">
		<slot />
	</svelte:fragment>
	<BottomNavigationView slot="bottom" />
</Shell>
