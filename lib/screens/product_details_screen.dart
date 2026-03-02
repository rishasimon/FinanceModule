import 'package:flutter/material.dart';

import '../models/loan_models.dart';
import '../widgets/ui_components.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.onApply,
  });

  final LoanProduct product;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEAF2FA), Color(0xFFF8FBFD), Color(0xFFF2F4F8)],
          ),
        ),
        child: SafeArea(
          child: ContentShell(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FrostPanel(
                    accent: product.accent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: product.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(product.icon, color: product.accent),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    product.subtitle,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          product.summary,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            StatusBadge(
                              label:
                                  '${product.interestRate.toStringAsFixed(1)}% APR',
                              color: product.accent,
                            ),
                            StatusBadge(
                              label: product.approvalTime,
                              color: const Color(0xFF103D63),
                            ),
                            StatusBadge(
                              label:
                                  '${AppFormatters.currency(product.minAmount)} - ${AppFormatters.currency(product.maxAmount)}',
                              color: const Color(0xFF14866D),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: product.accent,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onApply();
                            },
                            child: Text('Apply for ${product.title}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 960;
                      final itemWidth = compact
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 18) / 2;

                      return Wrap(
                        spacing: 18,
                        runSpacing: 18,
                        children: [
                          SizedBox(
                            width: itemWidth,
                            child: FrostPanel(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SectionHeading(
                                    eyebrow: 'Highlights',
                                    title: 'What this product is built for',
                                    subtitle:
                                        'Use this page for the longer explanation instead of crowding the overview screen.',
                                  ),
                                  const SizedBox(height: 18),
                                  ...product.highlights.map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _BulletLine(
                                        text: item,
                                        color: product.accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: FrostPanel(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SectionHeading(
                                    eyebrow: 'Requirements',
                                    title: 'Documents usually requested',
                                    subtitle:
                                        'Borrowers can review supporting documents here before starting the application.',
                                  ),
                                  const SizedBox(height: 18),
                                  ...product.requiredDocuments.map(
                                    (document) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _BulletLine(
                                        text: document,
                                        color: const Color(0xFF103D63),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          height: 8,
          width: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
