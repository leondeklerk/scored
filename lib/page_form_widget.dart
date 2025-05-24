import 'package:flutter/material.dart';
import 'package:scored/l10n/app_localizations.dart';
import 'package:scored/models/page_model.dart';

import 'action_button_text.dart';

class PageFormWidget extends StatefulWidget {
  const PageFormWidget({super.key, required this.initialName});

  final String initialName;

  @override
  PageFormWidgetState createState() {
    return PageFormWidgetState();
  }

  static void showAddPageDialog(BuildContext context, AppLocalizations locale,
      String initialName, Function(String) onSubmitted) {
    final GlobalKey<PageFormWidgetState> pageFormKey =
        GlobalKey<PageFormWidgetState>();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          insetPadding: const EdgeInsets.all(16.0),
          title: Text(locale.addPage),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PageFormWidget(
                  key: pageFormKey,
                  initialName: initialName,
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
                  if (pageFormKey.currentState!.validateAndSave()) {
                    Navigator.pop(context);
                    onSubmitted(pageFormKey.currentState!.name);
                  }
                },
                child: ActionButtonText(text: locale.add))
          ],
        );
      },
    );
  }
}

class PageFormWidgetState extends State<PageFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  late TextEditingController _controller;

  bool validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName)
      ..selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.initialName.length,
      );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    // widget.builder.call(context, _submit);
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              controller: _controller,
              // initialValue: widget.initialName,
              autofocus: true,
              onSaved: (String? value) => {name = value!},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.nameError;
                }

                if (value.length > PageModel.maxNameLength) {
                  return locale.nameLengthError(PageModel.maxNameLength);
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
