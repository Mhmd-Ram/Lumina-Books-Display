import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';

/// One row inside a [SettingsSection]: an accent icon chip, a label, and an
/// optional trailing value / control. When [onTap] is set and no [trailing] is
/// given, a chevron is shown to signal navigation. RTL-aware (chevron flips).
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;

    Widget? end = trailing;
    if (end == null && onTap != null) {
      end = Icon(
        context.isArabic ? Icons.chevron_left : Icons.chevron_right,
        size: 20,
        color: tokens.faint,
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: tokens.accentSoft,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 18, color: tokens.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: context.sans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: tokens.ink,
                ),
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: context.sans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: tokens.soft,
                ),
              ),
              const SizedBox(width: 8),
            ],
            ?end,
          ],
        ),
      ),
    );
  }
}
