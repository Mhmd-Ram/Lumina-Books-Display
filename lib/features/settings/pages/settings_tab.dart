import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/settings/settings_provider.dart';
import '../../../core/theme/lumina_context.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/lumina_switch.dart';
import '../widgets/settings_row.dart';
import '../widgets/settings_section.dart';

/// The Settings tab: profile card, Preferences (dark mode + language + a static
/// alerts toggle), static Account & About sections, and Log out. Dark mode and
/// language drive the global [SettingsProvider]; Log out calls [AuthProvider].
class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _alerts = true;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final settings = context.watch<SettingsProvider>();

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 104),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: context.titleTopPad),
              child: Text(
                s.settings,
                style: context.serif(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: context.lumina.ink,
                  height: context.titleLineHeight,
                  letterSpacing: context.isArabic ? null : -0.4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const _ProfileCard(),
            const SizedBox(height: 26),
            SettingsSection(
              title: s.preferences,
              rows: [
                SettingsRow(
                  icon: Icons.dark_mode_outlined,
                  label: s.darkMode,
                  trailing: LuminaSwitch(
                    value: settings.isDark,
                    onChanged: (_) =>
                        context.read<SettingsProvider>().toggleTheme(),
                  ),
                ),
                SettingsRow(
                  icon: Icons.translate,
                  label: s.language,
                  value: s.languageValue,
                  onTap: () =>
                      context.read<SettingsProvider>().toggleLanguage(),
                ),
                SettingsRow(
                  icon: Icons.notifications_none,
                  label: s.newReleaseAlerts,
                  trailing: LuminaSwitch(
                    value: _alerts,
                    onChanged: (v) => setState(() => _alerts = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            SettingsSection(
              title: s.account,
              rows: [
                SettingsRow(
                  icon: Icons.edit_outlined,
                  label: s.editProfile,
                  onTap: () {},
                ),
                SettingsRow(
                  icon: Icons.lock_outline,
                  label: s.changePassword,
                  onTap: () {},
                ),
                SettingsRow(
                  icon: Icons.shield_outlined,
                  label: s.privacyData,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 26),
            SettingsSection(
              title: s.about,
              rows: [
                SettingsRow(
                  icon: Icons.help_outline,
                  label: s.helpCenter,
                  onTap: () {},
                ),
                SettingsRow(
                  icon: Icons.auto_awesome,
                  label: s.appName,
                  value: s.version,
                ),
              ],
            ),
            const SizedBox(height: 26),
            const _LogoutButton(),
          ],
        ),
      ),
    );
  }
}

/// Profile summary: a gold-gradient avatar with the user's initial, name, email
/// and a (static) Edit button.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    final s = context.strings;
    final auth = context.watch<AuthProvider>();
    final email = auth.email.isEmpty ? 'reader@example.com' : auth.email;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: tokens.line),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE7C56B), Color(0xFFA97C2E)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xB3785620),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                  spreadRadius: -10,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              auth.initial,
              style: context.serif(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.serif(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: tokens.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.sans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: tokens.soft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: tokens.chip,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: tokens.line),
            ),
            alignment: Alignment.center,
            child: Text(
              s.editShort,
              style: context.sans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: tokens.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Red "Log out" button — signs the mock session out, returning to Login.
class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  static const _red = Color(0xFFC53030);

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    return GestureDetector(
      onTap: () => context.read<AuthProvider>().signOut(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: _red.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: _red.withValues(alpha: 0.28)),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 20, color: _red),
            const SizedBox(width: 10),
            Text(
              s.logOut,
              style: context.sans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
