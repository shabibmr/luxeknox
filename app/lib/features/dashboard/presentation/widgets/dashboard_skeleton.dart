import 'package:flutter/material.dart';

/// A lightweight, dependency-free loading placeholder shown only on the
/// first (empty-state) load — a refresh keeps the previous content visible
/// instead (see `DashboardStatus.refreshing`).
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        DashboardSkeletonCard(height: 96),
        SizedBox(height: 16),
        DashboardSkeletonCard(height: 140),
        SizedBox(height: 16),
        DashboardSkeletonCard(height: 140),
      ],
    );
  }
}

/// A single skeleton placeholder block, shared by [DashboardSkeleton] and
/// any dashboard sub-section that loads independently (e.g. the agenda).
class DashboardSkeletonCard extends StatelessWidget {
  const DashboardSkeletonCard({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
