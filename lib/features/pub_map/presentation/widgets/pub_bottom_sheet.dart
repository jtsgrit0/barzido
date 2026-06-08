import 'package:flutter/material.dart';

import '../../domain/entities/opening_status.dart';
import '../../domain/entities/pub.dart';

class PubBottomSheet extends StatelessWidget {
  const PubBottomSheet({
    required this.pub,
    required this.onFavoriteTap,
    required this.onDetailTap,
    super.key,
  });

  final Pub pub;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_bar,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pub.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pub.openingStatus.label} · ${pub.rating.toStringAsFixed(1)} · 리뷰 ${pub.reviewCount}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pub.tags.take(3).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: '즐겨찾기',
              onPressed: onFavoriteTap,
              icon: Icon(pub.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
            IconButton(
              tooltip: '상세',
              onPressed: onDetailTap,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
