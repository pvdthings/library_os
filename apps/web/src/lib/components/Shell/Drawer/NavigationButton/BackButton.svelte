<script lang="ts">
  import { pop } from "../drawer";

  let className: string = '';
  export { className as class };
</script>

<button class="btn btn-circle bg-white outline-none shadow {className}" on:click={pop}>
  <span class="ph-bold ph-arrow-left text-xl" />
</button>