enum RouteValue {
  splash(
    path: '/',
  ),
  home(
    path: '/home',
  ),
  recipe(
    path: 'recipe',
  ),
    list(
    path: 'list',
  ),
  unknown(
    path: '',
  );

  final String path;

  const RouteValue({
    required this.path,
  });
}
