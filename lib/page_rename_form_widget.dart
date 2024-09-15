import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'models/page_model.dart';

typedef PageRenameFormBuilder = void Function(
    BuildContext context, PageModel? Function() submitFunction,);

class PageRenameFormWidget extends StatefulWidget {
  const PageRenameFormWidget({super.key, required this.builder, required this.baseModel});

  final PageRenameFormBuilder builder;
  final PageModel baseModel;

  @override
  PageRenameFormWidgetState createState() {
    return PageRenameFormWidgetState();
  }
}

class PageRenameFormWidgetState extends State<PageRenameFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = "";

  PageModel? _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return PageModel(id: widget.baseModel.id, name: name, order: widget.baseModel.order);
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
