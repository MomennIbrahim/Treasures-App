import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';

class CustomRatingWidget extends StatelessWidget {
  final double initialRating;
  final bool readOnly;
  const CustomRatingWidget({
    super.key,
    required this.initialRating,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating,
      itemSize: 16.sp,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: readOnly,
      itemCount: 5,
      itemPadding: paddingHorizontal(2.0),
      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (rating) {},
    );
  }
}
