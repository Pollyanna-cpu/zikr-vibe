import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth_prefs.dart';
import '../../../core/skin.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  bool _showEmailForm = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Pragmatic email check — RFC 5322 is huge but in practice this catches
  /// the typos testers actually make ("user@" / "user.com" / "user@domain").
  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    if (!_emailRe.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      if (_isSignUp) {
        final name = _nameController.text.trim();
        if (name.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter your name')),
            );
            setState(() => _isLoading = false);
          }
          return;
        }
        await authService.signUpWithEmail(email, password, name);
      } else {
        await authService.signInWithEmail(email, password);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${_isSignUp ? "Sign up" : "Sign in"} failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final skin = ref.watch(skinProvider);

    return Scaffold(
      backgroundColor: skin.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo area
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: skin.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.touch_app_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Zikr Vibe',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: skin.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Count your dhikr. Nothing else watches.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: skin.inkSoft,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              if (!_showEmailForm) ...[
                // Email (primary — always works)
                _SocialButton(
                  onPressed: () => setState(() => _showEmailForm = true),
                  icon: Icons.email_outlined,
                  label: 'Continue with Email',
                  backgroundColor: skin.primary,
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 12),

                // Google Sign In
                _SocialButton(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: Icons.g_mobiledata_rounded,
                  label: 'Continue with Google',
                  backgroundColor: Colors.white,
                  foregroundColor: skin.ink,
                ),

                // TODO: Apple Sign In — add when Apple Developer account is ready

                const SizedBox(height: 12),

                // Skip — use without account
                TextButton(
                  onPressed: () {
                    skipAuth(ref);
                    if (context.mounted) context.go('/dhikr');
                  },
                  child: Text(
                    'Use without an account',
                    style: TextStyle(
                      color: skin.inkMuted,
                      fontSize: 14,
                    ),
                  ),
                ),
              ] else ...[
                // Email form
                if (_isSignUp)
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: skin.primary),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                if (_isSignUp) const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: skin.primary),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: skin.primary),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: skin.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(
                    _isSignUp
                        ? 'Already have an account? Sign In'
                        : "Don't have an account? Sign Up",
                    style: TextStyle(color: skin.primary),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _showEmailForm = false),
                  child: Text('Back', style: TextStyle(color: skin.inkSoft)),
                ),
              ],

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  const _SocialButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: foregroundColor),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
