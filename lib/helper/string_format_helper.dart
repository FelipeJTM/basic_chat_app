
class StringFormatHelper{
  static String getId(String value) {
    return value.substring(0, value.indexOf("_"));
  }

  static String getName(String value) {
    return value.substring(value.indexOf('_') + 1);
  }
}