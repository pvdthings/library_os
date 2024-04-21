export interface Thing {
  id: string;
  name: string;
  spanishName?: string;
  categories: string[];
  image?: string;
  stock: number;
  available: number;
}