import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class ProductionScreen extends StatelessWidget {
  const ProductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Production Monitor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Overall Efficiency', style: AppTypography.bodySmall),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('▲ 8% vs last month', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('85%', style: AppTypography.displayLarge.copyWith(fontSize: 48, color: AppColors.primary)),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(label: 'Target', value: '1,200'),
                      _StatColumn(label: 'Produced', value: '1,020'),
                      _StatColumn(label: 'Remaining', value: '180'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Production Trend', style: AppTypography.labelMedium),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 3),
                              const FlSpot(1, 5),
                              const FlSpot(2, 4),
                              const FlSpot(3, 7),
                              const FlSpot(4, 6),
                              const FlSpot(5, 8),
                            ],
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 4,
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.primary.withAlpha(40),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTypography.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.titleLarge),
      ],
    );
  }
}
