import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Disk cache for remote images.
///
/// Every image is downloaded once and then stored on the phone. On the next
/// launches (and offline) the file is read from local storage instead of the
/// network, which is what makes the app fast on mobile data.
class HasadImageCache {
  HasadImageCache._();

  static const String cacheKey = 'hasad_images';

  /// Images are considered fresh for a year and we keep up to 800 files, so a
  /// machine photo is downloaded once per install, not once per screen.
  static final CacheManager manager = CacheManager(
    Config(
      cacheKey,
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 800,
    ),
  );
}

/// Returns a cached image provider (memory -> disk -> network).
ImageProvider appImageProvider(String url) => CachedNetworkImageProvider(
      url,
      cacheManager: HasadImageCache.manager,
    );

/// Drop-in replacement for `Image.network(...)` that stores the image on disk.
///
/// It accepts the same parameters the app was already using so call sites keep
/// working unchanged apart from the constructor name.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.medium,
    this.gaplessPlayback = false,
    this.errorBuilder,
    this.loadingBuilder,
    this.frameBuilder,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final FilterQuality filterQuality;
  final bool gaplessPlayback;
  final ImageErrorWidgetBuilder? errorBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageFrameBuilder? frameBuilder;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return errorBuilder?.call(context, '', StackTrace.current) ??
          const SizedBox.shrink();
    }

    return Image(
      image: appImageProvider(url),
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      repeat: repeat,
      filterQuality: filterQuality,
      gaplessPlayback: gaplessPlayback,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      frameBuilder: frameBuilder,
    );
  }
}
