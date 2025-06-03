import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scored/l10n/app_localizations.dart';

import 'action_button_text.dart';

class PointsFormWidget extends StatefulWidget {
  final int initialPoints;

  const PointsFormWidget({super.key, required this.initialPoints}) : super();

  @override
  PointsFormWidgetState createState() {
    return PointsFormWidgetState();
  }

  static void showPointsDialog(
      BuildContext context,
      int initialPoints,
      AppLocalizations locale,
      String title,
      String confirm,
      Function(int score) onSubmitted) {
    final GlobalKey<PointsFormWidgetState> pointsFormKey =
        GlobalKey<PointsFormWidgetState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                actionsPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                insetPadding: const EdgeInsets.all(16.0),
                title: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      PointsFormWidget(
                        key: pointsFormKey,
                        initialPoints: initialPoints,
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
                        if (pointsFormKey.currentState!.validateAndSave()) {
                          Navigator.pop(context);
                          onSubmitted(pointsFormKey.currentState!.score);
                        }
                      },
                      child: ActionButtonText(text: confirm))
                ],
              ),
            ),
          );
        });
  }
}

class PointsFormWidgetState extends State<PointsFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  late FocusNode _focusNode;

  final _pointsRegex = RegExp(r'^-?[0-9]*');

  int score = 0;

  bool validateAndSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (int.tryParse(_controller.value.text) == null) {
        return false;
      }
      score = int.parse(_controller.value.text);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }

    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPoints.toString())
      ..selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.initialPoints.toString().length,
      );
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(_pointsRegex)
            ],
            keyboardType: const TextInputType.numberWithOptions(
                decimal: false, signed: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return locale.pointsError;
              }

              if (!_pointsRegex.hasMatch(value) || value == "-") {
                return locale.scoreInvalidError;
              }

              int max = 5;

              if (widget.initialPoints != 0) {
                max = widget.initialPoints.toString().length;
                if (widget.initialPoints < 0) {
                  max = max - 1;
                }
              }

              // Numbers can be the initial amount of digits (excluding the sign)
              if (value.contains("-")) {
                if (value.length > max + 1) {
                  return locale.pointsLengthError(max);
                }
              } else {
                if (value.length > max) {
                  return locale.pointsLengthError(max);
                }
              }

              return null;
            },
            decoration: InputDecoration(
              filled: false,
              prefixIcon: const Icon(Icons.score),
              border: const OutlineInputBorder(),
              helperText: "",
              labelText: locale.points,
            ),
          ),
        ],
      ),
    );
  }
}
