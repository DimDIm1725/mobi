import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//
// ver 2.0 - 29/09/2020
//

class IInputField2 extends StatefulWidget {
  final String hint;
  final IconData icon;
  final IconData iconRight;
  final Function onPressRightIcon;
  final Function(String) onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color colorDefaultText;
  final Color colorBackground;
  final Color colorIcon;
  final String initialValue;
  final bool readOnly;
  final Function onTap;
  final int maxLength;

  IInputField2(
      {this.hint,
      this.icon,
      this.controller,
      this.type,
      this.colorDefaultText,
      this.colorBackground,
      this.colorIcon,
      this.iconRight,
      this.onPressRightIcon,
      this.onChangeText,
      this.initialValue,
      this.readOnly,
      this.maxLength,
      this.onTap});

  @override
  _IInputField2State createState() => _IInputField2State();
}

class _IInputField2State extends State<IInputField2> {
  @override
  Widget build(BuildContext context) {
    Color _colorDefaultText = Colors.black;
    if (widget.colorDefaultText != null)
      _colorDefaultText = widget.colorDefaultText;
    Widget _sicon = Icon(
      widget.icon,
      color: widget.colorIcon,
    );
    if (widget.icon == null) _sicon = null;

    var _sicon2;
    if (widget.iconRight != null)
      _sicon2 = InkWell(
          onTap: () {
            if (widget.onPressRightIcon != null) widget.onPressRightIcon();
          }, // needed
          child: Icon(
            widget.iconRight,
            color: _colorDefaultText,
          ));

    return Container(
      child: new TextFormField(
        keyboardType: widget.type,
        initialValue: widget.initialValue,
        readOnly: widget.readOnly ?? false,
        cursorColor: _colorDefaultText,
        controller: widget.controller,
        onTap: widget.onTap,
        maxLength: widget.maxLength,
        onChanged: (String value) async {
          if (widget.onChangeText != null) widget.onChangeText(value);
        },
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: _colorDefaultText,
          fontSize: 20,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp("[\"]")),
        ],
        decoration: new InputDecoration(
          prefixIcon: _sicon,
          suffixIcon: _sicon2,
          border: InputBorder.none,
          counterText: widget.maxLength != null ? "" : null,
          hintText: widget.hint,
          hintStyle: TextStyle(color: _colorDefaultText, fontSize: 16.0),
        ),
      ),
      decoration: BoxDecoration(
          color: Color.fromARGB(50, 0, 0, 0),
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(50, 0, 0, 0),
                blurRadius: 1.0,
                spreadRadius: 0.4)
          ]),
    );
  }
}
