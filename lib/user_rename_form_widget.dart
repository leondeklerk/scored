import 'package:flutter/material.dart';
import 'package:scored/l10n/app_localizations.dart';
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
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              insetPadding: const EdgeInsets.all(16.0),
              title: Text(
                locale.renameUser(startModel.name),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
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
            ),
          ),
        );
      },
    );
  }
}

class UserRenameFormWidgetState extends State<UserRenameFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  late FocusNode _focusNode;

  bool validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  User getResult() {
    return widget.baseModel.copyWith(name: name);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }

    _focusNode.dispose();
    super.dispose();
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
              focusNode: _focusNode,
              onSaved: (String? value) => {name = value!},
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
