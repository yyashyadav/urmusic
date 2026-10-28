import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

/// Data model for a browse genre/mood card.
class BrowseCategory {
  final String label;
  final List<Color> gradientColors;

  const BrowseCategory({
    required this.label,
    required this.gradientColors,
  });
}

/// 2-column grid of gradient "Browse all" genre cards matching Search.png.
class BrowseAllGrid extends StatelessWidget {
  final List<BrowseCategory> categories;

  const BrowseAllGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: cat.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(14),
            alignment: Alignment.centerLeft,
            child: Text(
              cat.label,
              style: AppTypography.titleMedium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
