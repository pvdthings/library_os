import { derived, writable } from 'svelte/store';

const emptyState = Object.freeze({ views: [] });

let previousViewsLength = 0;

export type DrawerState = {
	views: DrawerContent[];
};

export type DrawerContent = {
	component: any;
	props: any;
};

export const state = writable<DrawerState>(emptyState);

export const view = derived(state, (s) => {
	return s.views.length ? s.views[0] : undefined;
});

export const push = (component: any, props: any) => {
	state.update((s) => ({
		views: [{ component, props }, ...s.views]
	}));
};

export const pop = () => {
  state.update((s) => ({
		views: s.views.slice(1)
	}));
};

export const close = () => {
	state.update((s) => emptyState);
};

// pushing second view does not work
export const toggle = (callback: () => void) => {
	return state.subscribe(s => {
		if (previousViewsLength === 0 && s.views.length) {
			callback();
		}

		if (previousViewsLength && !s.views.length) {
			callback();
		}

		previousViewsLength = s.views.length;
	});
};