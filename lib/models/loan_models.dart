import 'package:flutter/material.dart';

enum LoanType { simple, repayment, bridge }

extension LoanTypeX on LoanType {
  String get code => switch (this) {
    LoanType.simple => 'SPL',
    LoanType.repayment => 'RPL',
    LoanType.bridge => 'BRG',
  };
}

enum ApprovalState { complete, current, pending }

enum DocumentState { requested, uploaded, verified }

enum InstallmentState { paid, dueSoon, upcoming }

class LoanProduct {
  const LoanProduct({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.interestRate,
    required this.minAmount,
    required this.maxAmount,
    required this.suggestedAmount,
    required this.termOptions,
    required this.approvalTime,
    required this.icon,
    required this.accent,
    required this.highlights,
    required this.requiredDocuments,
  });

  final LoanType type;
  final String title;
  final String subtitle;
  final String summary;
  final double interestRate;
  final double minAmount;
  final double maxAmount;
  final double suggestedAmount;
  final List<int> termOptions;
  final String approvalTime;
  final IconData icon;
  final Color accent;
  final List<String> highlights;
  final List<String> requiredDocuments;
}

class LoanApplicationDraft {
  const LoanApplicationDraft({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.governmentId,
    required this.taxId,
    required this.addressLine,
    required this.city,
    required this.employmentType,
    required this.employerName,
    required this.monthlyIncome,
    required this.monthlyObligations,
    required this.bankName,
    required this.accountNumber,
    required this.loanPurpose,
    required this.disbursementWindow,
    required this.collateralDetails,
    required this.hasCoApplicant,
    required this.coApplicantName,
    required this.amount,
    required this.tenureMonths,
    required this.readyDocuments,
  });

  final String fullName;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String governmentId;
  final String taxId;
  final String addressLine;
  final String city;
  final String employmentType;
  final String employerName;
  final double monthlyIncome;
  final double monthlyObligations;
  final String bankName;
  final String accountNumber;
  final String loanPurpose;
  final String disbursementWindow;
  final String collateralDetails;
  final bool hasCoApplicant;
  final String coApplicantName;
  final double amount;
  final int tenureMonths;
  final Set<String> readyDocuments;

  LoanApplicationDraft copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? governmentId,
    String? taxId,
    String? addressLine,
    String? city,
    String? employmentType,
    String? employerName,
    double? monthlyIncome,
    double? monthlyObligations,
    String? bankName,
    String? accountNumber,
    String? loanPurpose,
    String? disbursementWindow,
    String? collateralDetails,
    bool? hasCoApplicant,
    String? coApplicantName,
    double? amount,
    int? tenureMonths,
    Set<String>? readyDocuments,
  }) {
    return LoanApplicationDraft(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      governmentId: governmentId ?? this.governmentId,
      taxId: taxId ?? this.taxId,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      employmentType: employmentType ?? this.employmentType,
      employerName: employerName ?? this.employerName,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyObligations: monthlyObligations ?? this.monthlyObligations,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      loanPurpose: loanPurpose ?? this.loanPurpose,
      disbursementWindow: disbursementWindow ?? this.disbursementWindow,
      collateralDetails: collateralDetails ?? this.collateralDetails,
      hasCoApplicant: hasCoApplicant ?? this.hasCoApplicant,
      coApplicantName: coApplicantName ?? this.coApplicantName,
      amount: amount ?? this.amount,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      readyDocuments: readyDocuments ?? this.readyDocuments,
    );
  }
}

class ApprovalStep {
  const ApprovalStep({
    required this.title,
    required this.description,
    required this.state,
  });

  final String title;
  final String description;
  final ApprovalState state;
}

class DocumentRequirement {
  const DocumentRequirement({
    required this.title,
    required this.description,
    required this.state,
  });

  final String title;
  final String description;
  final DocumentState state;
}

class RepaymentInstallment {
  const RepaymentInstallment({
    required this.label,
    required this.dueDate,
    required this.amount,
    required this.state,
  });

  final String label;
  final DateTime dueDate;
  final double amount;
  final InstallmentState state;
}

class LoanCase {
  const LoanCase({
    required this.applicationId,
    required this.product,
    required this.applicantName,
    required this.amount,
    required this.tenureMonths,
    required this.purpose,
    required this.submittedOn,
    required this.statusLabel,
    required this.statusDetail,
    required this.nextAction,
    required this.monthlyInstallment,
    required this.approvalSteps,
    required this.documents,
    required this.installments,
  });

  final String applicationId;
  final LoanProduct product;
  final String applicantName;
  final double amount;
  final int tenureMonths;
  final String purpose;
  final DateTime submittedOn;
  final String statusLabel;
  final String statusDetail;
  final String nextAction;
  final double monthlyInstallment;
  final List<ApprovalStep> approvalSteps;
  final List<DocumentRequirement> documents;
  final List<RepaymentInstallment> installments;
}
