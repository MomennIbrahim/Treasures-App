import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

EdgeInsetsGeometry paddingAll(double value) => EdgeInsets.all(value.toDouble());

EdgeInsetsGeometry paddingSymmetric(double horizontal, double vertical) =>
    EdgeInsets.symmetric(
      horizontal: horizontal.toDouble().w,
      vertical: vertical.toDouble().h,
    );

EdgeInsetsGeometry paddingHorizontal(double value) =>
    EdgeInsets.symmetric(horizontal: value.toDouble().w);
EdgeInsetsGeometry paddingVertical(double value) =>
    EdgeInsets.symmetric(vertical: value.toDouble().h);

EdgeInsetsGeometry paddingOnly({
  double left = 0.0,
  double top = 0.0,
  double right = 0.0,
  double bottom = 0.0,
}) => EdgeInsets.fromLTRB(
  left.toDouble().w,
  top.toDouble().h,
  right.toDouble().w,
  bottom.toDouble().h,
);
