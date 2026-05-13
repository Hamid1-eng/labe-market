import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _isProducer = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le mot de passe doit contenir au moins 6 caractères.')),
      );
      return;
    }

    // Use phone as email format for Firebase Auth
    final email = '${phone.replaceAll(RegExp(r'[^0-9]'), '')}@labe-market.gn';

    setState(() => _isSubmitting = true);
    try {
      final firebaseUser = await _authService.register(email, password);
      if (!mounted) return;

      if (firebaseUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la création du compte.')),
        );
        return;
      }

      // Update display name
      await firebaseUser.updateDisplayName(name);

      context.read<AuthProvider>().setUser(
        UserModel(id: firebaseUser.uid, name: name, phone: '+224$phone'),
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        _isProducer ? '/producer/dashboard' : '/home',
      );
    } catch (e) {
      if (!mounted) return;
      final eStr = e.toString();
      if (eStr.contains('email-already-in-use')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ce numéro est déjà utilisé. Essayez de vous connecter.')),
        );
        return;
      } else if (eStr.contains('weak-password')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mot de passe trop faible.')),
        );
        return;
      }
      
      // Mode hors-ligne / fallback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mode hors-ligne activé (Erreur: ${eStr.split(']').last.trim()})')),
      );
      
      context.read<AuthProvider>().setUser(
        UserModel(id: 'local_demo', name: name, phone: phone),
      );
      Navigator.pushReplacementNamed(
        context,
        _isProducer ? '/producer/dashboard' : '/home',
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7EC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Labé Market',
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    Row(children: const [
                      Icon(Icons.wifi, size: 20, color: Color(0xFF53604D)),
                      SizedBox(width: 8),
                      Text('Labé, GN', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Créer un compte',
                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, color: AppColors.primary)),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Rejoignez la plus grande communauté agricole\nde la région du Fouta Djallon.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, height: 1.35, color: Color(0xFF38453A)),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(6, 24, 6, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Nom complet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF3E463C)))),
                    const SizedBox(height: 10),
                    _InputField(hintText: 'Ex: Samba Diallo', icon: Icons.person_outline, controller: _nameCtrl),
                    const SizedBox(height: 18),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Numéro de téléphone', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF3E463C)))),
                    const SizedBox(height: 10),
                    Row(children: [
                      const SizedBox(width: 10),
                      const _CountryCodeBox(),
                      const SizedBox(width: 10),
                      Expanded(child: _InputField(hintText: '6XX XX XX XX', icon: Icons.phone_android,
                          keyboardType: TextInputType.phone, controller: _phoneCtrl)),
                      const SizedBox(width: 10),
                    ]),
                    const SizedBox(height: 18),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Mot de passe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF3E463C)))),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _InputField(
                        hintText: '••••••••', icon: Icons.lock_outline, obscureText: _obscurePassword,
                        controller: _passwordCtrl,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: const Color(0xFF7B8475)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Quel est votre rôle ?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF3E463C)))),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(children: [
                        _RoleCard(selected: _isProducer, icon: Icons.agriculture, iconBackground: AppColors.primary,
                            title: 'Je suis un Producteur', subtitle: 'Vendez vos récoltes et gérez vos stocks\nfacilement.',
                            onTap: () => setState(() => _isProducer = true)),
                        const SizedBox(height: 12),
                        _RoleCard(selected: !_isProducer, icon: Icons.shopping_cart_outlined, iconBackground: const Color(0xFFFF8A00),
                            title: 'Je suis un Acheteur', subtitle: 'Achetez des produits frais au meilleur prix du\nmarché.',
                            onTap: () => setState(() => _isProducer = false)),
                      ]),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8A00),
                          foregroundColor: const Color(0xFF5A2F00),
                          disabledBackgroundColor: const Color(0xFFFFBB66),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(width: 28, height: 28,
                                child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF5A2F00)))
                            : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text('Créer mon compte', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward, size: 26),
                              ]),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Déjà un compte ? ', style: TextStyle(fontSize: 18, color: Color(0xFF2F392D))),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Se connecter',
                            style: TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.w800)),
                      ),
                    ]),
                    const SizedBox(height: 22),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'En créant un compte, vous acceptez nos Conditions\nd\'Utilisation et notre Politique de Confidentialité.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF768176),
                            fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Color(0xFF768176)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Color(0xFF465F19), Color(0xFF1E3910)]),
                ),
                child: const Text('Soutenir l\'excellence\nagricole du Fouta Djallon.',
                    style: TextStyle(color: Colors.white, fontSize: 28, height: 1.15, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const _InputField({required this.hintText, required this.icon, this.obscureText = false,
      this.keyboardType = TextInputType.text, this.suffixIcon, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(color: const Color(0xFFF8FAF1), borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD8DED0), width: 2)),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none, hintText: hintText,
          hintStyle: const TextStyle(fontSize: 18, color: Color(0xFF637060)),
          prefixIcon: Icon(icon, color: const Color(0xFF7B8475)),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class _CountryCodeBox extends StatelessWidget {
  const _CountryCodeBox();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72, height: 58, alignment: Alignment.center,
      decoration: BoxDecoration(color: const Color(0xFFE8EEE0), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD1D9C7), width: 2)),
      child: const Text('+224', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF3B4738))),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({required this.selected, required this.icon, required this.iconBackground,
      required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        decoration: BoxDecoration(color: const Color(0xFFF8FAF1), borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? AppColors.primary : const Color(0xFFC8D2BF), width: selected ? 2 : 1.5)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(radius: 24, backgroundColor: iconBackground, child: Icon(icon, color: Colors.white, size: 28)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black87)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(fontSize: 17, height: 1.35, color: Color(0xFF445044))),
          ])),
        ]),
      ),
    );
  }
}
