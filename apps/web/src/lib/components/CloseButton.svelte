<script lang="ts">
  import CloseIcon from "$lib/icons/x-mark.svg";

  let className: string;
  export { className as class };
</script>

<button class="btn btn-circle btn-ghost outline-none {className}" on:click>
  <img src={CloseIcon} alt="Close" height="24" width="24" />
</button>