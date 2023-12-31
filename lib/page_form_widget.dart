import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef PageFormBuilder = void Function(
    BuildContext context, String? Function() submitFunction);

class PageFormWidget extends StatefulWidget {
  const PageFormWidget({super.key, required this.builder, required this.initialName});

  final PageFormBuilder builder;
  final String initialName;

  @override
  PageFormWidgetState createState() {
    return PageFormWidgetState();
  }
}

class PageFormWidgetState extends State<PageFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = "";

  String? _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return name;
    }
    return null;
  }


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
