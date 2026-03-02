import 'package:flutter/material.dart';

import '../models/loan_models.dart';
import '../widgets/ui_components.dart';
import 'product_details_screen.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({
    super.key,
    required this.products,
    required this.cases,
    required this.onApply,
    required this.onOpenManage,
  });

  final List<LoanProduct> products;
  final List<LoanCase> cases;
  final ValueChanged<LoanType> onApply;
  final void Function({String? caseId}) onOpenManage;

  @override
  Widget build(BuildContext context) {
    final openRequests = cases.where((loanCase) {
      return loanCase.status == LoanCaseStatus.documentsPending ||
          loanCase.status == LoanCaseStatus.underReview;
    }).length;
    final liveLoans = cases.where((loanCase) {
      return loanCase.status == LoanCaseStatus.approved ||
          loanCase.status == LoanCaseStatus.active;
    }).length;

    return ContentShell(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FrostPanel(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 820;
                  final summary = _QuickSummary(
                    openRequests: openRequests,
                    liveLoans: liveLoans,
                    onApply: () => onApply(LoanType.personal),
                    onOpenManage: () => onOpenManage(),
                  );
                  final productsPreview = _ProductsPreview(products: products);

                  return compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            summary,
                            const SizedBox(height: 20),
                            productsPreview,
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: summary),
                            const SizedBox(width: 20),
                            Expanded(flex: 4, child: productsPreview),
                          ],
                        );
                },
              ),
            ),
            const SizedBox(height: 22),
            SectionHeading(
              eyebrow: 'Products',
              title: 'Loan types',
              subtitle: 'Choose a product and continue.',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 980;
                final itemWidth = compact
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 36) / 3;
                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: products
                      .map(
                        (product) => SizedBox(
                          width: itemWidth,
                          child: _ProductCard(
                            product: product,
                            onApply: () => onApply(product.type),
                            onDetails: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                    product: product,
                                    onApply: () => onApply(product.type),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _QuickSummary extends StatelessWidget {
  const _QuickSummary({
    required this.openRequests,
    required this.liveLoans,
    required this.onApply,
    required this.onOpenManage,
  });

  final int openRequests;
  final int liveLoans;
  final VoidCallback onApply;
  final VoidCallback onOpenManage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan workspace',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Simple application, document upload, and local loan tracking.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MiniMetric(label: 'Requests', value: '$openRequests'),
            _MiniMetric(label: 'Approved / Active', value: '$liveLoans'),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(onPressed: onApply, child: const Text('New loan')),
            OutlinedButton(
              onPressed: onOpenManage,
              child: const Text('View loans'),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _ProductsPreview extends StatelessWidget {
  const _ProductsPreview({required this.products});

  final List<LoanProduct> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: products
            .take(4)
            .map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(product.icon, color: product.accent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: Text(product.title)),
                    Text('${product.requiredDocuments.length} docs'),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onApply,
    required this.onDetails,
  });

  final LoanProduct product;
  final VoidCallback onApply;
  final VoidCallback onDetails;

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
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: product.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(product.icon, color: product.accent),
              ),
              const Spacer(),
              StatusBadge(
                label: '${product.requiredDocuments.length} docs',
                color: product.accent,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(product.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(product.subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton(
                onPressed: onDetails,
                child: const Text('Details'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.accent,
                ),
                onPressed: onApply,
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
