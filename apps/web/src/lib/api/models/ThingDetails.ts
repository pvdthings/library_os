export type ThingDetailsModel = {
  id: string;
  name: string;
  spanishName?: string;
  availableDate?: string;
  categories: string[];
  available: number;
  stock: number;
  image?: string;
  items: InventoryItemModel[];
};

export type InventoryItemModel = {
  id: string;
  number: number;
  brand?: string;
  hidden: boolean;
  status: 'available'|'checkedOut';
};