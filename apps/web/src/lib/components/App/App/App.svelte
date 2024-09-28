<script>
  import AppContext from "./AppContext.svelte";
	import { Body } from "../Body";
	import { BottomNavigation } from "../BottomNavigation";
	import { Menu } from "../Menu";
	import { Page } from "../Page";

</script>

<AppContext>
  <Page>
    <Menu />
    <Body>
      <slot />
    </Body>
    <BottomNavigation />
  </Page>
</AppContext>