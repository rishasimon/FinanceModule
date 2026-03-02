import 'package:flutter/material.dart';

import '../data/loan_demo_data.dart';
import '../models/loan_models.dart';
import 'product_details_screen.dart';
import '../widgets/ui_components.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({
    super.key,
    required this.products,
    required this.activeCase,
    required this.onApply,
  });

  final List<LoanProduct> products;
  final LoanCase? activeCase;
  final ValueChanged<LoanType> onApply;

  void _openProductDetails(BuildContext context, LoanProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(
          product: product,
          onApply: () => onApply(product.type),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentShell(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroSection(
              activeCase: activeCase,
              onApply: () => onApply(LoanType.simple),
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 900;
                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    SizedBox(
                      width: compact
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 36) / 3,
                      child: MetricTile(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'Instant eligibility',
                        value: '₹2.4M',
                        caption: 'Pre-qualified lending limit available today',
                        color: LoanDemoData.midnight,
                      ),
                    ),
                    SizedBox(
                      width: compact
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 36) / 3,
                      child: MetricTile(
                        icon: Icons.timer_outlined,
                        label: 'Underwriting speed',
                        value: '4 hrs',
                        caption: 'Fastest review lane for bridge funding cases',
                        color: LoanDemoData.amber,
                      ),
                    ),
                    SizedBox(
                      width: compact
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 36) / 3,
                      child: MetricTile(
                        icon: Icons.fact_check_outlined,
                        label: 'Current workflow',
                        value: activeCase?.statusLabel ?? 'No open case',
                        caption:
                            activeCase?.nextAction ??
                            'Create a new request to begin',
                        color: LoanDemoData.emerald,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 36),
            SectionHeading(
              eyebrow: 'Loan Solutions',
              title: 'Three lending products built like a modern banking app',
              subtitle:
                  'Each product includes application capture, required documents, verification steps, approval checkpoints, and repayment planning.',
              action: OutlinedButton(
                onPressed: () => onApply(LoanType.repayment),
                child: const Text('Start application'),
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 980;
                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: products
                      .map(
                        (product) => SizedBox(
                          width: compact
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 36) / 3,
                          child: _OverviewProductCard(
                            product: product,
                            onApply: () => onApply(product.type),
                            onViewDetails: () =>
                                _openProductDetails(context, product),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 36),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 980;
                final columnWidth = compact
                    ? constraints.maxWidth
                    : (constraints.maxWidth - 18) / 2;
                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    SizedBox(
                      width: columnWidth,
                      child: FrostPanel(
                        accent: LoanDemoData.midnight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SectionHeading(
                              eyebrow: 'Approval Journey',
                              title:
                                  'Professional workflow from request to disbursement',
                              subtitle:
                                  'The app surfaces the same stages borrowers expect in regulated lending flows.',
                            ),
                            SizedBox(height: 18),
                            _ProcessBullet(
                              title: '1. Application intake',
                              body:
                                  'Capture borrower identity, amount, purpose, income, obligations, bank details, and loan-specific declarations.',
                            ),
                            SizedBox(height: 12),
                            _ProcessBullet(
                              title: '2. Document request',
                              body:
                                  'Show every required document up front and clearly mark what is uploaded, verified, or still pending.',
                            ),
                            SizedBox(height: 12),
                            _ProcessBullet(
                              title: '3. Verification and underwriting',
                              body:
                                  'Expose KYC review, income validation, collateral checks, and credit approval milestones.',
                            ),
                            SizedBox(height: 12),
                            _ProcessBullet(
                              title: '4. Repayment servicing',
                              body:
                                  'Preview EMI amounts, due dates, and account servicing expectations before funds are disbursed.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: columnWidth,
                      child: FrostPanel(
                        accent: LoanDemoData.emerald,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeading(
                              eyebrow: 'Live Case',
                              title: activeCase == null
                                  ? 'No loan request in progress'
                                  : '${activeCase!.product.title} is active',
                              subtitle: activeCase == null
                                  ? 'Once a request is submitted, this panel shows current status, next action, and required documents.'
                                  : activeCase!.statusDetail,
                            ),
                            const SizedBox(height: 18),
                            if (activeCase == null)
                              const Text(
                                'Open the Apply tab to submit a professional loan request with all borrower, banking, and document details.',
                              )
                            else ...[
                              DetailLine(
                                label: 'Application ID',
                                value: activeCase!.applicationId,
                              ),
                              const SizedBox(height: 12),
                              DetailLine(
                                label: 'Requested amount',
                                value: AppFormatters.currency(
                                  activeCase!.amount,
                                ),
                              ),
                              const SizedBox(height: 12),
                              DetailLine(
                                label: 'Submitted on',
                                value: AppFormatters.date(
                                  activeCase!.submittedOn,
                                ),
                              ),
                              const SizedBox(height: 12),
                              DetailLine(
                                label: 'Next action',
                                value: activeCase!.nextAction,
                              ),
                              const SizedBox(height: 18),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: activeCase!.documents
                                    .take(3)
                                    .map(
                                      (document) => StatusBadge(
                                        label: document.title,
                                        color: switch (document.state) {
                                          DocumentState.requested =>
                                            const Color(0xFFC26A33),
                                          DocumentState.uploaded =>
                                            LoanDemoData.midnight,
                                          DocumentState.verified =>
                                            LoanDemoData.emerald,
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 18),
                              ElevatedButton(
                                onPressed: () =>
                                    onApply(activeCase!.product.type),
                                child: const Text('Create another request'),
                              ),
                            ],
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
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.activeCase, required this.onApply});

  final LoanCase? activeCase;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final primaryPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Northstar Loans',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Professional loan origination with a clear borrower journey.',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          'Create simple loans, repayment loans, and bridge loans with form intake, document collection, verification, approval status, and servicing in one polished Flutter app.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.84),
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF103D63),
              ),
              onPressed: onApply,
              child: const Text('Request a loan'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.28)),
              ),
              onPressed: () {},
              child: const Text('Talk to advisor'),
            ),
          ],
        ),
      ],
    );

    final snapshotPanel = Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live borrower snapshot',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          _HeroInfo(
            label: 'Open application',
            value: activeCase?.product.title ?? 'No active case',
          ),
          const SizedBox(height: 10),
          _HeroInfo(
            label: 'Current stage',
            value: activeCase?.statusLabel ?? 'Ready to start',
          ),
          const SizedBox(height: 10),
          _HeroInfo(
            label: 'Estimated EMI',
            value: activeCase == null
                ? 'Calculated after request'
                : AppFormatters.currency(activeCase!.monthlyInstallment),
          ),
          const SizedBox(height: 10),
          const _HeroInfo(
            label: 'Workflow visibility',
            value: 'Documents, verification, approval, repayment',
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF103D63), Color(0xFF173F74), Color(0xFF14866D)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x110A203B),
            blurRadius: 34,
            offset: Offset(0, 18),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 850;
          return compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    primaryPanel,
                    const SizedBox(height: 22),
                    snapshotPanel,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: primaryPanel),
                    const SizedBox(width: 22),
                    Expanded(flex: 5, child: snapshotPanel),
                  ],
                );
        },
      ),
    );
  }
}

class _OverviewProductCard extends StatelessWidget {
  const _OverviewProductCard({
    required this.product,
    required this.onApply,
    required this.onViewDetails,
  });

  final LoanProduct product;
  final VoidCallback onApply;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      accent: product.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 16),
          Text(product.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(product.subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusBadge(
                label: '${product.interestRate.toStringAsFixed(1)}% APR',
                color: product.accent,
              ),
              StatusBadge(
                label: product.approvalTime,
                color: const Color(0xFF103D63),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            '${AppFormatters.currency(product.minAmount)} to ${AppFormatters.currency(product.maxAmount)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton(
                onPressed: onViewDetails,
                child: const Text('View details'),
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

class _HeroInfo extends StatelessWidget {
  const _HeroInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 380;
        final labelText = Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
            fontWeight: FontWeight.w600,
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelText,
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 120, child: labelText),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProcessBullet extends StatelessWidget {
  const _ProcessBullet({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          height: 10,
          width: 10,
          decoration: const BoxDecoration(
            color: Color(0xFF14866D),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              children: [
                TextSpan(
                  text: '$title ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF112846),
                  ),
                ),
                TextSpan(text: body),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
