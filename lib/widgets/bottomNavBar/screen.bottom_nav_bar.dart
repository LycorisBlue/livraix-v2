part of 'widget.bottom_nav_bar.dart';

class CustomerBottomNavigationScreen extends StatefulWidget {
  final StatefulNavigationShell shell;

  const CustomerBottomNavigationScreen({super.key, required this.shell});

  @override
  State<CustomerBottomNavigationScreen> createState() => _CustomerBottomNavigationScreenState();

  static String _formatInitialRoute(String route) {
    if (route.startsWith('//')) {
      route = route.substring(1);
    }
    print(route);
    return route.isNotEmpty ? route : HomeScreen.path;
  }
}

class _CustomerBottomNavigationScreenState extends State<CustomerBottomNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      body: widget.shell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: theme.colorScheme.primary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              color: Colors.grey,
              tabs: const [
                GButton(
                  icon: CupertinoIcons.home,
                  text: 'Accueil',
                ),
                GButton(
                  icon: CupertinoIcons.creditcard,
                  text: 'Gains',
                ),
                GButton(
                  icon: CupertinoIcons.time,
                  text: 'Historique',
                ),
                GButton(
                  icon: CupertinoIcons.chat_bubble,
                  text: 'Discussion',
                ),
                GButton(
                  icon: CupertinoIcons.person,
                  text: 'Profil',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                widget.shell.goBranch(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
