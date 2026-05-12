import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir les champs.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final firebaseUser = await _authService.signIn(identifier, password);
      if (!mounted) return;

      if (firebaseUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Connexion impossible.')));
        return;
      }

      context.read<AuthProvider>().setUser(
        UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Agriculteur',
          phone: firebaseUser.phoneNumber ?? '',
        ),
      );

      Navigator.pushReplacementNamed(context, '/producer/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de connexion. Vérifiez email/mot de passe.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7ED),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF4F7ED),
                      Color(0xFFF2F5EA),
                      Color(0xFFE9EEE2),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Labé Market',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.wifi,
                              size: 22,
                              color: Color(0xFF4A5644),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Labé, GN',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Bon retour',
                    style: TextStyle(
                      fontSize: 52,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2420),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Connectez-vous pour accéder au marché de Labé',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        height: 1.4,
                        color: Color(0xFF3F4A3E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    padding: const EdgeInsets.fromLTRB(22, 34, 22, 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Numéro de téléphone ou email',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3E463C),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _FieldShell(
                          child: TextField(
                            controller: _identifierController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Entrez vos identifiants',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 18,
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Color(0xFF7B8475),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 19,
                              ),
                            ),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Mot de passe',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3E463C),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _FieldShell(
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '••••••••',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 20,
                                letterSpacing: 4,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF7B8475),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF7B8475),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 19,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 72,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: const Color(0xFFD8F4C9),
                              elevation: 8,
                              shadowColor: AppColors.primary.withValues(
                                alpha: 0.35,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isSubmitting)
                                  const SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFD8F4C9),
                                      ),
                                    ),
                                  )
                                else ...[
                                  const Text(
                                    'Se connecter',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.arrow_forward, size: 28),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: Color(0xFF8EB58D),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'SYNCHRONISATION ACTIVE',
                                style: TextStyle(
                                  letterSpacing: 0.6,
                                  color: Color(0xFF667268),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF4F7ED),
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Pas encore de compte ? ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF2E372D),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/register'),
                              child: const Text(
                                'S’inscrire',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'AIDE VOCALE',
                          style: TextStyle(
                            letterSpacing: 1.2,
                            fontSize: 15,
                            color: Color(0xFF8B9287),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          height: 62,
                          width: 250,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7ECE0),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFFFF8A00),
                                child: Icon(
                                  Icons.mic,
                                  color: Color(0xFF5A2F00),
                                  size: 22,
                                ),
                              ),
                              SizedBox(width: 18),
                              Text(
                                'Aider par la voix',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF304033),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldShell extends StatelessWidget {
  final Widget child;

  const _FieldShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8DED0), width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: child,
    );
  }
}
