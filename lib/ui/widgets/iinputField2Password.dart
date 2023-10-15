import 'package:flutter/material.dart';

class IInputField2Password extends StatefulWidget {
  final String hint;
  final IconData icon;
  final Function(String) onChangeText;
  final TextEditingController controller;
  final TextInputType type;
  final Color colorDefaultText;
  final Color colorBackground;
  final Color colorIcon;
  IInputField2Password({this.hint, this.icon, this.controller, this.type, this.colorDefaultText, this.colorBackground, this.colorIcon,
    this.onChangeText});

  @override
  _IInputField2PasswordState createState() => _IInputField2PasswordState();
}

class _IInputField2PasswordState extends State<IInputField2Password> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    Color _colorDefaultText = Colors.black;
    if (widget.colorDefaultText != null)
      _colorDefaultText = widget.colorDefaultText;
    var _sicon = Icon(widget.icon, color: widget.colorIcon);

    var _icon = Icons.visibility_off;
    if (!_obscureText)
      _icon = Icons.visibility;

    var _sicon2 = IconButton(
      iconSize: 20,
      icon: Icon(
        _icon, //_icon,
        color: widget.colorIcon,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );

    return Container(

      child: new TextFormField(
        obscureText: _obscureText,
        keyboardType: widget.type,
        controller: widget.controller,
        onChanged: (String value) async {
          if (widget.onChangeText != null)
            widget.onChangeText(value);
        },
        cursorColor: _colorDefaultText,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: _colorDefaultText,
          fontSize:20,
        ),
        decoration: new InputDecoration(
          prefixIcon: _sicon,
          suffixIcon: _sicon2,
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: _colorDefaultText,
              fontSize: 16.0),
        ),
      ),
      decoration:  BoxDecoration(
        color: Color.fromARGB(50,0,0,0),
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(50,0,0,0), blurRadius: 1.0, spreadRadius: 0.4)
      ]),
    );
  }
}