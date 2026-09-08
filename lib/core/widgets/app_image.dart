import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum AppImageType { asset, svg, network, cachedNetwork, file }

class AppImage extends StatelessWidget {
  const AppImage.asset(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
  }) : file = null,
       type = AppImageType.asset;

  const AppImage.svg(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.borderRadius,
  }) : file = null,
       type = AppImageType.svg;

  const AppImage.network(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
  }) : file = null,
       type = AppImageType.network;

  const AppImage.cachedNetwork(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
  }) : file = null,
       type = AppImageType.cachedNetwork;

  const AppImage.file(
    this.file, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
  }) : path = '',
       type = AppImageType.file;

  final AppImageType type;
  final String path;
  final File? file;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget image;

    switch (type) {
      case AppImageType.asset:
        image = Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          color: color,
          errorBuilder: (context, object, stackTrace) => const _ImageError(),
        );
        break;

      case AppImageType.svg:
        image = SvgPicture.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color!, BlendMode.srcIn),
        );
        break;

      case AppImageType.network:
        image = Image.network(
          path,
          width: width,
          height: height,
          fit: fit,
          color: color,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (_, _, _) => const _ImageError(),
        );
        break;

      case AppImageType.cachedNetwork:
        image = CachedNetworkImage(
          imageUrl: path,
          width: width,
          height: height,
          fit: fit,
          errorWidget: (_, _, _) => const _ImageError(),
          placeholder: (_, _) => SizedBox.shrink(),
        );
        break;

      case AppImageType.file:
        image = Image.file(
          file!,
          width: width,
          height: height,
          fit: fit,
          color: color,
          errorBuilder: (_, _, _) => const _ImageError(),
        );
        break;
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.broken_image_outlined,
      size: 40.0.sp,
      color: AppColors.neutral500,
    );
  }
}
