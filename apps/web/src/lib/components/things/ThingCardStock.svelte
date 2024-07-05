<script lang="ts">
  export let remaining: number;
  export let total: number;

  const style = () => {
    if (remaining === 0) {
      return 'bg-red-200 text-red-900 border-red-300';
    }

    return 'bg-green-200 text-green-900 border-green-300';
  };
</script>

<div class="absolute top-0 right-0 px-2 py-1 font-medium border-l border-b rounded-bl-md {style()}">
  {remaining} / {total}
</div>