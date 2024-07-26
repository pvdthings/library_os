<script lang="ts">
	import { BottomNavigation, BottomNavigationItem } from '$lib/components/Shell';
	import BookOpenIcon from '$lib/icons/book-open.svg';
	import BookmarkIcon from '$lib/icons/bookmark.svg';
	import LightbulbIcon from '$lib/icons/lightbulb.svg';
	import SolidBookOpenIcon from '$lib/icons/solid/book-open.svg';
	import SolidBookmarkIcon from '$lib/icons/solid/bookmark.svg';
	import SolidLightbulbIcon from '$lib/icons/solid/lightbulb.svg';

	import { t } from '$lib/language/translate';
	import { activeScreen, Screen } from '$lib/stores/app';
	import { bookmarks } from '$lib/stores/bookmarks';
	import { vibrate } from '$lib/utils/haptics';

	$: catalogText = $t('Catalog');
	$: bookmarksText = $t('Bookmarks');
	$: learnText = $t('Learn');

	const switchScreen = (screen: Screen) => {
		$activeScreen = screen;
		vibrate();
	};
</script>

<BottomNavigation>
	<BottomNavigationItem
		active={$activeScreen === Screen.catalog}
		icon={$activeScreen === Screen.catalog ? SolidBookOpenIcon : BookOpenIcon}
		label={catalogText}
		on:click={() => switchScreen(Screen.catalog)}
	/>
	<BottomNavigationItem
		active={$activeScreen === Screen.myList}
		icon={$activeScreen === Screen.myList ? SolidBookmarkIcon : BookmarkIcon}
		indicatorValue={$bookmarks.length}
		label={bookmarksText}
		on:click={() => switchScreen(Screen.myList)}
	/>
	<BottomNavigationItem
		active={$activeScreen === Screen.info}
		icon={$activeScreen === Screen.info ? SolidLightbulbIcon : LightbulbIcon}
		label={learnText}
		on:click={() => switchScreen(Screen.info)}
	/>
</BottomNavigation>
