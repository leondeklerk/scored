import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                child: Text(locale.cancel)),
            TextButton(
                onPressed: () {
                  if (pageFormKey.currentState!.validateAndSave()) {
                    Navigator.pop(context);
                    onSubmitted(pageFormKey.currentState!.name);
                  }
                },
                child: Text(locale.add))
          ],
        );
      },
    );
  }
}

class PageFormWidgetState extends State<PageFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = "";

  bool validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
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
              initialValue: widget.initialName,
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
