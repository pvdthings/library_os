<script lang="ts">
  import { close } from "../../drawer";

  let className: string = '';
  export { className as class };
</script>

<button class="btn btn-circle bg-white outline-none shadow {className}" on:click={close}>
  <span class="ph-bold ph-x text-xl" />
</button>