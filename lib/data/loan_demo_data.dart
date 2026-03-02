import 'dart:math';

import 'package:flutter/material.dart';

import '../models/loan_models.dart';

class LoanDemoData {
  static const Color midnight = Color(0xFF12345A);
  static const Color emerald = Color(0xFF14866D);
  static const Color amber = Color(0xFFC5892F);
  static const Color coral = Color(0xFFC65E46);
  static const Color indigo = Color(0xFF4A5AC7);

  static final List<LoanProduct> products = [
    LoanProduct(
      type: LoanType.home,
      title: 'Home Loan',
      subtitle: 'Purchase, construction, or balance transfer for a property',
      summary:
          'A long-tenure secured loan for buying or improving residential property with stronger document controls and lower pricing.',
      interestRate: 8.4,
      minAmount: 500000,
      maxAmount: 15000000,
      suggestedAmount: 4200000,
      termOptions: const [60, 120, 180, 240, 300],
      approvalTime: '2 to 4 working days',
      icon: Icons.home_work_rounded,
      accent: midnight,
      highlights: const [
        'Best suited for salaried and self-employed property buyers',
        'Eligibility visibility before property underwriting starts',
        'Property and applicant documents tracked in one workflow',
      ],
      requiredDocuments: const [
        LoanDocumentTemplate(
          id: 'home_kyc',
          title: 'Applicant KYC',
          description: 'Government ID and recent address proof for applicant.',
          groupLabel: 'KYC',
        ),
        LoanDocumentTemplate(
          id: 'home_income',
          title: 'Income proof',
          description: 'Latest salary slips or audited income statements.',
          groupLabel: 'Income',
        ),
        LoanDocumentTemplate(
          id: 'home_bank',
          title: 'Bank statements',
          description: 'Last 12 months primary bank account statements.',
          groupLabel: 'Banking',
        ),
        LoanDocumentTemplate(
          id: 'home_property',
          title: 'Property agreement',
          description: 'Sale agreement, allotment letter, or property papers.',
          groupLabel: 'Property',
        ),
        LoanDocumentTemplate(
          id: 'home_valuation',
          title: 'Property valuation',
          description: 'Valuation or technical review report if available.',
          groupLabel: 'Property',
        ),
      ],
    ),
    LoanProduct(
      type: LoanType.education,
      title: 'Education Loan',
      subtitle: 'Tuition and living-cost funding for higher studies',
      summary:
          'A structured education loan flow that captures student, institute, and co-applicant documents separately for faster underwriting.',
      interestRate: 9.1,
      minAmount: 100000,
      maxAmount: 4500000,
      suggestedAmount: 1200000,
      termOptions: const [24, 48, 72, 96, 120],
      approvalTime: '24-hour academic pre-check',
      icon: Icons.school_rounded,
      accent: emerald,
      highlights: const [
        'Designed for domestic and international admissions',
        'Separate visibility for student and co-applicant documents',
        'Tracks admission, fees, and financial support in one view',
      ],
      requiredDocuments: const [
        LoanDocumentTemplate(
          id: 'edu_kyc',
          title: 'Student and co-applicant KYC',
          description: 'Identity and address proof for both parties.',
          groupLabel: 'KYC',
        ),
        LoanDocumentTemplate(
          id: 'edu_admission',
          title: 'Admission letter',
          description: 'Confirmed admission or offer letter from institution.',
          groupLabel: 'Academic',
        ),
        LoanDocumentTemplate(
          id: 'edu_fee',
          title: 'Fee structure',
          description: 'Program fee breakup and estimated study expenses.',
          groupLabel: 'Academic',
        ),
        LoanDocumentTemplate(
          id: 'edu_income',
          title: 'Co-applicant income proof',
          description: 'Salary slips, ITR, or business income documents.',
          groupLabel: 'Income',
        ),
        LoanDocumentTemplate(
          id: 'edu_marksheets',
          title: 'Academic records',
          description: 'Recent marksheets, transcripts, or graduation records.',
          groupLabel: 'Academic',
        ),
      ],
    ),
    LoanProduct(
      type: LoanType.vehicle,
      title: 'Vehicle Loan',
      subtitle: 'Financing for new cars, bikes, and commercial vehicles',
      summary:
          'A fast-moving secured flow for vehicle purchases with quotation, KYC, and affordability checks built into the request journey.',
      interestRate: 9.8,
      minAmount: 80000,
      maxAmount: 2500000,
      suggestedAmount: 650000,
      termOptions: const [12, 24, 36, 48, 60, 72],
      approvalTime: 'Same-day dealer lane decision',
      icon: Icons.directions_car_filled_rounded,
      accent: amber,
      highlights: const [
        'Supports retail and small fleet purchases',
        'Dealer quotation and RC-related checks stay visible',
        'Fast underwriting for low-document salaried borrowers',
      ],
      requiredDocuments: const [
        LoanDocumentTemplate(
          id: 'veh_kyc',
          title: 'Applicant KYC',
          description: 'Government ID and current address proof.',
          groupLabel: 'KYC',
        ),
        LoanDocumentTemplate(
          id: 'veh_income',
          title: 'Income proof',
          description: 'Recent salary slips or income tax return.',
          groupLabel: 'Income',
        ),
        LoanDocumentTemplate(
          id: 'veh_bank',
          title: 'Bank statements',
          description: 'Last 6 months of salary or operating account activity.',
          groupLabel: 'Banking',
        ),
        LoanDocumentTemplate(
          id: 'veh_quote',
          title: 'Vehicle quotation',
          description: 'Dealer quotation or proforma invoice.',
          groupLabel: 'Asset',
        ),
        LoanDocumentTemplate(
          id: 'veh_license',
          title: 'Driving license',
          description: 'License copy if already issued for the applicant.',
          groupLabel: 'KYC',
        ),
      ],
    ),
    LoanProduct(
      type: LoanType.personal,
      title: 'Personal Loan',
      subtitle: 'Flexible unsecured credit for planned expenses',
      summary:
          'An unsecured loan designed for short-to-mid term needs like travel, medical costs, or household upgrades with a lightweight application flow.',
      interestRate: 11.6,
      minAmount: 50000,
      maxAmount: 2000000,
      suggestedAmount: 250000,
      termOptions: const [12, 24, 36, 48, 60],
      approvalTime: 'Instant eligibility with same-day review',
      icon: Icons.account_balance_wallet_rounded,
      accent: coral,
      highlights: const [
        'No collateral required for eligible borrowers',
        'Simple document checklist with clear pending status',
        'Best for urgent but planned funding needs',
      ],
      requiredDocuments: const [
        LoanDocumentTemplate(
          id: 'per_kyc',
          title: 'Applicant KYC',
          description: 'Government-issued identity and address proof.',
          groupLabel: 'KYC',
        ),
        LoanDocumentTemplate(
          id: 'per_income',
          title: 'Salary slips',
          description: 'Latest 3 months salary slips or proof of income.',
          groupLabel: 'Income',
        ),
        LoanDocumentTemplate(
          id: 'per_bank',
          title: 'Bank statements',
          description: 'Primary bank statements for the last 6 months.',
          groupLabel: 'Banking',
        ),
        LoanDocumentTemplate(
          id: 'per_employment',
          title: 'Employment proof',
          description: 'Employee ID, offer letter, or HR confirmation.',
          groupLabel: 'Employment',
        ),
      ],
    ),
    LoanProduct(
      type: LoanType.business,
      title: 'Business Loan',
      subtitle: 'Working capital and growth financing for SMEs',
      summary:
          'A business lending workflow that keeps promoter, company, banking, and compliance documents clearly separated for local processing.',
      interestRate: 12.2,
      minAmount: 250000,
      maxAmount: 5000000,
      suggestedAmount: 1500000,
      termOptions: const [12, 24, 36, 48, 60],
      approvalTime: '48-hour underwriting window',
      icon: Icons.storefront_rounded,
      accent: indigo,
      highlights: const [
        'Useful for inventory, expansion, and cash-flow smoothing',
        'Tracks promoter KYC and business compliance separately',
        'Supports document-heavy cases without cluttering the form',
      ],
      requiredDocuments: const [
        LoanDocumentTemplate(
          id: 'bus_promoter',
          title: 'Promoter KYC',
          description: 'Identity and address proof for key promoters.',
          groupLabel: 'KYC',
        ),
        LoanDocumentTemplate(
          id: 'bus_entity',
          title: 'Business registration',
          description: 'GST, incorporation, or shop establishment papers.',
          groupLabel: 'Compliance',
        ),
        LoanDocumentTemplate(
          id: 'bus_bank',
          title: 'Business bank statements',
          description: 'Operating account statements for the last 12 months.',
          groupLabel: 'Banking',
        ),
        LoanDocumentTemplate(
          id: 'bus_itr',
          title: 'ITR and financials',
          description: 'ITR, P&L, balance sheet, or audited statements.',
          groupLabel: 'Financials',
        ),
        LoanDocumentTemplate(
          id: 'bus_vintage',
          title: 'Business vintage proof',
          description: 'Invoices, contracts, or tax filings showing activity.',
          groupLabel: 'Operations',
        ),
      ],
    ),
  ];

  static LoanApplicationDraft emptyDraft(LoanProduct product) {
    return LoanApplicationDraft(
      fullName: '',
      email: '',
      phone: '',
      dateOfBirth: '',
      governmentId: '',
      taxId: '',
      addressLine: '',
      city: '',
      employmentType: 'Salaried',
      employerName: '',
      monthlyIncome: 0,
      monthlyObligations: 0,
      bankName: '',
      accountNumber: '',
      loanPurpose: '',
      disbursementWindow: 'Within 5 business days',
      collateralDetails: '',
      hasCoApplicant: product.type == LoanType.education,
      coApplicantName: '',
      amount: product.suggestedAmount,
      tenureMonths: product.termOptions.first,
      documentSelections: _emptyDocumentSelections(product),
    );
  }

  static List<LoanCase> get seededCases {
    final homeProduct = productForType(LoanType.home);
    final educationProduct = productForType(LoanType.education);
    final vehicleProduct = productForType(LoanType.vehicle);

    return [
      createCase(
        product: homeProduct,
        draft: _buildSeedDraft(
          product: homeProduct,
          phone: '+91 98765 41230',
          fullName: 'Nisha Sharma',
          purpose: 'Purchase of a ready-to-move 2BHK apartment.',
          amount: 5400000,
          tenureMonths: 240,
          attachmentsByDocumentId: {
            'home_kyc': _attachment('nisha_kyc_bundle.pdf', '1.2 MB'),
            'home_income': _attachment('salary_slips_q4.pdf', '780 KB'),
            'home_bank': _attachment('salary_account_12m.pdf', '2.6 MB'),
            'home_property': _attachment('sale_agreement.pdf', '3.1 MB'),
            'home_valuation': _attachment('valuation_report.pdf', '1.4 MB'),
          },
        ),
        submittedOn: DateTime(2026, 2, 14),
        statusOverride: LoanCaseStatus.active,
      ),
      createCase(
        product: educationProduct,
        draft: _buildSeedDraft(
          product: educationProduct,
          phone: '+91 99881 11221',
          fullName: 'Rahul Iyer',
          purpose:
              'Masters tuition and living expense support for 2026 intake.',
          amount: 1650000,
          tenureMonths: 84,
          attachmentsByDocumentId: {
            'edu_kyc': _attachment('student_and_parent_kyc.pdf', '990 KB'),
            'edu_admission': _attachment('offer_letter.pdf', '420 KB'),
            'edu_fee': _attachment('fee_structure.pdf', '310 KB'),
            'edu_income': _attachment('parent_income_pack.pdf', '1.8 MB'),
            'edu_marksheets': _attachment('transcripts.pdf', '860 KB'),
          },
        ),
        submittedOn: DateTime(2026, 2, 20),
        statusOverride: LoanCaseStatus.approved,
      ),
      createCase(
        product: vehicleProduct,
        draft: _buildSeedDraft(
          product: vehicleProduct,
          phone: '+91 99110 88552',
          fullName: 'Dev Bansal',
          purpose: 'Purchase of a new compact SUV for family use.',
          amount: 880000,
          tenureMonths: 60,
          attachmentsByDocumentId: {
            'veh_kyc': _attachment('dev_kyc.pdf', '540 KB'),
            'veh_income': _attachment('income_pack.pdf', '720 KB'),
            'veh_quote': _attachment('dealer_quote.pdf', '280 KB'),
          },
        ),
        submittedOn: DateTime(2026, 2, 28),
      ),
    ];
  }

  static LoanProduct productForType(LoanType type) {
    return products.firstWhere((product) => product.type == type);
  }

  static LoanCase createCase({
    required LoanProduct product,
    required LoanApplicationDraft draft,
    DateTime? submittedOn,
    LoanCaseStatus? statusOverride,
  }) {
    final submittedDate = submittedOn ?? DateTime.now();
    final inferredStatus = statusOverride ?? _inferStatus(draft, product);
    final documents = _buildDocuments(
      product: product,
      draft: draft,
      status: inferredStatus,
    );
    final statusCopy = _buildStatusCopy(
      status: inferredStatus,
      pendingDocumentCount: documents
          .where((document) => document.state == DocumentState.requested)
          .length,
    );

    final digits = draft.phone.replaceAll(RegExp(r'\D'), '');
    final suffix = digits.isEmpty
        ? '0000'
        : digits.substring(max(0, digits.length - 4));

    return LoanCase(
      applicationId:
          '${product.type.code}-${submittedDate.year}${submittedDate.month.toString().padLeft(2, '0')}${submittedDate.day.toString().padLeft(2, '0')}-$suffix',
      product: product,
      applicantName: draft.fullName,
      amount: draft.amount,
      tenureMonths: draft.tenureMonths,
      purpose: draft.loanPurpose,
      submittedOn: submittedDate,
      status: inferredStatus,
      statusLabel: statusCopy.label,
      statusDetail: statusCopy.detail,
      nextAction: statusCopy.nextAction,
      monthlyInstallment: estimateEmi(
        principal: draft.amount,
        annualRate: product.interestRate,
        months: draft.tenureMonths,
      ),
      approvalSteps: _buildApprovalSteps(inferredStatus),
      documents: documents,
      installments: _buildInstallments(
        principal: draft.amount,
        annualRate: product.interestRate,
        months: draft.tenureMonths,
        startDate: submittedDate,
        status: inferredStatus,
      ),
    );
  }

  static LoanCase restoreCase(Map<String, dynamic> json) {
    final loanTypeName = json['loanType'] as String? ?? LoanType.personal.name;
    final product = productForType(
      LoanType.values.firstWhere(
        (type) => type.name == loanTypeName,
        orElse: () => LoanType.personal,
      ),
    );
    final statusName =
        json['status'] as String? ?? LoanCaseStatus.documentsPending.name;
    final status = LoanCaseStatus.values.firstWhere(
      (value) => value.name == statusName,
      orElse: () => LoanCaseStatus.documentsPending,
    );
    final submittedOn =
        DateTime.tryParse(json['submittedOn'] as String? ?? '') ??
        DateTime.now();
    final documentsJson = (json['documents'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final documents = documentsJson
        .map((item) {
          final stateName =
              item['state'] as String? ?? DocumentState.requested.name;
          final state = DocumentState.values.firstWhere(
            (value) => value.name == stateName,
            orElse: () => DocumentState.requested,
          );
          return DocumentRequirement(
            id: item['id'] as String? ?? '',
            title: item['title'] as String? ?? '',
            description: item['description'] as String? ?? '',
            groupLabel: item['groupLabel'] as String? ?? '',
            state: state,
            attachment: item['attachment'] == null
                ? null
                : LocalDocumentFile.fromJson(
                    Map<String, dynamic>.from(item['attachment'] as Map),
                  ),
          );
        })
        .toList(growable: false);
    final statusCopy = _buildStatusCopy(
      status: status,
      pendingDocumentCount: documents
          .where((document) => document.state == DocumentState.requested)
          .length,
    );

    return LoanCase(
      applicationId: json['applicationId'] as String? ?? '',
      product: product,
      applicantName: json['applicantName'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? product.suggestedAmount,
      tenureMonths:
          (json['tenureMonths'] as num?)?.toInt() ?? product.termOptions.first,
      purpose: json['purpose'] as String? ?? '',
      submittedOn: submittedOn,
      status: status,
      statusLabel: statusCopy.label,
      statusDetail: statusCopy.detail,
      nextAction: statusCopy.nextAction,
      monthlyInstallment: estimateEmi(
        principal:
            (json['amount'] as num?)?.toDouble() ?? product.suggestedAmount,
        annualRate: product.interestRate,
        months:
            (json['tenureMonths'] as num?)?.toInt() ??
            product.termOptions.first,
      ),
      approvalSteps: _buildApprovalSteps(status),
      documents: documents,
      installments: _buildInstallments(
        principal:
            (json['amount'] as num?)?.toDouble() ?? product.suggestedAmount,
        annualRate: product.interestRate,
        months:
            (json['tenureMonths'] as num?)?.toInt() ??
            product.termOptions.first,
        startDate: submittedOn,
        status: status,
      ),
    );
  }

  static Map<String, DraftDocumentSelection> _emptyDocumentSelections(
    LoanProduct product,
  ) {
    return {
      for (final document in product.requiredDocuments)
        document.id: const DraftDocumentSelection(),
    };
  }

  static LoanApplicationDraft _buildSeedDraft({
    required LoanProduct product,
    required String phone,
    required String fullName,
    required String purpose,
    required double amount,
    required int tenureMonths,
    required Map<String, LocalDocumentFile> attachmentsByDocumentId,
  }) {
    final base = emptyDraft(product);
    return base.copyWith(
      phone: phone,
      fullName: fullName,
      loanPurpose: purpose,
      amount: amount,
      tenureMonths: tenureMonths,
      documentSelections: {
        for (final document in product.requiredDocuments)
          document.id: DraftDocumentSelection(
            selectedForUpload: attachmentsByDocumentId.containsKey(document.id),
            attachment: attachmentsByDocumentId[document.id],
          ),
      },
    );
  }

  static LocalDocumentFile _attachment(String fileName, String sizeLabel) {
    return LocalDocumentFile(
      fileName: fileName,
      sizeLabel: sizeLabel,
      uploadedAt: DateTime(2026, 3, 2, 10, 30),
    );
  }

  static LoanCaseStatus _inferStatus(
    LoanApplicationDraft draft,
    LoanProduct product,
  ) {
    final allRequiredUploaded = product.requiredDocuments.every((document) {
      final selection = draft.documentSelections[document.id];
      return selection?.attachment != null;
    });
    return allRequiredUploaded
        ? LoanCaseStatus.underReview
        : LoanCaseStatus.documentsPending;
  }

  static List<ApprovalStep> _buildApprovalSteps(LoanCaseStatus status) {
    final documentState = switch (status) {
      LoanCaseStatus.documentsPending => ApprovalState.current,
      LoanCaseStatus.underReview => ApprovalState.complete,
      LoanCaseStatus.approved => ApprovalState.complete,
      LoanCaseStatus.active => ApprovalState.complete,
    };
    final verificationState = switch (status) {
      LoanCaseStatus.documentsPending => ApprovalState.pending,
      LoanCaseStatus.underReview => ApprovalState.current,
      LoanCaseStatus.approved => ApprovalState.complete,
      LoanCaseStatus.active => ApprovalState.complete,
    };
    final approvalState = switch (status) {
      LoanCaseStatus.documentsPending => ApprovalState.pending,
      LoanCaseStatus.underReview => ApprovalState.pending,
      LoanCaseStatus.approved => ApprovalState.complete,
      LoanCaseStatus.active => ApprovalState.complete,
    };
    final disbursementState = switch (status) {
      LoanCaseStatus.active => ApprovalState.complete,
      LoanCaseStatus.approved => ApprovalState.current,
      LoanCaseStatus.documentsPending => ApprovalState.pending,
      LoanCaseStatus.underReview => ApprovalState.pending,
    };

    return [
      const ApprovalStep(
        title: 'Application submitted',
        description:
            'Borrower profile, amount request, and declarations received.',
        state: ApprovalState.complete,
      ),
      const ApprovalStep(
        title: 'Eligibility screening',
        description:
            'Product fit, debt ratio, and minimum underwriting checks.',
        state: ApprovalState.complete,
      ),
      ApprovalStep(
        title: 'Document center',
        description:
            'KYC, income, banking, and product-specific files are reviewed here.',
        state: documentState,
      ),
      ApprovalStep(
        title: 'Verification',
        description:
            'Identity, affordability, academic, asset, or business validation.',
        state: verificationState,
      ),
      ApprovalStep(
        title: 'Approval decision',
        description:
            'Credit pricing, sanction checks, and underwriting sign-off.',
        state: approvalState,
      ),
      ApprovalStep(
        title: 'Disbursement and servicing',
        description:
            'Agreement execution, payout setup, and repayment activation.',
        state: disbursementState,
      ),
    ];
  }

  static List<DocumentRequirement> _buildDocuments({
    required LoanProduct product,
    required LoanApplicationDraft draft,
    required LoanCaseStatus status,
  }) {
    return List<
      DocumentRequirement
    >.generate(product.requiredDocuments.length, (index) {
      final template = product.requiredDocuments[index];
      final selection = draft.documentSelections[template.id];
      final attachment = selection?.attachment;

      if (status == LoanCaseStatus.approved ||
          status == LoanCaseStatus.active) {
        return DocumentRequirement(
          id: template.id,
          title: template.title,
          description:
              '${template.description} Reviewed and accepted by operations.',
          groupLabel: template.groupLabel,
          state: DocumentState.verified,
          attachment: attachment,
        );
      }

      if (attachment == null) {
        return DocumentRequirement(
          id: template.id,
          title: template.title,
          description:
              '${template.description} Still required before the case can progress.',
          groupLabel: template.groupLabel,
          state: DocumentState.requested,
        );
      }

      final state = index.isEven
          ? DocumentState.uploaded
          : DocumentState.verified;
      final stateCopy = state == DocumentState.uploaded
          ? 'Uploaded locally and queued for verification.'
          : 'Reviewed and accepted in the local case file.';

      return DocumentRequirement(
        id: template.id,
        title: template.title,
        description: '${template.description} $stateCopy',
        groupLabel: template.groupLabel,
        state: state,
        attachment: attachment,
      );
    });
  }

  static List<RepaymentInstallment> _buildInstallments({
    required double principal,
    required double annualRate,
    required int months,
    required DateTime startDate,
    required LoanCaseStatus status,
  }) {
    final emi = estimateEmi(
      principal: principal,
      annualRate: annualRate,
      months: months,
    );

    return List<RepaymentInstallment>.generate(min(months, 4), (index) {
      final dueDate = DateTime(startDate.year, startDate.month + index + 1, 5);
      final state = switch (status) {
        LoanCaseStatus.active => switch (index) {
          0 => InstallmentState.paid,
          1 => InstallmentState.dueSoon,
          _ => InstallmentState.upcoming,
        },
        LoanCaseStatus.approved => switch (index) {
          0 => InstallmentState.dueSoon,
          _ => InstallmentState.upcoming,
        },
        LoanCaseStatus.documentsPending => InstallmentState.upcoming,
        LoanCaseStatus.underReview => InstallmentState.upcoming,
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

class _StatusCopy {
  const _StatusCopy({
    required this.label,
    required this.detail,
    required this.nextAction,
  });

  final String label;
  final String detail;
  final String nextAction;
}

_StatusCopy _buildStatusCopy({
  required LoanCaseStatus status,
  required int pendingDocumentCount,
}) {
  return switch (status) {
    LoanCaseStatus.documentsPending => _StatusCopy(
      label: 'Pending documents',
      detail:
          '$pendingDocumentCount required documents still need to be uploaded before verification starts.',
      nextAction:
          'Collect the missing files in the document center to move this request into review.',
    ),
    LoanCaseStatus.underReview => const _StatusCopy(
      label: 'Under review',
      detail:
          'The local case file is complete and underwriting checks are now in progress.',
      nextAction:
          'Operations is validating documents, affordability, and product fit.',
    ),
    LoanCaseStatus.approved => const _StatusCopy(
      label: 'Approved',
      detail:
          'Credit approval is complete and the loan is waiting for final acceptance or disbursement setup.',
      nextAction:
          'Share sanction acceptance and complete payout setup to activate the loan.',
    ),
    LoanCaseStatus.active => const _StatusCopy(
      label: 'Active loan',
      detail:
          'The loan is live and repayment servicing has started with verified documents on file.',
      nextAction:
          'Track EMIs, review documents, and surface servicing updates from one page.',
    ),
  };
}
