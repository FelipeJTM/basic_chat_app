import 'package:basic_chat_app/models/form_config_data.dart';
import 'package:flutter/material.dart';
import '../helper/form_helper.dart';
import '../theme/form_decorations.dart';

class CustomFormWidgets {
  static Widget textField(BuildContext context, FormConfigData formConfigData) {
    FormHelper formHelper = FormHelper();
    return TextFormField(
      obscureText: formConfigData.hideText,
      decoration: FormDecorations.textInputDecorationForm.copyWith(
        labelText: formConfigData.labelText,
        prefixIcon: Icon(
          formConfigData.icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onChanged: (newInputValue) {
        formConfigData.assignNewValue(newInputValue);
      },
      validator: (currentInputValue) {
        var problemFromEmailFormat = formConfigData.isItAnEmailField
            ? formHelper.verifyEmailFormat(currentInputValue!)
            : null;
        if (problemFromEmailFormat != null) return problemFromEmailFormat;
        var problemsFromInputLength = formHelper.verifyTextLength(
            currentInputValue!, formConfigData.inputMinLength);
        if (problemsFromInputLength != null) return problemsFromInputLength;
        return null;
      },
    );
  }

  static Widget button(String buttonText, Function onPressEvent) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onPressEvent(),
        style: FormDecorations.buttonDecoration,
        child: Text(buttonText),
      ),
    );
  }
}
