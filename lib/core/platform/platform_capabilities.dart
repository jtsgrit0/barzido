import 'app_platform.dart';

class PlatformCapabilities {
  const PlatformCapabilities({
    required this.platform,
    required this.supportsNativeNaverMap,
    required this.supportsLocationPermission,
    required this.prefersMockMap,
  });

  final AppPlatform platform;
  final bool supportsNativeNaverMap;
  final bool supportsLocationPermission;
  final bool prefersMockMap;

  factory PlatformCapabilities.forPlatform(AppPlatform platform) {
    return switch (platform) {
      AppPlatform.android || AppPlatform.ios => PlatformCapabilities(
          platform: platform,
          supportsNativeNaverMap: true,
          supportsLocationPermission: true,
          prefersMockMap: false,
        ),
      AppPlatform.macos => const PlatformCapabilities(
          platform: AppPlatform.macos,
          supportsNativeNaverMap: false,
          supportsLocationPermission: true,
          prefersMockMap: true,
        ),
      AppPlatform.web => const PlatformCapabilities(
          platform: AppPlatform.web,
          supportsNativeNaverMap: false,
          supportsLocationPermission: true,
          prefersMockMap: false,
        ),
      _ => PlatformCapabilities(
          platform: platform,
          supportsNativeNaverMap: false,
          supportsLocationPermission: false,
          prefersMockMap: true,
        ),
    };
  }
}
