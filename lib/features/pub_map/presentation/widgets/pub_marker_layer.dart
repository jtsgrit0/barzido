import 'package:flutter/material.dart';

import '../../domain/entities/pub.dart';
import '../../domain/entities/pub_region.dart';

class PubMarkerLayer extends StatelessWidget {
  const PubMarkerLayer({
    required this.pubs,
    required this.selectedRegion,
    required this.onMarkerTap,
    this.selectedPub,
    super.key,
  });

  final List<Pub> pubs;
  final PubRegion selectedRegion;
  final Pub? selectedPub;
  final ValueChanged<Pub> onMarkerTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: selectedRegion == PubRegion.hongdae
          ? const Color(0xFFEFF7F2)
          : const Color(0xFFF4F1FA),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapGridPainter(colorScheme.outlineVariant),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  selectedRegion.label,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: colorScheme.primary.withAlpha(36),
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              for (final (index, pub) in pubs.indexed)
                _PositionedMarker(
                  pub: pub,
                  index: index,
                  total: pubs.length,
                  isSelected: selectedPub?.id == pub.id,
                  size: constraints.biggest,
                  onTap: () => onMarkerTap(pub),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PositionedMarker extends StatelessWidget {
  const _PositionedMarker({
    required this.pub,
    required this.index,
    required this.total,
    required this.isSelected,
    required this.size,
    required this.onTap,
  });

  final Pub pub;
  final int index;
  final int total;
  final bool isSelected;
  final Size size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = size.width;
    final height = size.height;
    final spread = total <= 1 ? 1 : total - 1;
    final left = width * (0.24 + (index % 3) * 0.22);
    final top = height * (0.34 + (index / spread) * 0.28);

    return Positioned(
      left: left.clamp(24, width - 96).toDouble(),
      top: top.clamp(116, height - 180).toDouble(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          scale: isSelected ? 1.12 : 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  offset: Offset(0, 6),
                  color: Color(0x22000000),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_bar,
                    size: 18,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 112),
                    child: Text(
                      pub.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(115)
      ..strokeWidth = 1;

    for (var x = 0.0; x < size.width; x += 56) {
      canvas.drawLine(Offset(x, 0), Offset(x + 120, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += 64) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 60), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
