import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

/// Circular progress ring with a percentage and a label in the middle.
class MacroRing extends StatelessWidget {
  const MacroRing({
    super.key,
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final int percent; // 0..100
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 64,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percent / 100,
            strokeWidth: 6,
            strokeCap: StrokeCap.round,
            color: color,
            backgroundColor: color.withValues(alpha: 0.15),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$percent%',
                style: AppTextStyles.heading.copyWith(fontSize: 14),
              ),
              Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
