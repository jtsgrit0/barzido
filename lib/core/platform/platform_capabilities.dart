import 'app_platform.dart';

class PlatformCapabilities {
  const PlatformCapabilities({
    required this.platform,
    required this.supportsNativeGoogleMap,
    required this.supportsLocationPermission,
    required this.prefersMockMap,
  });

  final AppPlatform platform;
  final bool supportsNativeGoogleMap;
  final bool supportsLocationPermission;
  final bool prefersMockMap;

  factory PlatformCapabilities.forPlatform(AppPlatform platform) {
    return switch (platform) {
      AppPlatform.android || AppPlatform.ios => PlatformCapabilities(
          platform: platform,
          supportsNativeGoogleMap: true,
          supportsLocationPermission: true,
          prefersMockMap: false,
        ),
      AppPlatform.macos => const PlatformCapabilities(
          platform: AppPlatform.macos,
          supportsNativeGoogleMap: false,
          supportsLocationPermission: true,
          prefersMockMap: true,
        ),
      AppPlatform.web => const PlatformCapabilities(
          platform: AppPlatform.web,
          supportsNativeGoogleMap: false,
          supportsLocationPermission: true,
          prefersMockMap: false,
        ),
      _ => PlatformCapabilities(
          platform: platform,
          supportsNativeGoogleMap: false,
          supportsLocationPermission: false,
          prefersMockMap: true,
        ),
    };
  }
}