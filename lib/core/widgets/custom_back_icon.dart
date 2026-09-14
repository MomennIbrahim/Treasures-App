import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackIcon extends StatelessWidget {
  final Color? color;
  const CustomBackIcon({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: InkWell(
        onTap: () => context.pop(),
        child: Icon(Icons.arrow_back, color: color ?? colorScheme.onSurface),
      ),
    );
  }
}
