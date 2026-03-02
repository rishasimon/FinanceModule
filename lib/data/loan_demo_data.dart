import 'dart:math';

import 'package:flutter/material.dart';

import '../models/loan_models.dart';

class LoanDemoData {
  static const Color midnight = Color(0xFF12345A);
  static const Color emerald = Color(0xFF14866D);
  static const Color amber = Color(0xFFC5892F);

  static final List<LoanProduct> products = [
    LoanProduct(
      type: LoanType.simple,
      title: 'Simple Loan',
      subtitle: 'Fast personal liquidity for planned needs',
      summary:
          'A straightforward term loan for education, travel, medical, or home expenses with predictable monthly instalments.',
      interestRate: 11.2,
      minAmount: 50000,
      maxAmount: 750000,
      suggestedAmount: 180000,
      termOptions: const [6, 12, 18, 24, 36],
      approvalTime: 'Same-day conditional decision',
      icon: Icons.account_balance_wallet_rounded,
      accent: midnight,
      highlights: const [
        'No collateral for qualified borrowers',
        'Fixed monthly repayment plan',
        'Relationship manager callback within 2 hours',
      ],
      requiredDocuments: const [
        'Government-issued ID',
        'Address proof',
        'Last 3 salary slips',
        'Primary bank statements',
      ],
    ),
    LoanProduct(
      type: LoanType.repayment,
      title: 'Repayment Loan',
      subtitle: 'Structured borrowing with servicing control',
      summary:
          'Built for borrowers who want a disciplined repayment schedule, clear amortization, and better rate control over longer terms.',
      interestRate: 10.4,
      minAmount: 150000,
      maxAmount: 1500000,
      suggestedAmount: 450000,
      termOptions: const [12, 24, 36, 48, 60],
      approvalTime: '24-hour underwriting review',
      icon: Icons.receipt_long_rounded,
      accent: emerald,
      highlights: const [
        'Longer repayment horizon',
        'Repayment tracker and due-date reminders',
        'Suited for home improvement or consolidation',
      ],
      requiredDocuments: const [
        'Government-issued ID',
        'Address proof',
        'Last 6 months bank statements',
        'Latest tax return',
        'Income proof or audited statements',
      ],
    ),
    LoanProduct(
      type: LoanType.bridge,
      title: 'Bridge Loan',
      subtitle: 'Short-term capital ahead of a confirmed inflow',
      summary:
          'Designed for short duration funding needs while you wait for a property sale, receivable, or long-term financing to close.',
      interestRate: 13.1,
      minAmount: 300000,
      maxAmount: 5000000,
      suggestedAmount: 900000,
      termOptions: const [3, 6, 9, 12],
      approvalTime: 'Priority review in 4 business hours',
      icon: Icons.apartment_rounded,
      accent: amber,
      highlights: const [
        'Ideal for temporary liquidity gaps',
        'Collateral-backed review workflow',
        'Dedicated document and valuation checks',
      ],
      requiredDocuments: const [
        'Government-issued ID',
        'Address proof',
        'Last 6 months bank statements',
        'Source-of-funds proof',
        'Collateral or property documents',
        'Exit plan / sale agreement',
      ],
    ),
  ];

  static LoanApplicationDraft emptyDraft(LoanProduct product) {
    return LoanApplicationDraft(
      fullName: 'Aarav Mehta',
      email: 'aarav.mehta@email.com',
      phone: '+91 98765 43210',
      dateOfBirth: '1991-08-17',
      governmentId: 'ID-4821-2039',
      taxId: 'TAX-8827-193',
      addressLine: '24 Riverfront Avenue',
      city: 'Mumbai',
      employmentType: 'Salaried',
      employerName: 'Northshore Logistics Pvt Ltd',
      monthlyIncome: 185000,
      monthlyObligations: 22000,
      bankName: 'Northstar Private Bank',
      accountNumber: '015024880154',
      loanPurpose: product.type == LoanType.bridge
          ? 'Bridge working capital until property settlement clears.'
          : 'Working capital and planned household upgrades.',
      disbursementWindow: 'Within 5 business days',
      collateralDetails: product.type == LoanType.bridge
          ? 'Residential flat in Bandra, current market value approx. ₹1.8M.'
          : '',
      hasCoApplicant: false,
      coApplicantName: '',
      amount: product.suggestedAmount,
      tenureMonths: product.termOptions.first,
      readyDocuments: product.requiredDocuments.take(2).toSet(),
    );
  }

  static LoanCase get seededCase {
    final product = products.last;
    final draft = emptyDraft(product).copyWith(
      fullName: 'Aarav Mehta',
      loanPurpose: 'Bridge funding until property sale settlement is credited.',
      amount: 1250000,
      tenureMonths: 6,
      readyDocuments: {
        'Government-issued ID',
        'Address proof',
        'Last 6 months bank statements',
      },
    );
    return createCase(
      product: product,
      draft: draft,
      submittedOn: DateTime(2026, 2, 28),
    );
  }

  static LoanProduct productForType(LoanType type) {
    return products.firstWhere((product) => product.type == type);
  }

  static LoanCase createCase({
    required LoanProduct product,
    required LoanApplicationDraft draft,
    DateTime? submittedOn,
  }) {
    final submittedDate = submittedOn ?? DateTime.now();
    final documents = _buildDocuments(product: product, draft: draft);
    final allDocumentsReady = documents.every(
      (document) => document.state != DocumentState.requested,
    );
    final statusLabel = allDocumentsReady
        ? 'Verification in progress'
        : 'Pending documents';
    final statusDetail = allDocumentsReady
        ? 'Your KYC, income, and affordability checks are under review.'
        : '${documents.where((doc) => doc.state == DocumentState.requested).length} required documents are still pending upload.';
    final nextAction = allDocumentsReady
        ? 'A credit officer is validating income and bank details before approval.'
        : 'Upload the remaining documents so the application can move into verification.';

    return LoanCase(
      applicationId:
          '${product.type.code}-${submittedDate.year}${submittedDate.month.toString().padLeft(2, '0')}${submittedDate.day.toString().padLeft(2, '0')}-${draft.phone.replaceAll(RegExp(r'\D'), '').substring(max(0, draft.phone.replaceAll(RegExp(r'\D'), '').length - 4))}',
      product: product,
      applicantName: draft.fullName,
      amount: draft.amount,
      tenureMonths: draft.tenureMonths,
      purpose: draft.loanPurpose,
      submittedOn: submittedDate,
      statusLabel: statusLabel,
      statusDetail: statusDetail,
      nextAction: nextAction,
      monthlyInstallment: estimateEmi(
        principal: draft.amount,
        annualRate: product.interestRate,
        months: draft.tenureMonths,
      ),
      approvalSteps: _buildApprovalSteps(allDocumentsReady),
      documents: documents,
      installments: _buildInstallments(
        principal: draft.amount,
        annualRate: product.interestRate,
        months: draft.tenureMonths,
        startDate: submittedDate,
      ),
    );
  }

  static List<ApprovalStep> _buildApprovalSteps(bool allDocumentsReady) {
    return [
      const ApprovalStep(
        title: 'Application submitted',
        description:
            'Borrower profile, amount request, and declarations received.',
        state: ApprovalState.complete,
      ),
      const ApprovalStep(
        title: 'Initial review',
        description:
            'Eligibility, product fit, and debt-to-income ratio screened.',
        state: ApprovalState.complete,
      ),
      ApprovalStep(
        title: 'Document collection',
        description:
            'KYC, income, bank, and product-specific support documents required.',
        state: allDocumentsReady
            ? ApprovalState.complete
            : ApprovalState.current,
      ),
      ApprovalStep(
        title: 'Verification',
        description:
            'Identity, income, banking, and collateral validation checks.',
        state: allDocumentsReady
            ? ApprovalState.current
            : ApprovalState.pending,
      ),
      const ApprovalStep(
        title: 'Approval committee',
        description:
            'Final underwriting decision, pricing, and sanction note release.',
        state: ApprovalState.pending,
      ),
      const ApprovalStep(
        title: 'Disbursement',
        description: 'Mandate setup, agreement execution, and funds release.',
        state: ApprovalState.pending,
      ),
    ];
  }

  static List<DocumentRequirement> _buildDocuments({
    required LoanProduct product,
    required LoanApplicationDraft draft,
  }) {
    return List<DocumentRequirement>.generate(
      product.requiredDocuments.length,
      (index) {
        final title = product.requiredDocuments[index];
        if (!draft.readyDocuments.contains(title)) {
          return DocumentRequirement(
            title: title,
            description:
                'Requested by the credit team before verification can begin.',
            state: DocumentState.requested,
          );
        }

        return DocumentRequirement(
          title: title,
          description: index.isEven
              ? 'Uploaded successfully and queued for reviewer validation.'
              : 'Reviewed by operations and accepted in the case file.',
          state: index.isEven ? DocumentState.uploaded : DocumentState.verified,
        );
      },
    );
  }

  static List<RepaymentInstallment> _buildInstallments({
    required double principal,
    required double annualRate,
    required int months,
    required DateTime startDate,
  }) {
    final emi = estimateEmi(
      principal: principal,
      annualRate: annualRate,
      months: months,
    );

    return List<RepaymentInstallment>.generate(min(months, 4), (index) {
      final dueDate = DateTime(startDate.year, startDate.month + index + 1, 5);
      final state = switch (index) {
        0 => InstallmentState.dueSoon,
        1 => InstallmentState.upcoming,
        _ => InstallmentState.upcoming,
      };

      return RepaymentInstallment(
        label: 'EMI ${index + 1}',
        dueDate: dueDate,
        amount: emi,
        state: state,
      );
    });
  }

  static double estimateEmi({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    final monthlyRate = annualRate / 1200;
    if (monthlyRate == 0) {
      return principal / months;
    }
    final factor = pow(1 + monthlyRate, months);
    return principal * monthlyRate * factor / (factor - 1);
  }
}
