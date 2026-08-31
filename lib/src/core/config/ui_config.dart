class UiConfig {
  static late UiConfig instance;
  final String logo;
  final String  logoWithoutBackground;
  final String bgImage;
  final List<String> bannerImages;

  UiConfig({
    required this.logo,
    required this.logoWithoutBackground,
    required this.bgImage,
    required this.bannerImages,
  });
}
