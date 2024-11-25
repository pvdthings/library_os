export const pluralize = (count: number, word: string) => {
  var string = `${count} ${word}`;

  if (count > 1 || count == 0) {
    string += 's';
  }

  return string;
}

export const toBe = (count: number) => {
  return count === 1 ? 'is' : 'are';
};