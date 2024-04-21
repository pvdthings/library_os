<script>
    import { createEventDispatcher } from 'svelte';

    export let value = "";
    export let customClass = "";
    export let invalid = false;

    const dispatch = createEventDispatcher();

    function keyReleased(event) {
        if (event.key === 'Enter')
            dispatch('enter');
    }
</script>

<input
    {...$$props}
    bind:value
    on:input
    on:change
    on:keyup={keyReleased}
    class:invalid
    class="w-full px-4 py-2 pl-10 rounded-md border border-gray-500 shadow-high outline-none {customClass}"
/>

<style lang="postcss">
    .invalid {
        @apply bg-red-200;
    }
</style>