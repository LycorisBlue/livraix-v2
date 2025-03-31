import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livraix/widgets/account/personal_info/widget.personal_info.dart';
import 'package:livraix/widgets/account/widget.account.dart';
import 'package:livraix/widgets/authentication/forgot_password/widget.forgot_password.dart';
import 'package:livraix/widgets/authentication/login/widget.login.dart';
import 'package:livraix/widgets/authentication/signup/widget.signup.dart';
import 'package:livraix/widgets/bottomNavBar/widget.bottom_nav_bar.dart';
import 'package:livraix/widgets/chat/widget.chat.dart';
import 'package:livraix/widgets/contrat/widget.contract_details.dart';
import 'package:livraix/widgets/dashboards/widget.dashboard.dart';
import 'package:livraix/widgets/email_verification/widget.email_verification.dart';
import 'package:livraix/widgets/history/widget.history.dart';
import 'package:livraix/widgets/home/widget.home.dart';
import 'package:livraix/widgets/notifications/widget.notifications.dart';
import 'package:livraix/widgets/welcome/widget.welcome.dart';
import 'package:livraix/widgets/splash/widget.splash.dart';

class AppRouter {
  final String initialRoute;

  AppRouter({required this.initialRoute});

  GoRouter get router {
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: _formatInitialRoute(initialRoute),
      observers: [GoRouterObserver()],
      routes: <RouteBase>[
        GoRoute(
          path: WelcomeScreen.path,
          name: WelcomeScreen.name,
          builder: (BuildContext context, GoRouterState state) {
            return const WelcomeScreen();
          },
        ),
        GoRoute(
          path: EmailVerificationScreen.path,
          name: EmailVerificationScreen.name,
          builder: (BuildContext context, GoRouterState state) {
            // Récupérer l'email depuis les paramètres de l'état de la route
            final email = state.extra as String? ?? '';
            return EmailVerificationScreen(email: email);
          },
        ),
        GoRoute(
          path: LoginScreen.path,
          name: LoginScreen.name,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
          routes: [],
        ),
        GoRoute(
          path: SplashScreen.path,
          name: SplashScreen.name,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),

        GoRoute(
          path: ContractDetailsScreen.path,
          name: ContractDetailsScreen.name,
          builder: (BuildContext context, GoRouterState state) {
            return const ContractDetailsScreen();
          },
        ),

        GoRoute(
          path: SignupScreen.path,
          name: SignupScreen.name,
          builder: (BuildContext context, GoRouterState state) {
            return const SignupScreen();
          },
        ),

        GoRoute(
            path: ForgotPasswordScreen.path,
            name: ForgotPasswordScreen.name,
            builder: (BuildContext context, GoRouterState state) {
              return const ForgotPasswordScreen();
            }),

        // ==> SHELLROUTE CLIENT

        StatefulShellRoute(
          navigatorContainerBuilder: (BuildContext context, StatefulNavigationShell navigationShell, List<Widget> children) {
            return ScaffoldWithNavigation(navigationShell: navigationShell, children: children);
          },
          builder: (BuildContext context, GoRouterState state, StatefulNavigationShell shell) {
            return CustomerBottomNavigationScreen(shell: shell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: HomeScreen.path, // Route pour le Dashboard
                  name: HomeScreen.name,
                  builder: (BuildContext context, GoRouterState state) {
                    return const HomeScreen(); // First screen in BottomNavigationGerant
                  },
                  routes: [
                    GoRoute(
                        path: NotificationScreen.path,
                        name: NotificationScreen.name,
                        builder: (BuildContext context, GoRouterState state) {
                          return const NotificationScreen();
                        }),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                    path: DashboardScreen.path,
                    name: DashboardScreen.name,
                    builder: (BuildContext context, GoRouterState state) {
                      return const DashboardScreen();
                    }),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                    path: HistoryScreen.path,
                    name: HistoryScreen.name,
                    builder: (BuildContext context, GoRouterState state) {
                      return const HistoryScreen();
                    },
                    routes: []),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                    path: ChatScreen.path,
                    name: ChatScreen.name,
                    builder: (BuildContext context, GoRouterState state) {
                      return const ChatScreen();
                    }),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                    path: CustomerProfileScreen.path,
                    name: CustomerProfileScreen.name,
                    builder: (BuildContext context, GoRouterState state) {
                      return const CustomerProfileScreen();
                    },
                    routes: [
                      GoRoute(
                          path: CustomerPersonalInfoScreen.path,
                          name: CustomerPersonalInfoScreen.name,
                          builder: (BuildContext context, GoRouterState state) {
                            return const CustomerPersonalInfoScreen();
                          }),
                    ]),
              ],
            ),
          ],
        ),

        // ==> SHELLROUTE VISITEUR

        // ==> SHELLROUTE CLIENT

        // Icon Button

        // Icon Button
      ],
    );
  }

  String _formatInitialRoute(String route) {
    if (route.startsWith('//')) {
      route = route.substring(1);
    }
    return route.isNotEmpty ? route : WelcomeScreen.path;
  }
}

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('Did push route ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('Did pop route ${route.settings.name}');
  }
}

class ScaffoldWithNavigation extends StatelessWidget {
  const ScaffoldWithNavigation({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[navigationShell.currentIndex],
    );
  }
}
