import 'package:flutter/material.dart';

class OpacityTranstition extends AnimatedWidget {
  /// Create an animated widget which can animate widget circular border.
  ///
  /// [child] and [listenable] parameters must not be null.
  ///
  const OpacityTranstition({Key key, this.child, Animation<double> animation})
      : super(key: key, listenable: animation);

  @required
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Opacity(
      child: child,
      opacity: animation.value,
    );
  }
}
