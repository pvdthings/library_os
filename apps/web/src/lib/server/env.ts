import { API_HOST, API_KEY } from "$env/static/private";

export const HOST = !!API_HOST ? API_HOST : 'http://localhost:8088';

export const KEY = API_KEY;