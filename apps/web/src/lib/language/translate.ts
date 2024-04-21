// Code unapologetically copied from: https://dev.to/danawoodman/svelte-quick-tip-adding-basic-internationalization-i18n-to-you-app-2lm
import { browser } from "$app/environment";
import { derived, writable } from "svelte/store";
import translations from "./translations";

const DEFAULT_LOCALE = 'en';

function getInitialLocaleValue() {
  if (browser) {
    const savedValue = window.localStorage.getItem('locale');
    return savedValue ?? DEFAULT_LOCALE;
  }

  return DEFAULT_LOCALE;
}

export const locale = writable(getInitialLocaleValue());
export const locales = Object.keys(translations);

locale.subscribe((value) => {
  if (browser) {
    window.localStorage.setItem('locale', value);
  }
});

function translate(locale, key, vars) {
  // Let's throw some errors if we're trying to use keys/locales that don't exist.
  // We could improve this by using Typescript and/or fallback values.
  if (!key) throw new Error("no key provided to $t()");
  if (!locale) throw new Error(`no translation for key "${key}"`);

  // Grab the translation from the translations object.
  let text = translations[locale][key];

  if (!text) throw new Error(`no translation found for ${locale}.${key}`);

  // Replace any passed in variables in the translation string.
  Object.keys(vars).map((k) => {
    const regex = new RegExp(`{{${k}}}`, "g");
    text = text.replace(regex, vars[k]);
  });

  return text;
}

export const t = derived(locale, ($locale) => (key, vars = {}) =>
  translate($locale, key, vars)
);