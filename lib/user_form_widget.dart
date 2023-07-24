import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'models/user.dart';

typedef UserFormBuilder = void Function(
    BuildContext context, User? Function() submitFunction);

class UserFormWidget extends StatefulWidget {
  const UserFormWidget({super.key, required this.builder});

  final UserFormBuilder builder;

  @override
  UserFormWidgetState createState() {
    return UserFormWidgetState();
  }
}

class UserFormWidgetState extends State<UserFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final User _user = User(name: "");
  final _scoreRegex = RegExp(r'-?[0-9]');

  User? _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return _user;
    }
    return null;
  }

  final _scoreController = TextEditingController(
      text: "0"
  );


  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    widget.builder.call(context, _submit);
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              autofocus: true,
              onSaved: (String? value) => {_user.name = value!},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.nameError;
                }
                return null;
              },
              decoration: InputDecoration(
                filled: false,
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
                labelText: locale.player,
                helperText: ""
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: TextFormField(
              onTap: () {
                _scoreController.selection = TextSelection(baseOffset: 0, extentOffset: _scoreController.value.text.length);
              },
              controller: _scoreController,
              onSaved: (String? value) => {
                  _user.score = int.parse(value!)
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(_scoreRegex)
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.scoreMissingError;
                }

                if (!_scoreRegex.hasMatch(value)) {
                  return locale.scoreInvalidError;
                }
                return null;
              },
              decoration: InputDecoration(
                helperText: "",
                filled: false,
                prefixIcon: const Icon(Icons.score),
                border: const OutlineInputBorder(),
                labelText: locale.score,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
