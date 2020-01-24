import 'package:flutter/material.dart';
import 'package:robocon_2020_timer/widget/opacity_transtition.dart';

class OpacityHero extends StatelessWidget {
  /// Create a hero which will animate to destination hero's radius.
  ///
  /// The [tag], [child] and [radius] parameters must not be null.
  /// The [child] parameter and all of the its descendants must not be [Hero]es.
  ///
  const OpacityHero(
      {Key key,
      @required this.tag,
      @required this.child,
      @required this.opacity,
      this.createRectTween,
      this.placeholderBuilder,
      this.transitionOnUserGestures = false,
      this.flightShuttleBuilder})
      : super(key: key);

  /// Same as hero's tag.
  final Object tag;

  /// Same as hero's child.
  final Widget child;
  final double opacity;

  /// Same as hero's createRectTween.
  final CreateRectTween createRectTween;

  /// Same as hero's placeholderBuilder.
  final HeroPlaceholderBuilder placeholderBuilder;

  /// Same as hero's transitionOnUserGestures.
  final bool transitionOnUserGestures;

  /// To override radius animation, provide a flightShuttleBuilder.
  final HeroFlightShuttleBuilder flightShuttleBuilder;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: tag,
        createRectTween: createRectTween,
        placeholderBuilder: placeholderBuilder,
        transitionOnUserGestures: transitionOnUserGestures,
        flightShuttleBuilder: flightShuttleBuilder != null
            ? flightShuttleBuilder
            : (context, animation, direction, startContext, endContext) {
                double anotherHeroOpacity = startContext
                    .findAncestorWidgetOfExactType<OpacityHero>()
                    .opacity;
                Animation<double> radiusAnimation =
                    (direction == HeroFlightDirection.pop)
                        ? animation.drive<double>(
                            Tween(begin: opacity, end: anotherHeroOpacity))
                        : animation.drive<double>(
                            Tween(begin: anotherHeroOpacity, end: opacity));
                return OpacityTranstition(
                  animation: radiusAnimation,
                  child: child,
                );
              },
        child: Opacity(
          child: child,
          opacity: opacity,
        ));
  }
}
