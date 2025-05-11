import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scored/l10n/app_localizations.dart';

import 'action_button_text.dart';
import 'models/user.dart';

class UserFormWidget extends StatefulWidget {
  const UserFormWidget({super.key, required this.user});

  final User user;

  @override
  UserFormWidgetState createState() {
    return UserFormWidgetState();
  }

  static void showUserFormDialog(BuildContext context, AppLocalizations locale,
      User model, Function() onSubmitted) {
    final GlobalKey<UserFormWidgetState> userFormKey =
        GlobalKey<UserFormWidgetState>();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          insetPadding: const EdgeInsets.all(16.0),
          title: Text(locale.addPlayer),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UserFormWidget(
                  key: userFormKey,
                  user: model,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: ActionButtonText(text: locale.cancel)),
            TextButton(
                onPressed: () {
                  if (userFormKey.currentState!.validateAndSave()) {
                    Navigator.pop(context);
                    onSubmitted();
                  }
                },
                child: ActionButtonText(text: locale.add))
          ],
        );
      },
    );
  }
}

class UserFormWidgetState extends State<UserFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _scoreRegex = RegExp(r'^-?[0-9]*');

  bool validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  final _scoreController = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              autofocus: true,
              onSaved: (String? value) => {widget.user.name = value!},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.nameError;
                }
                if (value.length > User.maxNameLength) {
                  return locale.nameLengthError(User.maxNameLength);
                }
                return null;
              },
              decoration: InputDecoration(
                  filled: false,
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                  labelText: locale.name,
                  hintText: ""),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: TextFormField(
              onTap: () {
                _scoreController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _scoreController.value.text.length);
              },
              controller: _scoreController,
              onSaved: (String? value) =>
                  {widget.user.score = int.parse(value!)},
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(_scoreRegex)
              ],
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: false, signed: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.scoreMissingError;
                }

                int max = 5;

                // Numbers can be 5 digits (6 including the sign)
                if (value.contains("-")) {
                  if (value.length > max + 1) {
                    return locale.pointsLengthError(max);
                  }
                } else {
                  if (value.length > max) {
                    return locale.pointsLengthError(max);
                  }
                }

                if (!_scoreRegex.hasMatch(value) || value == "-") {
                  return locale.scoreInvalidError;
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "",
                filled: false,
                prefixIcon: const Icon(Icons.score),
                border: const OutlineInputBorder(),
                labelText: locale.points,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
