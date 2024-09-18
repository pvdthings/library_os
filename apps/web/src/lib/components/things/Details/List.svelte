<script lang="ts">
  export let title: string;
</script>

<div class="flex flex-col gap-2 mb-3">
  <div class="font-display font-medium text-md">{title}</div>
  <slot />
</div>