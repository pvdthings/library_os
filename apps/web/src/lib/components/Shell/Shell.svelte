<script lang="ts">
	import { setContext } from "svelte";

	let drawerToggle: HTMLLabelElement;
	let drawerContent: any;
	let drawerContentProps: any;

	const drawer = {
		open: (content: any, props = {}) => {
			drawerContent = content;
			drawerContentProps = props;
			drawerToggle.click();
		},
		close: () => {
			drawerToggle.click();
			drawerContent = null;
			drawerContentProps = null;
		}
	};

	setContext('shell', {
		drawer
	});
</script>

<div class="drawer drawer-end">
	<input id="drawer-toggle" type="checkbox" class="drawer-toggle" />
	<div class="flex flex-col h-dvh w-screen overflow-hidden drawer-content">
		<label bind:this={drawerToggle} for="drawer-toggle" />
		<slot />
	</div>
	<div class="drawer-side z-50">
    <label for="drawer-toggle" aria-label="close sidebar" class="drawer-overlay"></label>
    <div class="bg-base-200 text-base-content flex flex-col h-dvh w-screen overflow-hidden md:w-80 lg:w-96 relative">
      <svelte:component this={drawerContent} {...drawerContentProps} />
    </div>
  </div>
</div>