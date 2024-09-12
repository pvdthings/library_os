import { getContext } from "svelte";

export type ShellContext = {
  drawer: DrawerContext;
};

export type DrawerContext = {
  open: (content, props: any) => void;
};

export function getShellContext(): ShellContext {
  return getContext('shell');
}