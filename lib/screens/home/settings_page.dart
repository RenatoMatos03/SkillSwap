import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import '../auth/login_page.dart';

class SettingsPage extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onSettingsChanged;

  const SettingsPage({
    super.key,
    required this.profile,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _userService = UserService();
  late bool _showCoins;
  late bool _defaultAnonymousMode;

  @override
  void initState() {
    super.initState();
    _showCoins = widget.profile.showCoinsInProfile;
    _defaultAnonymousMode = widget.profile.defaultAnonymousMode;
  }

  Future<void> _toggleShowCoins(bool value) async {
    setState(() => _showCoins = value);
    await _userService.updateProfile(
      uid: widget.profile.uid,
      showCoinsInProfile: value,
    );
    widget.onSettingsChanged();
  }

  Future<void> _toggleAnonymousMode(bool value) async {
    setState(() => _defaultAnonymousMode = value);
    await _userService.updateProfile(
      uid: widget.profile.uid,
      defaultAnonymousMode: value,
    );
    widget.onSettingsChanged();
  }

  Future<void> _sendPasswordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: widget.profile.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Email enviado para ${widget.profile.email}'),
        backgroundColor: AppColors.primary,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  Future<void> _logout() async {
    final confirm = await _confirm(
      title: 'Terminar Sessão',
      message: 'Tens a certeza que queres sair?',
      confirmLabel: 'Sair',
      confirmColor: Colors.orange,
    );
    if (!confirm) return;
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final confirm = await _confirm(
      title: 'Apagar Conta',
      message:
          'Esta ação é irreversível. A tua conta e todos os dados serão eliminados permanentemente.',
      confirmLabel: 'Apagar',
      confirmColor: Colors.red,
    );
    if (!confirm) return;
    try {
      await _userService.deleteUserData(widget.profile.uid);
      await FirebaseAuth.instance.currentUser?.delete();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final msg = e.code == 'requires-recent-login'
          ? 'Por segurança, faz login novamente antes de apagar a conta.'
          : 'Erro: ${e.message}';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) async =>
      await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(confirmLabel,
                      style: TextStyle(
                          color: confirmColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ) ??
      false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Definições',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 28),
          SettingsGroup(children: [
            SettingsActionTile(
              icon: Icons.lock_outline,
              iconBg: const Color(0xFFE0F2F1),
              iconColor: AppColors.primary,
              title: 'Alterar Password',
              onTap: _sendPasswordReset,
            ),
            const SettingsDivider(),
            SettingsSwitchTile(
              icon: Icons.copyright,
              iconBg: const Color(0xFFE0F2F1),
              iconColor: AppColors.primary,
              title: 'Mostrar Moedas no Perfil',
              value: _showCoins,
              onChanged: _toggleShowCoins,
            ),
            const SettingsDivider(),
            SettingsSwitchTile(
              icon: Icons.visibility_off_outlined,
              iconBg: const Color(0xFFEDE7F6),
              iconColor: const Color(0xFF5E35B1),
              title: 'Modo Anónimo por Defeito',
              value: _defaultAnonymousMode,
              onChanged: _toggleAnonymousMode,
            ),
          ]),
          const SizedBox(height: 28),
          SettingsGroup(children: [
            SettingsActionTile(
              icon: Icons.logout,
              iconBg: const Color(0xFFFFF3E0),
              iconColor: Colors.orange,
              title: 'Terminar Sessão',
              onTap: _logout,
            ),
            const SettingsDivider(),
            SettingsActionTile(
              icon: Icons.delete_outline,
              iconBg: const Color(0xFFFFEBEE),
              iconColor: Colors.red,
              title: 'Eliminar Conta',
              titleColor: Colors.red,
              onTap: _deleteAccount,
            ),
          ]),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'SkillSwap · v1.0.0',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
