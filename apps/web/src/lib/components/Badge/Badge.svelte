<script lang="ts">
	import { style, type BadgeType } from "./type";

  export let type: BadgeType = 'neutral';
</script>

<div class="badge {style(type)} badge-lg">
  <slot />
</div>