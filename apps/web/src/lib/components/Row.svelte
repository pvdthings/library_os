<script>
    export let right = false;
    export let center = false;
    export let spread = false;
</script>

<div class:right class:center class:spread class="flex flex-row space-x-4">
    <slot />
</div>

<style lang="postcss">
    div.right {
        @apply justify-end;
    }

    div.center {
        @apply justify-center;
    }

    div.spread {
        @apply justify-between;
    }
</style>