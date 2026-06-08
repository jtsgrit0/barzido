import '../platform/app_platform.dart';

enum AppMapImplementation {
  google,
  web,
  desktopMock,
}

AppMapImplementation resolveMapImplementation(AppPlatform platform) {
  return switch (platform) {
    AppPlatform.android || AppPlatform.ios => AppMapImplementation.google,
    AppPlatform.web => AppMapImplementation.web,
    AppPlatform.macos => AppMapImplementation.desktopMock,
    _ => AppMapImplementation.desktopMock,
  };
}