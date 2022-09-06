class FormHelper{
  dynamic verifyEmailFormat(String value) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)
        ? null
        : "Please enter a valid email";
  }

  dynamic verifyTextLength(String value, int length) {
    if (value.length < length) {
      return "Enter a value greater than $length characters.";
    } else {
      return null;
    }
  }
}