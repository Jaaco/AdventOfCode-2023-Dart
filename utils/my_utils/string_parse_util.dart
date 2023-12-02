class StringParseUtil {
  int intInString(String str) {
    return int.parse(str.replaceAll(RegExp('[^0-9]'), ''));
  }
}
