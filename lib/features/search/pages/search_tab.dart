import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/constellation_glyph.dart';
import '../../../core/widgets/lumina_header.dart';
import '../../../core/widgets/lumina_states.dart';
import '../../catalog/providers/search_provider.dart';
import '../widgets/search_result_tile.dart';

/// Search — a gold "DISCOVER" header, a search field with a clear button, a
/// results count, and a vertical list of results. Typing filters the loaded
/// results instantly; submitting runs a fresh Open Library search.
class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Populate the seed results the first time the tab is shown.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().ensureLoaded();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    context.read<SearchProvider>().setFilter('');
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final provider = context.watch<SearchProvider>();

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: LuminaHeader(
              eyebrowIcon: Icons.auto_awesome,
              eyebrow: s.discover,
              title: s.findNext,
              titleSize: 29,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
            child: _SearchField(
              controller: _controller,
              hint: s.searchPlaceholder,
              onChanged: (q) => context.read<SearchProvider>().setFilter(q),
              onSubmitted: (q) => context.read<SearchProvider>().submit(q),
              onClear: _clear,
            ),
          ),
          Expanded(child: _buildBody(context, provider, s.results)),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SearchProvider provider,
    String resultsWord,
  ) {
    if (provider.isLoading) return const LuminaLoading();
    if (provider.error != null) {
      return LuminaError(
        message: provider.error!,
        onRetry: () => context.read<SearchProvider>().submit(_controller.text),
      );
    }

    final results = provider.results;
    final tokens = context.lumina;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 4),
          child: Text(
            '${results.length} $resultsWord'.toUpperCase(),
            style: context.sans(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: tokens.faint,
              letterSpacing: context.eyebrowTracking(12.5),
            ),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? LuminaEmpty(
                  icon: ConstellationGlyph.star(color: tokens.accent),
                  title: context.strings.noBooks,
                  subtitle: context.strings.noBooksSub,
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 104),
                  itemCount: results.length,
                  itemBuilder: (_, i) => SearchResultTile(book: results[i]),
                ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59181E2E),
            blurRadius: 30,
            offset: Offset(0, 14),
            spreadRadius: -20,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 21, color: tokens.faint),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              cursorColor: tokens.accent,
              style: context.sans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: tokens.ink,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: context.sans(fontSize: 15, color: tokens.faint),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: onClear,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tokens.chip,
                  ),
                  child: Icon(Icons.close, size: 16, color: tokens.soft),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
