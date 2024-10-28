enum IconProvider {
  splash(imageName: 'splash.png'),
  cocoa(imageName: 'cocoa.svg'),
  egg(imageName: 'egg.svg'),
  fish(imageName: 'fish.svg'),
  gluten(imageName: 'gluten.svg'),
  meat(imageName: 'meat.svg'),
  nuts(imageName: 'nuts.svg'),
  dairy(imageName: 'soy.svg'),
  hot(imageName: 'hot.svg'),
  veg(imageName: 'veg.svg'),
  c(imageName: 'choose.svg'),

  unknown(imageName: '');

  const IconProvider({
    required this.imageName,
  });

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name';
}
