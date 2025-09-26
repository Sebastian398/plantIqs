import 'package:flutter/material.dart';

class ThemedLogo extends StatelessWidget{
  final double width;
  final double? height;

  const ThemedLogo ({super.key, this.width = 200, this.height});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context). brightness == Brightness.dark;

    return Image.asset(
      isDark
        ?'assets/images/Logo_dark.png'
        :'assets/images/Logo_light.png',
      width: width,
      height: height,
    );
  }
}