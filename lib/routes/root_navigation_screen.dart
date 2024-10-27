import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class RootNavigationScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RootNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<RootNavigationScreen> createState() => _RootNavigationScreenState();
}

class _RootNavigationScreenState extends State<RootNavigationScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(child: widget.navigationShell),
        ],
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      currentIndex = index;
    });
    widget.navigationShell.goBranch(
      index,
      initialLocation: true,
    );
  }
}
