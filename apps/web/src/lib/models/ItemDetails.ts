export type ItemDetailsModel = {
  id: string;
  image?: string;
  name: string;
  spanishName?: string;
  number: number;
  available: boolean;
  availableDate?: string;
  brand?: string;
  condition?: string;
  hidden: boolean;
  manuals: string[];
  status: 'available'|'checkedOut';
};