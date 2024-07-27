<script>
	import '../app.css';
	import { Head } from '$lib/components';
	import { AppBar, Body, Shell } from '$lib/components/Shell';
	import BottomNavigationView from '$lib/views/BottomNavigationView.svelte';
	import HomeButton from '$lib/components/HomeButton.svelte';
	import { Actions } from '$lib/views/Actions';
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
		<slot />
	</Body>
	<BottomNavigationView />
</Shell>
