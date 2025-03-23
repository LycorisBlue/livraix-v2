part of 'widget.splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String path = '/splash';
  static const String name = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<Animation<double>> _letterAnimations = [];
  final String _title = 'LIVRAIX';
  final Completer<void> _animationCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

    // Configuration de l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Création d'une animation pour chaque lettre avec un décalage
    final int letterCount = _title.length;
    for (int i = 0; i < letterCount; i++) {
      final begin = i / letterCount;
      final end = (i + 1) / letterCount;

      _letterAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(begin, end, curve: Curves.easeInOut),
          ),
        ),
      );
    }

    // Démarrer l'animation
    _animationController.forward().whenComplete(() {
      _animationCompleter.complete(); // Signaliser que l'animation est terminée
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkUserSession() async {
    // Attendre que l'animation soit terminée
    await _animationCompleter.future;

    // Attendre 2 secondes supplémentaires
    await Future.delayed(const Duration(seconds: 2));

    // Vérifier si l'utilisateur est déjà connecté
    final String? lastRoute = await GeneralManagerDB.getLastRoute();
    final String? userSession = await GeneralManagerDB.getSessionUser();

    if (!mounted) return;

    if (userSession != null && lastRoute != null) {
      // Si l'utilisateur a une session active, naviguer vers la dernière route
      context.go(lastRoute);
    } else {
      // Sinon, naviguer vers l'écran d'accueil
      context.pushNamed(WelcomeScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Démarrer la vérification de la session après la construction du widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserSession();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF074F24), // Couleur verte du thème de l'application
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _title.length,
                (index) => AnimatedOpacity(
                  opacity: _letterAnimations[index].value,
                  duration: const Duration(milliseconds: 100),
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _letterAnimations[index].value)),
                    child: Text(
                      _title[index],
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}