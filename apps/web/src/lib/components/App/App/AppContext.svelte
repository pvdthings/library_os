<script lang="ts">
	import { setContext } from "svelte";

  // provides a root app context with centralized config
  setContext('App', {});
</script>

<slot />