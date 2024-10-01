<script lang="ts">
	import { onDestroy } from "svelte";
	import { NavigationButton } from "./Drawer/NavigationButton";
	import { state as drawer, toggle } from "./drawer";

	let drawerToggle: HTMLLabelElement;

	const unsubscribe = toggle(() => drawerToggle?.click());

	onDestroy(unsubscribe);
</script>

<div class="drawer drawer-end">
	<input id="drawer-toggle" type="checkbox" class="drawer-toggle" />
	<div class="flex flex-col h-dvh w-screen overflow-hidden drawer-content">
		<label bind:this={drawerToggle} for="drawer-toggle" />
		<slot />
	</div>
	<div class="drawer-side z-50">
    <label for="drawer-toggle" aria-label="close sidebar" class="drawer-overlay"></label>
    <div class="bg-neutral-200 flex flex-col h-dvh w-screen overflow-hidden md:w-80 lg:w-96 relative">
      {#if $drawer.views.length}
				<NavigationButton class="absolute top-4 left-4 z-50" />
				<svelte:component this={$drawer.views[0].component} {...$drawer.views[0].props} />
			{/if}
    </div>
  </div>
</div>