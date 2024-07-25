<script>
	import '../app.css';
	import { Head } from '$lib/components';
	import BottomNavigationView from '$lib/views/BottomNavigationView.svelte';
	import AppBar from '$lib/components/AppBar.svelte';
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
<main class="flex flex-col w-full min-h-screen">
	<AppBar>
		<HomeButton slot="start" />
		<Actions slot="end" />
	</AppBar>
	<div class="flex-grow pt-24 lg:pt-32 mx-3 lg:mx-auto lg:w-3/4 relative">
		<slot />
	</div>
	<BottomNavigationView />
</main>
