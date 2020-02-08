import 'package:flutter/material.dart';

class WOutlineButton extends StatelessWidget {
  @required
  final Function onPressed;
  @required
  final Widget child;
  const WOutlineButton(
      {Key key, @required this.onPressed, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
        highlightedBorderColor: Colors.white,
        borderSide: BorderSide(color: Colors.white, width: 2.0),
        onPressed: onPressed,
        child: child,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)));
  }
}
