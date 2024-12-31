import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scored/models/user.dart';
import 'action_button_text.dart';

class UserRenameFormWidget extends StatefulWidget {
  const UserRenameFormWidget({super.key, required this.baseModel});

  final User baseModel;

  @override
  UserRenameFormWidgetState createState() {
    return UserRenameFormWidgetState();
  }

  static void showUserRenameDialog(BuildContext context,
      AppLocalizations locale, User startModel, Function(User) onSubmitted) {
    final GlobalKey<UserRenameFormWidgetState> userKey =
        GlobalKey<UserRenameFormWidgetState>();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(16.0),
          title: Text(locale.renameUser(startModel.name)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UserRenameFormWidget(
                  key: userKey,
                  baseModel: startModel,
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
                  if (userKey.currentState!.validateAndSave()) {
                    Navigator.pop(context);
                    onSubmitted(userKey.currentState!.getResult());
                  }
                },
                child: ActionButtonText(text: locale.rename))
          ],
        );
      },
    );
  }
}

class UserRenameFormWidgetState extends State<UserRenameFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = "";

  bool validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  User getResult() {
    return User(
      id: widget.baseModel.id,
      name: name,
      order: widget.baseModel.order,
    );
  }

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
              initialValue: widget.baseModel.name,
              autofocus: true,
              onSaved: (String? value) => {name = value!},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.nameError;
                }
                return null;
              },
              decoration: InputDecoration(
                  filled: false,
                  prefixIcon: const Icon(Icons.drive_file_rename_outline),
                  border: const OutlineInputBorder(),
                  labelText: locale.name,
                  hintText: ""),
            ),
          ),
        ],
      ),
    );
  }
}
