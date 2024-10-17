String pluralize(int count, String word) {
  var string = '$count $word';

  if (count > 1 || count == 0) {
    string += 's';
  }

  return string;
}
