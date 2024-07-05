export const openDonationForm = (name: string) => {
  const donateURL = `https://airtable.com/shrwMSrzvSLpQgQWC?prefill_Description=${encodeURIComponent(name)}`;
  window.open(donateURL, '_blank').focus();
};