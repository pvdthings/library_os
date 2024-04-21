<script lang="ts">
	import { t } from "$lib/language/translate";
	import { createEventDispatcher } from "svelte";
  import MinusCircleIcon from '$lib/icons/minus-circle.svg';
  import BoxIcon from '$lib/icons/box.svg';

  export let thingName: string;
  export let category: string;
  export let imgSrc: string;
  export let available: number;

  const dispatch = createEventDispatcher();
</script>

<tr>
  <td>
    <div class="flex space-x-3">
      <div class="avatar">
        <div class="mask rounded-md border border-gray-300 bg-white w-14 h-14">
          <img src={imgSrc ?? BoxIcon} alt={thingName} />
        </div>
      </div>
      <div>
        <div class="text-base font-bold">{thingName}</div>
        <div class="text-sm">{available} {$t('Available')}</div>
        <span class="badge badge-ghost mt-2 bg-yellow-300 border-yellow-400">{$t(category)}</span>
      </div>
    </div>
  </td>
  <th>
    <button class="btn btn-ghost btn-circle float-right" on:click={() => dispatch('remove')}>
      <img src={MinusCircleIcon} alt="Remove" class="h-6 w-6" />
    </button>
  </th>
</tr>