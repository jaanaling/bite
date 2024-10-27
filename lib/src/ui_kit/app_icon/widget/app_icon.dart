import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  final String asset;
  final Color? color;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppIcon({
    super.key,
    required this.asset,
    this.color,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return asset.contains('.svg')
        ? Opacity(
            opacity: 0.97,
            child: SvgPicture.asset(
              asset,
              width: width,
              height: height,
              fit: fit,
              allowDrawingOutsideViewBox: true,
              colorFilter: color != null
                  ? ColorFilter.mode(
                      color!,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
          )
        : Image.asset(
            asset,
            width: width,
            height: height,
            fit: fit,
          );
  }
}
