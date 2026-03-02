import 'package:flutter/material.dart';

import '../data/loan_demo_data.dart';
import '../models/loan_models.dart';
import '../widgets/ui_components.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key, required this.activeCase});

  final LoanCase? activeCase;

  @override
  Widget build(BuildContext context) {
    return ContentShell(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeading(
              eyebrow: 'Manage',
              title:
                  'Application status, required documents, and repayment plan',
              subtitle:
                  'This screen behaves like a professional servicing dashboard with visible pending status, approval journey, document verification, and instalment planning.',
            ),
            const SizedBox(height: 20),
            if (activeCase == null)
              FrostPanel(
                accent: LoanDemoData.midnight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No active loan case',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Once a borrower submits a request, this workspace shows approval stages, document status, and projected repayments.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            else
              _ActivePortfolio(activeCase: activeCase!),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _ActivePortfolio extends StatelessWidget {
  const _ActivePortfolio({required this.activeCase});

  final LoanCase activeCase;

  @override
  Widget build(BuildContext context) {
    final detailsPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusBadge(
          label: activeCase.statusLabel,
          color: activeCase.statusLabel.contains('Pending')
              ? const Color(0xFFC26A33)
              : activeCase.product.accent,
        ),
        const SizedBox(height: 16),
        Text(
          '${activeCase.product.title} for ${activeCase.applicantName}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          activeCase.statusDetail,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 18),
        DetailLine(label: 'Application ID', value: activeCase.applicationId),
        const SizedBox(height: 12),
        DetailLine(
          label: 'Submitted on',
          value: AppFormatters.date(activeCase.submittedOn),
        ),
        const SizedBox(height: 12),
        DetailLine(label: 'Purpose', value: activeCase.purpose),
      ],
    );

    final servicingPanel = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: activeCase.product.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan servicing snapshot',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          DetailLine(
            label: 'Requested amount',
            value: AppFormatters.currency(activeCase.amount),
          ),
          const SizedBox(height: 12),
          DetailLine(
            label: 'Tenure',
            value: '${activeCase.tenureMonths} months',
          ),
          const SizedBox(height: 12),
          DetailLine(
            label: 'Projected EMI',
            value: AppFormatters.currency(activeCase.monthlyInstallment),
          ),
          const SizedBox(height: 12),
          DetailLine(label: 'Next action', value: activeCase.nextAction),
        ],
      ),
    );

    return Column(
      children: [
        FrostPanel(
          accent: activeCase.product.accent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 840;
              return compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailsPanel,
                        const SizedBox(height: 22),
                        servicingPanel,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: detailsPanel),
                        const SizedBox(width: 22),
                        Expanded(flex: 4, child: servicingPanel),
                      ],
                    );
            },
          ),
        ),
        const SizedBox(height: 20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeading(
                          eyebrow: 'Approval Status',
                          title: 'Visible end-to-end approval process',
                          subtitle:
                              'Each case exposes where the borrower stands in intake, document collection, verification, approval, and disbursement.',
                        ),
                        const SizedBox(height: 18),
                        ApprovalTimeline(steps: activeCase.approvalSteps),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: columnWidth,
                  child: Column(
                    children: [
                      FrostPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionHeading(
                              eyebrow: 'Documents',
                              title:
                                  'Required documents and verification status',
                              subtitle:
                                  'Borrowers can immediately see which files are required, uploaded, or verified.',
                            ),
                            const SizedBox(height: 18),
                            ...activeCase.documents.map(
                              (document) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: DocumentTile(document: document),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      FrostPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionHeading(
                              eyebrow: 'Repayment',
                              title: 'Projected repayment schedule',
                              subtitle:
                                  'A professional servicing view should surface due dates and estimated instalments clearly.',
                            ),
                            const SizedBox(height: 18),
                            ...activeCase.installments.map(
                              (installment) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: RepaymentTile(installment: installment),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
