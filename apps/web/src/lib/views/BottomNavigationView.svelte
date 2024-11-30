<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { BottomNavigation, BottomNavigationItem } from '$lib/components/Shell';
	import BookOpenIcon from '$lib/icons/book-open.svg';
	import BookmarkIcon from '$lib/icons/bookmark.svg';
	import LightbulbIcon from '$lib/icons/lightbulb.svg';
	import SolidBookOpenIcon from '$lib/icons/solid/book-open.svg';
	import SolidBookmarkIcon from '$lib/icons/solid/bookmark.svg';
	import SolidLightbulbIcon from '$lib/icons/solid/lightbulb.svg';

	import { t } from '$lib/language/translate';
	import { bookmarks } from '$lib/stores/bookmarks';

	$: catalogText = $t('Catalog');
	$: bookmarksText = $t('Bookmarks');
	$: learnText = $t('Learn');
	$: volunteerText = $t('Volunteer');
</script>

<BottomNavigation>
	<BottomNavigationItem
		active={$page.url.pathname === '/'}
		icon={$page.url.pathname === '/' ? SolidBookOpenIcon : BookOpenIcon}
		label={catalogText}
		on:click={() => goto('/')}
	/>
	<BottomNavigationItem
		active={$page.url.pathname === '/bookmarks'}
		icon={$page.url.pathname === '/bookmarks' ? SolidBookmarkIcon : BookmarkIcon}
		indicatorValue={$bookmarks.length}
		label={bookmarksText}
		on:click={() => goto('/bookmarks')}
	/>
	<BottomNavigationItem
		active={$page.url.pathname === '/info'}
		icon={$page.url.pathname === '/info' ? SolidLightbulbIcon : LightbulbIcon}
		label={learnText}
		on:click={() => goto('/info')}
	/>
	<BottomNavigationItem
		active={$page.url.pathname === '/volunteer'}
		iconStyle={$page.url.pathname === '/volunteer' ? 'ph-fill ph-clock text-xl' : 'ph-bold ph-clock text-xl'}
		label={volunteerText}
		on:click={() => goto('/volunteer')}
	/>
</BottomNavigation>
