import 'package:flutter/material.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

/// أقصى عرض منطقي للمحتوى على الشاشات الكبيرة (زي 1880px وأكبر)
/// عشان النص والعناصر ميفضلوش يتمططوا مع عرض الشاشة كله
const double kMaxContentWidth = 1440.0;

/// Breakpoints بسيطة لتحديد نوع الجهاز بناءً على عرض الشاشة
enum DeviceType { mobile, tablet, desktop, largeDesktop }

DeviceType getDeviceType(double width) {
  if (width < 600) return DeviceType.mobile;
  if (width < 1024) return DeviceType.tablet;
  if (width < 1600) return DeviceType.desktop;
  return DeviceType.largeDesktop;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [const HeroBanner()]),
        ),
      ),
    );
  }
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final deviceType = getDeviceType(width);
        final screenHeight = MediaQuery.of(context).size.height;

        // ارتفاع البانر يختلف حسب الجهاز
        final bannerHeight = switch (deviceType) {
          DeviceType.mobile => screenHeight * 0.45,
          DeviceType.tablet => screenHeight * 0.6,
          DeviceType.desktop => screenHeight * 0.7,
          DeviceType.largeDesktop => screenHeight * 0.75,
        };

        // مقاسات الخط تختلف حسب الجهاز
        final titleSize = switch (deviceType) {
          DeviceType.mobile => 22.0,
          DeviceType.tablet => 34.0,
          DeviceType.desktop => 48.0,
          DeviceType.largeDesktop => 56.0,
        };

        final subtitleSize = switch (deviceType) {
          DeviceType.mobile => 12.0,
          DeviceType.tablet => 15.0,
          DeviceType.desktop => 16.0,
          DeviceType.largeDesktop => 18.0,
        };

        // البادينج الجانبي: على الشاشات الكبيرة جدًا (largeDesktop) بيتحسب
        // ديناميكيًا عشان يحافظ على أقصى عرض منطقي للمحتوى (kMaxContentWidth)
        // بدل ما الفراغ يفضل يكبر بلا حدود مع عرض الشاشة
        final horizontalPadding = deviceType == DeviceType.largeDesktop
            ? ((width - kMaxContentWidth) / 2) + 80.0
            : switch (deviceType) {
                DeviceType.mobile => 16.0,
                DeviceType.tablet => 40.0,
                DeviceType.desktop => 80.0,
                DeviceType.largeDesktop => 80.0, // لن يُستخدم أبدًا هنا
              };

        final topPadding = switch (deviceType) {
          DeviceType.mobile => 24.0,
          DeviceType.tablet => 40.0,
          DeviceType.desktop => 60.0,
          DeviceType.largeDesktop => 60.0,
        };

        // عرض بلوك النص: من 1600 وطالع بيبقى عرض ثابت بدل نسبة
        // عشان الأسطر ما تتمططش وتبقى وحشة على الشاشات العريضة جدًا
        final textMaxWidth = switch (deviceType) {
          DeviceType.mobile => width * 0.85,
          DeviceType.tablet => width * 0.6,
          DeviceType.desktop => width * 0.4,
          DeviceType.largeDesktop => 560.0,
        };

        return  Stack(
          children: [
            AppImage.asset(
              "assets/images/banner.jpg",
              width: double.infinity,
              height: bannerHeight,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: bannerHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.black26, Colors.black],
                ),
              ),
            ),
            Positioned(
              top: topPadding,
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: topPadding,
              child: Align(
                alignment: deviceType == DeviceType.mobile
                    ? Alignment.bottomLeft
                    : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: textMaxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "WEAR YOUR TREASURES.",
                        style: AppTextStyles.text10Bold.copyWith(
                          color: Colors.white,
                          fontSize: titleSize,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(
                        height: deviceType == DeviceType.mobile ? 8 : 16,
                      ),
                      Text(
                        "Luxury fragrances crafted to leave a lasting impression.",
                        style: AppTextStyles.text10Bold.copyWith(
                          color: Colors.white70,
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
