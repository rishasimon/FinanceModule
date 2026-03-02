import 'package:flutter/material.dart';

import '../models/loan_models.dart';
import '../widgets/ui_components.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({
    super.key,
    required this.cases,
    required this.selectedCaseId,
    required this.onSelectCase,
    required this.onCreateRequest,
  });

  final List<LoanCase> cases;
  final String? selectedCaseId;
  final ValueChanged<String> onSelectCase;
  final VoidCallback onCreateRequest;

  @override
  Widget build(BuildContext context) {
    final requested = cases
        .where((loanCase) {
          return loanCase.status == LoanCaseStatus.documentsPending ||
              loanCase.status == LoanCaseStatus.underReview;
        })
        .toList(growable: false);
    final approvedOrActive = cases
        .where((loanCase) {
          return loanCase.status == LoanCaseStatus.approved ||
              loanCase.status == LoanCaseStatus.active;
        })
        .toList(growable: false);
    final selectedCase = _resolveSelectedCase();

    return ContentShell(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeading(
              eyebrow: 'Loans',
              title: 'Saved loans',
              subtitle: 'Requests, approved loans, and active loans.',
              action: ElevatedButton(
                onPressed: onCreateRequest,
                child: const Text('New loan'),
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 1024;
                return compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLists(requested, approvedOrActive),
                          const SizedBox(height: 18),
                          _CaseDetails(loanCase: selectedCase),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 360,
                            child: _buildLists(requested, approvedOrActive),
                          ),
                          const SizedBox(width: 18),
                          Expanded(child: _CaseDetails(loanCase: selectedCase)),
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

  Widget _buildLists(
    List<LoanCase> requested,
    List<LoanCase> approvedOrActive,
  ) {
    return Column(
      children: [
        _CaseListPanel(
          title: 'Requested',
          emptyLabel: 'No requested loans',
          cases: requested,
          selectedCaseId: selectedCaseId,
          onSelectCase: onSelectCase,
        ),
        const SizedBox(height: 18),
        _CaseListPanel(
          title: 'Approved / Active',
          emptyLabel: 'No approved or active loans',
          cases: approvedOrActive,
          selectedCaseId: selectedCaseId,
          onSelectCase: onSelectCase,
        ),
      ],
    );
  }

  LoanCase? _resolveSelectedCase() {
    if (cases.isEmpty) {
      return null;
    }
    if (selectedCaseId != null) {
      for (final loanCase in cases) {
        if (loanCase.applicationId == selectedCaseId) {
          return loanCase;
        }
      }
    }
    return cases.first;
  }
}

class _CaseListPanel extends StatelessWidget {
  const _CaseListPanel({
    required this.title,
    required this.emptyLabel,
    required this.cases,
    required this.selectedCaseId,
    required this.onSelectCase,
  });

  final String title;
  final String emptyLabel;
  final List<LoanCase> cases;
  final String? selectedCaseId;
  final ValueChanged<String> onSelectCase;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          if (cases.isEmpty)
            Text(emptyLabel, style: Theme.of(context).textTheme.bodyLarge)
          else
            ...cases.map(
              (loanCase) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CaseRow(
                  loanCase: loanCase,
                  selected: loanCase.applicationId == selectedCaseId,
                  onTap: () => onSelectCase(loanCase.applicationId),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CaseRow extends StatelessWidget {
  const _CaseRow({
    required this.loanCase,
    required this.selected,
    required this.onTap,
  });

  final LoanCase loanCase;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _statusColor(loanCase);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.08)
              : const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? accent : const Color(0xFFE1E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  loanCase.product.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                StatusBadge(label: loanCase.statusLabel, color: accent),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              loanCase.applicantName.isEmpty
                  ? 'Applicant'
                  : loanCase.applicantName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              AppFormatters.currency(loanCase.amount),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CaseDetails extends StatelessWidget {
  const _CaseDetails({required this.loanCase});

  final LoanCase? loanCase;

  @override
  Widget build(BuildContext context) {
    if (loanCase == null) {
      return FrostPanel(
        child: Text(
          'No saved loans yet.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return FrostPanel(
      accent: loanCase!.product.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                loanCase!.product.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              StatusBadge(
                label: loanCase!.statusLabel,
                color: _statusColor(loanCase!),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DetailLine(label: 'Application ID', value: loanCase!.applicationId),
          const SizedBox(height: 10),
          DetailLine(
            label: 'Amount',
            value: AppFormatters.currency(loanCase!.amount),
          ),
          const SizedBox(height: 10),
          DetailLine(
            label: 'Tenure',
            value: '${loanCase!.tenureMonths} months',
          ),
          const SizedBox(height: 10),
          DetailLine(
            label: 'Submitted',
            value: AppFormatters.date(loanCase!.submittedOn),
          ),
          const SizedBox(height: 10),
          DetailLine(label: 'Next step', value: loanCase!.nextAction),
          const SizedBox(height: 18),
          _ExpandableCaseSection(
            title: 'Documents',
            child: Column(
              children: loanCase!.documents
                  .map(
                    (document) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DocumentTile(document: document),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _ExpandableCaseSection(
            title: 'Approval status',
            child: ApprovalTimeline(steps: loanCase!.approvalSteps),
          ),
          const SizedBox(height: 12),
          _ExpandableCaseSection(
            title: 'Repayment',
            child: Column(
              children: loanCase!.installments
                  .map(
                    (installment) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RepaymentTile(installment: installment),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableCaseSection extends StatelessWidget {
  const _ExpandableCaseSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E8F0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          children: [child],
        ),
      ),
    );
  }
}

Color _statusColor(LoanCase loanCase) {
  return switch (loanCase.status) {
    LoanCaseStatus.documentsPending => const Color(0xFFC26A33),
    LoanCaseStatus.underReview => loanCase.product.accent,
    LoanCaseStatus.approved => const Color(0xFF14866D),
    LoanCaseStatus.active => const Color(0xFF103D63),
  };
}
