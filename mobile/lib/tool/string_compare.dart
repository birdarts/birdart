bool compareIgnoreCase(String text, String textTarget) {
  var length = textTarget.length;
  if (length != text.length) return false;
  var delta = 0;
  for (var i = 0; i < length; i++) {
    delta |= text.codeUnitAt(i) ^ textTarget.codeUnitAt(i);
  }
  return (delta & ~0x20) == 0;
}
