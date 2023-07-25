import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef PointsFormBuilder = void Function(
    BuildContext context, int? Function() submitFunction);

class PointsFormWidget extends StatefulWidget {
  const PointsFormWidget({super.key, required this.builder});

  final PointsFormBuilder builder;

  @override
  PointsFormWidgetState createState() {
    return PointsFormWidgetState();
  }
}

class PointsFormWidgetState extends State<PointsFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _controller = TextEditingController(text: "0");

  final _pointsRegex = RegExp(r'^-?[0-9]*');

  int? _submit() {
    if (_formKey.currentState!.validate()) {
      return int.parse(_controller.value.text);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    widget.builder.call(context, _submit);
    _controller.selection = TextSelection(
        baseOffset: 0, extentOffset: _controller.value.text.length);
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controller,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(_pointsRegex)
            ],
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return locale.pointsError;
              }

              if (!_pointsRegex.hasMatch(value) || value == "-") {
                return locale.scoreInvalidError;
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
