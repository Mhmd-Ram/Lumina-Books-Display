import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';

/// A titled settings group: an uppercase section label above a rounded card that
/// holds [rows], separated by hairline dividers. Matches the comp's sections.
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> rows;

  const SettingsSection({super.key, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;

    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      if (i > 0) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(height: 1, color: tokens.line),
          ),
        );
      }
      children.add(rows[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 6),
          child: Text(
            title.toUpperCase(),
            style: context.sans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: tokens.faint,
              letterSpacing: context.eyebrowTracking(12) * 0.7,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: tokens.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}
