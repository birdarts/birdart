Iterable<String> getNonBmpChars(String str) {
  Set<int> runes = {};

  for (final rune in str.runes) {
    if (rune > 0xFFFF && !runes.contains(rune)) {
      runes.add(rune);
    }
  }

  return runes.map((e) => String.fromCharCode(e));
}
