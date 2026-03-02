import 'package:flutter/material.dart';

import '../models/loan_models.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEAF2FA), Color(0xFFF8FBFD), Color(0xFFF2F4F8)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -80,
              left: -50,
              child: _AmbientCircle(
                size: 240,
                colors: [Color(0x3215866D), Color(0x0015866D)],
              ),
            ),
            const Positioned(
              top: 80,
              right: -30,
              child: _AmbientCircle(
                size: 180,
                colors: [Color(0x24C5892F), Color(0x00C5892F)],
              ),
            ),
            const Positioned(
              bottom: -90,
              right: -60,
              child: _AmbientCircle(
                size: 260,
                colors: [Color(0x26103D63), Color(0x00103D63)],
              ),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Overview',
              ),
              NavigationDestination(
                icon: Icon(Icons.edit_note_outlined),
                selectedIcon: Icon(Icons.edit_note_rounded),
                label: 'Apply',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_balance_outlined),
                selectedIcon: Icon(Icons.account_balance_rounded),
                label: 'Manage',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentShell extends StatelessWidget {
  const ContentShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 600 ? 16.0 : 20.0;
    final topPadding = width < 600 ? 16.0 : 20.0;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topPadding,
            horizontalPadding,
            8,
          ),
          child: child,
        ),
      ),
    );
  }
}

class FrostPanel extends StatelessWidget {
  const FrostPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.accent,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: accent?.withValues(alpha: 0.18) ?? const Color(0xFFE2E8F0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x110A203B),
            blurRadius: 34,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 1.2,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF14866D),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final stackAction = action != null && constraints.maxWidth < 720;
        if (stackAction) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [copy, const SizedBox(height: 16), action!],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: copy),
            if (action != null) ...[const SizedBox(width: 12), action!],
          ],
        );
      },
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF62758A),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(caption, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );

    final iconBox = Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, color: color),
    );

    return FrostPanel(
      accent: color,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 340;
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [iconBox, const SizedBox(height: 14), details],
            );
          }

          return Row(
            children: [
              iconBox,
              const SizedBox(width: 14),
              Expanded(child: details),
            ],
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.ctaLabel,
    this.isSelected = false,
    this.onTap,
  });

  final LoanProduct product;
  final String ctaLabel;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      accent: product.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: product.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(product.icon, color: product.accent),
              ),
              const Spacer(),
              if (isSelected)
                StatusBadge(label: 'Selected', color: product.accent),
            ],
          ),
          const SizedBox(height: 18),
          Text(product.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(product.subtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.highlights
                .map(
                  (highlight) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: product.accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      highlight,
                      style: TextStyle(
                        color: product.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _RatePill(
                label: '${product.interestRate.toStringAsFixed(1)}% APR',
                color: product.accent,
              ),
              _RatePill(
                label: product.approvalTime,
                color: const Color(0xFF10243E),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: onTap == null
                ? const SizedBox.shrink()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? product.accent
                          : const Color(0xFF103D63),
                    ),
                    onPressed: onTap,
                    child: Text(ctaLabel),
                  ),
          ),
        ],
      ),
    );
  }
}

class ApprovalTimeline extends StatelessWidget {
  const ApprovalTimeline({super.key, required this.steps});

  final List<ApprovalStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        final color = switch (step.state) {
          ApprovalState.complete => const Color(0xFF14866D),
          ApprovalState.current => const Color(0xFFC5892F),
          ApprovalState.pending => const Color(0xFF9AABBA),
        };
        final icon = switch (step.state) {
          ApprovalState.complete => Icons.check_rounded,
          ApprovalState.current => Icons.more_horiz_rounded,
          ApprovalState.pending => Icons.circle_outlined,
        };

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 36,
              child: Column(
                children: [
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 44,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: color.withValues(alpha: 0.24),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class DocumentTile extends StatelessWidget {
  const DocumentTile({super.key, required this.document});

  final DocumentRequirement document;

  @override
  Widget build(BuildContext context) {
    final color = switch (document.state) {
      DocumentState.requested => const Color(0xFFC26A33),
      DocumentState.uploaded => const Color(0xFF103D63),
      DocumentState.verified => const Color(0xFF14866D),
    };
    final label = switch (document.state) {
      DocumentState.requested => 'Required',
      DocumentState.uploaded => 'Uploaded',
      DocumentState.verified => 'Verified',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final iconBox = Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.description_outlined, color: color),
          );
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                document.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    iconBox,
                    const Spacer(),
                    StatusBadge(label: label, color: color),
                  ],
                ),
                const SizedBox(height: 14),
                copy,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconBox,
              const SizedBox(width: 14),
              Expanded(child: copy),
              const SizedBox(width: 10),
              StatusBadge(label: label, color: color),
            ],
          );
        },
      ),
    );
  }
}

class RepaymentTile extends StatelessWidget {
  const RepaymentTile({super.key, required this.installment});

  final RepaymentInstallment installment;

  @override
  Widget build(BuildContext context) {
    final color = switch (installment.state) {
      InstallmentState.paid => const Color(0xFF14866D),
      InstallmentState.dueSoon => const Color(0xFFC5892F),
      InstallmentState.upcoming => const Color(0xFF103D63),
    };
    final label = switch (installment.state) {
      InstallmentState.paid => 'Paid',
      InstallmentState.dueSoon => 'Due soon',
      InstallmentState.upcoming => 'Upcoming',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3EAF2)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                installment.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                AppFormatters.date(installment.dueDate),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          );
          final amount = Text(
            AppFormatters.currency(installment.amount),
            style: Theme.of(context).textTheme.titleMedium,
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details,
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    amount,
                    StatusBadge(label: label, color: color),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: details),
              amount,
              const SizedBox(width: 12),
              StatusBadge(label: label, color: color),
            ],
          );
        },
      ),
    );
  }
}

class DetailLine extends StatelessWidget {
  const DetailLine({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 460;
        final labelText = Text(
          label,
          style: const TextStyle(
            color: Color(0xFF60758B),
            fontWeight: FontWeight.w600,
          ),
        );
        final valueText = Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: compact ? TextAlign.left : TextAlign.right,
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [labelText, const SizedBox(height: 4), valueText],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: labelText),
            const SizedBox(width: 12),
            Expanded(flex: 3, child: valueText),
          ],
        );
      },
    );
  }
}

class AppFormatters {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String currency(double value) {
    final rounded = value.round().toString();
    final chars = rounded.split('').reversed.toList();
    final buffer = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(chars[i]);
    }
    return '₹${buffer.toString().split('').reversed.join()}';
  }

  static String date(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _RatePill extends StatelessWidget {
  const _RatePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _AmbientCircle extends StatelessWidget {
  const _AmbientCircle({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}
