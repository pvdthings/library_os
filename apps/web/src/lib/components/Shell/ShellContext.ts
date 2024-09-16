import { getContext } from "svelte";

export type ShellContext = {
  drawer: DrawerContext;
};

export type DrawerContext = {
  open: (content: any, props: any) => void;
  close: () => void;
};

export function getShellContext(): ShellContext {
  return getContext('shell');
}