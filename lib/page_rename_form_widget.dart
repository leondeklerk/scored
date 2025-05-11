import 'package:flutter/material.dart';
import 'package:scored/l10n/app_localizations.dart';

import 'action_button_text.dart';
import 'models/page_model.dart';

class PageRenameFormWidget extends StatefulWidget {
  const PageRenameFormWidget({super.key, required this.baseModel});

  final PageModel baseModel;

  @override
  PageRenameFormWidgetState createState() {
    return PageRenameFormWidgetState();
  }

  static void showPageRenameDialog(
      BuildContext context,
      AppLocalizations locale,
      PageModel startModel,
      Function(PageModel) onSubmitted) {
    final GlobalKey<PageRenameFormWidgetState> pageKey =
        GlobalKey<PageRenameFormWidgetState>();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          insetPadding: const EdgeInsets.all(16.0),
          title: Text(locale.renamePage),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PageRenameFormWidget(
                  key: pageKey,
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
                  if (pageKey.currentState!.validateAndSave()) {
                    Navigator.pop(context);
                    onSubmitted(pageKey.currentState!.getResult());
                  }
                },
                child: ActionButtonText(text: locale.rename))
          ],
        );
      },
    );
  }
}

class PageRenameFormWidgetState extends State<PageRenameFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = "";

  bool validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  PageModel getResult() {
    return PageModel(
        id: widget.baseModel.id,
        name: name,
        order: widget.baseModel.order,
        currentRound: widget.baseModel.currentRound);
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
