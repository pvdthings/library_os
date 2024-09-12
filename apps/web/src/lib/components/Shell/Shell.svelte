<script>
	import { setContext } from "svelte";

	let drawerToggle;
	let drawerContent = 'Drawer Content!';

	const drawer = {
		open: () => {
			// drawerContent = content;
			drawerToggle.click();
		}
	};

	setContext('shell', {
		drawer
	});
</script>

<div class="drawer drawer-end">
	<input id="drawer-toggle" type="checkbox" class="drawer-toggle" />
	<div class="flex flex-col w-screen h-screen overflow-hidden drawer-content">
		<label bind:this={drawerToggle} for="drawer-toggle" />
		<slot />
	</div>
	<div class="drawer-side z-50">
    <label for="drawer-toggle" aria-label="close sidebar" class="drawer-overlay"></label>
    <div class="bg-base-200 text-base-content min-h-full">
      {drawerContent}
    </div>
  </div>
</div>