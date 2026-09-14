import 'package:flutter/material.dart';

class AppRichText extends StatelessWidget {
  final String normalText;
  final String actionText;
  final VoidCallback? onTap;
  final TextStyle? normalStyle;
  final TextStyle? actionStyle;

  const AppRichText({
    super.key,
    required this.normalText,
    required this.actionText,
    this.onTap,
    this.normalStyle,
    this.actionStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: normalText,
        style: normalStyle,
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: onTap ?? () {},
              child: Text(actionText, style: actionStyle),
            ),
          ),
        ],
      ),
    );
  }
}
