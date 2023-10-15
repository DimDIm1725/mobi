import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MobiLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
  }
}

class MobiButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final bool roundedCorners;

  MobiButton({
    @required this.text,
    @required this.onPressed,
    this.padding,
    this.color,
    this.textColor,
    this.borderColor,
    this.roundedCorners = true,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: roundedCorners
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: borderColor ?? color ?? MobiTheme.nearlyBlue,
              ),
            )
          : null,
      color: color ?? MobiTheme.nearlyBlue,
      child: Center(
        child: Padding(
          padding: padding ?? EdgeInsets.all(0),
          child: Text(
            text.toUpperCase(),
            style: Theme.of(context)
                .primaryTextTheme
                .button
                .copyWith(color: textColor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}

class MobiTextFormField extends StatelessWidget {
  final Function onChanged;
  final Function onTap;
  final String label;
  final Widget prefixIcon;
  final String initialValue;
  final bool readOnly;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLength;
  final bool obscureText;

  const MobiTextFormField({
    this.label,
    this.onChanged,
    this.prefixIcon,
    this.onTap,
    this.initialValue,
    this.readOnly,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        onChanged: onChanged,
        onTap: onTap,
        maxLength: maxLength,
        keyboardType: keyboardType ?? TextInputType.text,
        initialValue: initialValue,
        controller: controller,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          // enabledBorder: OutlineInputBorder(),
          // focusedBorder: OutlineInputBorder(
          //     borderSide: BorderSide(color: MobiTheme.nearlyBlue)),
          labelText: label,
          prefixIcon: prefixIcon,
          counterText: maxLength != null ? "" : null,
          // labelStyle: TextStyle(color: Colors.grey[700]),
        ),
        obscureText: obscureText ?? false,
      ),
    );
  }
}

class MobiTextFormFieldLight extends StatelessWidget {
  final Function onChanged;
  final Function onTap;
  final String label;
  final Widget prefixIcon;
  final String initialValue;
  final bool readOnly;
  final TextEditingController controller;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextStyle style;
  final bool filled;
  final Color fillColor;

  const MobiTextFormFieldLight({
    this.label,
    this.onChanged,
    this.prefixIcon,
    this.onTap,
    this.obscureText = false,
    this.initialValue,
    this.style,
    this.readOnly,
    this.controller,
    this.textAlign,
    this.keyboardType,
    this.filled,
    this.fillColor = Colors.white54,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.white,
      ),
      child: TextFormField(
        obscureText: obscureText,
        textAlign: textAlign ?? TextAlign.left,
        style: style ?? TextStyle(color: Colors.white, fontSize: 20),
        onChanged: onChanged,
        onTap: onTap,
        initialValue: initialValue,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon,
          labelStyle: TextStyle(color: Colors.white),
          // filled: filled,
          // fillColor: fillColor,
        ),
      ),
    );
  }
}

class MobiText extends StatelessWidget {
  final String text;
  final Widget prefixIcon;
  final TextStyle textStyle;
  final TextOverflow textOverflow;
  final double iconGapWidth;
  final Function onTap;

  const MobiText(
      {@required this.text,
      this.prefixIcon,
      this.textStyle,
      this.iconGapWidth = 30,
      this.textOverflow = TextOverflow.visible,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List<Widget>();
    if (prefixIcon != null) {
      children.add(prefixIcon);
      children.add(SizedBox(
        width: iconGapWidth,
      ));
    }

    children.add(Flexible(
      fit: FlexFit.loose,
      child: Text(
        text,
        overflow: textOverflow,
        softWrap: true,
        style: this.textStyle ?? TextStyle(fontSize: 20),
      ),
    ));
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.black,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveLayout({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class MobiDropDown extends StatelessWidget {
  final String hint;
  final Function onChanged;
  final List<DropdownMenuItem<Object>> items;
  final Object value;
  final Icon prefixIcon;
  final bool isDense;
  final double contentPadding;
  final Color textColor;

  MobiDropDown(
      {this.hint,
      @required this.onChanged,
      @required this.items,
      @required this.value,
      this.isDense = true,
      this.prefixIcon,
      this.contentPadding = 0,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      isDense: isDense,
      value: value,
      style: TextStyle(color: textColor),
      iconEnabledColor: textColor,
      dropdownColor: MobiTheme.colorPrimary,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: hint,
        labelStyle: TextStyle(color: textColor),
        contentPadding: EdgeInsets.all(contentPadding),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MobiTheme.nearlyBlue, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      onChanged: onChanged,
      items: items,
    );
  }
}

TextStyle getCustomStyle(context,
    {Color color = Colors.black, double textSize = 15}) {
//  if (textSize > 20) {
//    return Theme.of(context).primaryTextTheme.headline3.copyWith(color: color);
//  } else {
//    return Theme.of(context).primaryTextTheme.headline6.copyWith(color: color);
//  }
  return TextStyle(color: color, fontSize: textSize);

//  TextStyle kMyStyle = TextStyle(fontSize: textSize, color: color);
//  return kMyStyle;
}
