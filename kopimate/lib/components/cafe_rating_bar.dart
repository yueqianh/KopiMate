import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CafeRatingBar extends StatelessWidget {
  const CafeRatingBar(
      {required Key key,
      required this.initialRating,
      this.itemSize = 40,
      this.ignoreGestures = false,
      required this.onRatingUpdate})
      : super(key: key);
  final double initialRating;
  final bool ignoreGestures;
  final double itemSize;
  final ValueChanged<double> onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating,
      ignoreGestures: ignoreGestures,
      glow: false,
      allowHalfRating: true,
      itemSize: itemSize,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: onRatingUpdate,
    );
  }
}