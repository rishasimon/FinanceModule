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
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: product.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(product.icon, color: product.accent),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                product.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          product.summary,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
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
                          ],
                        ),
                        const SizedBox(height: 18),
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
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  FrostPanel(
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: const Text(
                          'Required documents',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        children: [
                          const SizedBox(height: 8),
                          ...product.requiredDocuments.map(
                            (document) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(document.title),
                              subtitle: Text(document.description),
                              trailing: StatusBadge(
                                label: document.groupLabel,
                                color: product.accent,
                              ),
                            ),
                          ),
                        ],
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
