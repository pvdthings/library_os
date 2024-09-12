export type ShellContext = {
  drawer: DrawerContext;
};

export type DrawerContext = {
  open: () => void;
};