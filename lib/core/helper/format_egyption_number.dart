String formatEgyptPhone(String input) {
  var p = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (p.startsWith('20')) p = p.substring(2);
  if (p.startsWith('0')) p = p.substring(1);
  return '+20$p';
}