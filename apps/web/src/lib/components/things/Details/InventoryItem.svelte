<script lang="ts">
  export let number: number;
  export let imageUrl: string|undefined;
  export let brand: string|undefined;
  export let available: boolean;

  const badgeVariant = available ? 'badge-success' : 'badge-warning';
</script>

<div class="card border border-base-300 flex flex-row gap-2 relative">
  <span class="absolute -top-1 -left-1 badge badge-sm {badgeVariant} shadow" />
  <div class="p-2 border-r border-base-300 font-display">#{number}</div>
  <div class="p-2">{brand}</div>
</div>