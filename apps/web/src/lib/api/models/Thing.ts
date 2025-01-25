export type ThingID = string;

export interface Thing {
  id: ThingID;
  name: string;
  spanishName?: string;
  categories: string[];
  image?: string;
  stock: number;
  available: number;
  availableDate?: string;
}