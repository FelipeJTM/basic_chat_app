import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/constant_colors.dart';

class GeneralPurposeWidget {
  static void showSnackBar(
      {required BuildContext context,
      required String message,
      required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: ConstantColors.alterFontColor),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: ConstantColors.primaryYellow,
      ),
    ));
  }

  static Widget bottomMessageWithLink({
    required BuildContext context,
    required String mainPhrase,
    required String linkPhrase,
    required VoidCallback navigationFunction,
  }) {
    /// Creates a message with a link the.
    ///
    /// For the navigationFunction, you can use something like:
    /// () { Navigator.of(context).pop(); }
    return Text.rich(
      TextSpan(
        text: mainPhrase,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
              text: linkPhrase,
              style: const TextStyle(
                  color: Colors.black, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () => navigationFunction()),
        ],
      ),
    );
  }
}
