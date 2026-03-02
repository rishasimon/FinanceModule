import 'package:flutter/material.dart';

import '../data/loan_demo_data.dart';
import '../models/loan_models.dart';
import '../widgets/ui_components.dart';

class ApplyLoanScreen extends StatefulWidget {
  const ApplyLoanScreen({
    super.key,
    required this.products,
    required this.initialType,
    required this.onSubmitted,
  });

  final List<LoanProduct> products;
  final LoanType initialType;
  final ValueChanged<LoanCase> onSubmitted;

  @override
  State<ApplyLoanScreen> createState() => _ApplyLoanScreenState();
}

class _ApplyLoanScreenState extends State<ApplyLoanScreen> {
  static const List<String> _disbursementOptions = [
    'Within 24 hours',
    'Within 5 business days',
    'Within 2 weeks',
    'Flexible timing',
  ];

  static const List<String> _employmentOptions = [
    'Salaried',
    'Self-employed',
    'Business owner',
    'Consultant',
  ];

  final _formKey = GlobalKey<FormState>();
  late LoanProduct _selectedProduct;
  late LoanApplicationDraft _draft;

  @override
  void initState() {
    super.initState();
    _selectedProduct = LoanDemoData.productForType(widget.initialType);
    _draft = LoanDemoData.emptyDraft(_selectedProduct);
  }

  @override
  void didUpdateWidget(covariant ApplyLoanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialType != widget.initialType) {
      _selectProduct(LoanDemoData.productForType(widget.initialType));
    }
  }

  void _selectProduct(LoanProduct product) {
    final retainedDocs = _draft.readyDocuments
        .where(product.requiredDocuments.contains)
        .toSet();
    setState(() {
      _selectedProduct = product;
      _draft = _draft.copyWith(
        amount: product.suggestedAmount,
        tenureMonths: product.termOptions.first,
        loanPurpose: product.type == LoanType.bridge
            ? 'Bridge funding until property settlement clears.'
            : 'Planned borrowing requirement with disciplined monthly repayment.',
        collateralDetails: product.type == LoanType.bridge
            ? _draft.collateralDetails
            : '',
        readyDocuments: retainedDocs,
      );
    });
  }

  void _toggleDocument(String document, bool enabled) {
    final updated = Set<String>.from(_draft.readyDocuments);
    if (enabled) {
      updated.add(document);
    } else {
      updated.remove(document);
    }
    setState(() {
      _draft = _draft.copyWith(readyDocuments: updated);
    });
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final loanCase = LoanDemoData.createCase(
      product: _selectedProduct,
      draft: _draft,
      submittedOn: DateTime.now(),
    );
    widget.onSubmitted(loanCase);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Loan request submitted. ${loanCase.statusLabel} for ${loanCase.applicationId}.',
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
            SectionHeading(
              eyebrow: 'Apply',
              title: 'Capture all borrower, loan, and compliance details',
              subtitle:
                  'The form keeps the primary decisions simple, while extra product-specific information is tucked into expandable sections.',
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 980;
                return Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFormColumn(context),
                            const SizedBox(height: 20),
                            _buildSummaryColumn(context),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child: _buildFormColumn(context)),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 4,
                              child: _buildSummaryColumn(context),
                            ),
                          ],
                        ),
                );
              },
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildFormColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormPanel(
          eyebrow: 'Product Selection',
          title: 'Choose a product with a single tap',
          subtitle:
              'Keep the first step short and clear. Select a product, then complete only the details relevant to that request.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 820;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: widget.products
                    .map(
                      (product) => SizedBox(
                        width: compact
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 16) / 2,
                        child: _SelectableProductCard(
                          product: product,
                          isSelected: product == _selectedProduct,
                          onTap: () => _selectProduct(product),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        _FormPanel(
          eyebrow: 'Loan Request',
          title: 'Choose the amount and basic request settings',
          subtitle:
              'Primary decisions stay visible as cards and buttons. Less-common fields stay under a neat expandable section.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Requested amount: ${AppFormatters.currency(_draft.amount)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Slider(
                value: _draft.amount,
                min: _selectedProduct.minAmount,
                max: _selectedProduct.maxAmount,
                divisions: 8,
                activeColor: _selectedProduct.accent,
                onChanged: (value) {
                  setState(() {
                    _draft = _draft.copyWith(amount: value);
                  });
                },
              ),
              Text(
                '${AppFormatters.currency(_selectedProduct.minAmount)} to ${AppFormatters.currency(_selectedProduct.maxAmount)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              Text('Tenure', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _selectedProduct.termOptions
                    .map(
                      (option) => _OptionButton(
                        label: '$option months',
                        selected: _draft.tenureMonths == option,
                        accent: _selectedProduct.accent,
                        onTap: () {
                          setState(() {
                            _draft = _draft.copyWith(tenureMonths: option);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              TextFormField(
                key: ValueKey('purpose-${_selectedProduct.type.name}'),
                initialValue: _draft.loanPurpose,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Loan purpose'),
                validator: _requiredText,
                onChanged: (value) {
                  _draft = _draft.copyWith(loanPurpose: value);
                },
              ),
              const SizedBox(height: 16),
              _ExpandableSection(
                title: 'More request details',
                subtitle:
                    'Open this only if you want to review disbursement preference and product-specific support information.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferred disbursement',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _disbursementOptions
                          .map(
                            (option) => _OptionButton(
                              label: option,
                              selected: _draft.disbursementWindow == option,
                              accent: _selectedProduct.accent,
                              onTap: () {
                                setState(() {
                                  _draft = _draft.copyWith(
                                    disbursementWindow: option,
                                  );
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    if (_selectedProduct.type == LoanType.bridge) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('bridge-collateral'),
                        initialValue: _draft.collateralDetails,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Collateral or exit plan details',
                        ),
                        validator: _requiredText,
                        onChanged: (value) {
                          _draft = _draft.copyWith(collateralDetails: value);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _FormPanel(
          eyebrow: 'Borrower Details',
          title: 'Identity and contact details',
          subtitle:
              'Keep the main borrower fields visible. Optional co-applicant information appears only when you need it.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResponsiveFields(
                context: context,
                fields: [
                  _field(
                    child: TextFormField(
                      initialValue: _draft.fullName,
                      decoration: const InputDecoration(
                        labelText: 'Full legal name',
                      ),
                      validator: _requiredText,
                      onChanged: (value) {
                        _draft = _draft.copyWith(fullName: value);
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.phone,
                      decoration: const InputDecoration(
                        labelText: 'Mobile number',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 10) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _draft = _draft.copyWith(phone: value);
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.email,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                      ),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _draft = _draft.copyWith(email: value);
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.dateOfBirth,
                      decoration: const InputDecoration(
                        labelText: 'Date of birth',
                      ),
                      validator: _requiredText,
                      onChanged: (value) {
                        _draft = _draft.copyWith(dateOfBirth: value);
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.governmentId,
                      decoration: const InputDecoration(
                        labelText: 'Government ID',
                      ),
                      validator: _requiredText,
                      onChanged: (value) {
                        _draft = _draft.copyWith(governmentId: value);
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.taxId,
                      decoration: const InputDecoration(
                        labelText: 'Tax ID / PAN',
                      ),
                      validator: _requiredText,
                      onChanged: (value) {
                        _draft = _draft.copyWith(taxId: value);
                      },
                    ),
                  ),
                  _field(
                    spanFull: true,
                    child: TextFormField(
                      initialValue: _draft.addressLine,
                      decoration: const InputDecoration(
                        labelText: 'Address line',
                      ),
                      validator: _requiredText,
                      onChanged: (value) {
                        _draft = _draft.copyWith(addressLine: value);
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.city,
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: _requiredText,
                      onChanged: (value) {
                        _draft = _draft.copyWith(city: value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Co-applicant',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _OptionButton(
                    label: 'No co-applicant',
                    selected: !_draft.hasCoApplicant,
                    accent: _selectedProduct.accent,
                    onTap: () {
                      setState(() {
                        _draft = _draft.copyWith(
                          hasCoApplicant: false,
                          coApplicantName: '',
                        );
                      });
                    },
                  ),
                  _OptionButton(
                    label: 'Add co-applicant',
                    selected: _draft.hasCoApplicant,
                    accent: _selectedProduct.accent,
                    onTap: () {
                      setState(() {
                        _draft = _draft.copyWith(hasCoApplicant: true);
                      });
                    },
                  ),
                ],
              ),
              if (_draft.hasCoApplicant) ...[
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _draft.coApplicantName,
                  decoration: const InputDecoration(
                    labelText: 'Co-applicant full name',
                  ),
                  validator: _requiredText,
                  onChanged: (value) {
                    _draft = _draft.copyWith(coApplicantName: value);
                  },
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        _FormPanel(
          eyebrow: 'Financial Profile',
          title: 'Income and banking details',
          subtitle:
              'Use quick buttons for employment type, then complete the required affordability and payout details.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Employment type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _employmentOptions
                    .map(
                      (option) => _OptionButton(
                        label: option,
                        selected: _draft.employmentType == option,
                        accent: _selectedProduct.accent,
                        onTap: () {
                          setState(() {
                            _draft = _draft.copyWith(employmentType: option);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              _buildResponsiveFields(
                context: context,
                fields: [
                  _field(
                    child: TextFormField(
                      initialValue: _draft.employerName,
                      decoration: const InputDecoration(
                        labelText: 'Employer / business name',
                      ),
                      validator: _requiredText,
                      onChanged: (value) {
                        _draft = _draft.copyWith(employerName: value);
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.monthlyIncome.toStringAsFixed(0),
                      decoration: const InputDecoration(
                        labelText: 'Monthly net income',
                      ),
                      keyboardType: TextInputType.number,
                      validator: _requiredAmount,
                      onChanged: (value) {
                        _draft = _draft.copyWith(
                          monthlyIncome: double.tryParse(value) ?? 0,
                        );
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.monthlyObligations.toStringAsFixed(
                        0,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Existing monthly obligations',
                      ),
                      keyboardType: TextInputType.number,
                      validator: _requiredAmount,
                      onChanged: (value) {
                        _draft = _draft.copyWith(
                          monthlyObligations: double.tryParse(value) ?? 0,
                        );
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.bankName,
                      decoration: const InputDecoration(labelText: 'Bank name'),
                      validator: _requiredText,
                      onChanged: (value) {
                        _draft = _draft.copyWith(bankName: value);
                      },
                    ),
                  ),
                  _field(
                    child: TextFormField(
                      initialValue: _draft.accountNumber,
                      decoration: const InputDecoration(
                        labelText: 'Account number',
                      ),
                      validator: _requiredText,
                      onChanged: (value) {
                        _draft = _draft.copyWith(accountNumber: value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _FormPanel(
          eyebrow: 'Required Documents',
          title: 'Document checklist',
          subtitle:
              'Tick the documents already ready for upload. Missing items will stay pending in the approval workflow.',
          child: Column(
            children: _selectedProduct.requiredDocuments
                .map(
                  (document) => CheckboxListTile(
                    value: _draft.readyDocuments.contains(document),
                    title: Text(document),
                    subtitle: const Text(
                      'Mark this when the borrower can provide it now.',
                    ),
                    activeColor: _selectedProduct.accent,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) =>
                        _toggleDocument(document, value ?? false),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveFields({
    required BuildContext context,
    required List<_FieldItem> fields,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final halfWidth = compact
            ? constraints.maxWidth
            : (constraints.maxWidth - 16) / 2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: fields
              .map(
                (field) => SizedBox(
                  width: field.spanFull ? constraints.maxWidth : halfWidth,
                  child: field.child,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildSummaryColumn(BuildContext context) {
    final emi = LoanDemoData.estimateEmi(
      principal: _draft.amount,
      annualRate: _selectedProduct.interestRate,
      months: _draft.tenureMonths,
    );

    return Column(
      children: [
        FrostPanel(
          accent: _selectedProduct.accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request summary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 18),
              DetailLine(label: 'Loan product', value: _selectedProduct.title),
              const SizedBox(height: 12),
              DetailLine(
                label: 'Requested amount',
                value: AppFormatters.currency(_draft.amount),
              ),
              const SizedBox(height: 12),
              DetailLine(
                label: 'Tenure',
                value: '${_draft.tenureMonths} months',
              ),
              const SizedBox(height: 12),
              DetailLine(
                label: 'Disbursement',
                value: _draft.disbursementWindow,
              ),
              const SizedBox(height: 12),
              DetailLine(
                label: 'Estimated EMI',
                value: AppFormatters.currency(emi),
              ),
              const SizedBox(height: 12),
              DetailLine(
                label: 'Documents ready',
                value:
                    '${_draft.readyDocuments.length}/${_selectedProduct.requiredDocuments.length}',
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedProduct.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'After submission the case will move through intake review, document collection, verification, approval committee, and disbursement.',
                  style: TextStyle(
                    color: _selectedProduct.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedProduct.accent,
                  ),
                  onPressed: _submit,
                  child: const Text('Submit loan request'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FrostPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Approval readiness notes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const _ReadinessLine(
                title: 'Simple selection',
                body:
                    'Main choices use clean buttons instead of dense dropdown fields.',
              ),
              const SizedBox(height: 14),
              const _ReadinessLine(
                title: 'More details',
                body:
                    'Secondary request settings stay inside an expandable section to keep the form neat.',
              ),
              const SizedBox(height: 14),
              const _ReadinessLine(
                title: 'Pending status',
                body:
                    'Any unchecked document stays visible as required after submission.',
              ),
              const SizedBox(height: 14),
              const _ReadinessLine(
                title: 'Verification',
                body:
                    'Uploaded files move into verification before the application can be approved.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  _FieldItem _field({required Widget child, bool spanFull = false}) {
    return _FieldItem(child: child, spanFull: spanFull);
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _requiredAmount(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid amount';
    }
    return null;
  }
}

class _FieldItem {
  const _FieldItem({required this.child, this.spanFull = false});

  final Widget child;
  final bool spanFull;
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(eyebrow: eyebrow, title: title, subtitle: subtitle),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _SelectableProductCard extends StatelessWidget {
  const _SelectableProductCard({
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  final LoanProduct product;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? product.accent.withValues(alpha: 0.1)
              : const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? product.accent : const Color(0xFFE1E8F0),
            width: isSelected ? 1.6 : 1,
          ),
        ),
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(product.icon, color: product.accent),
                ),
                const Spacer(),
                if (isSelected)
                  StatusBadge(label: 'Selected', color: product.accent),
              ],
            ),
            const SizedBox(height: 14),
            Text(product.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              product.subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
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
          ],
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.12)
              : const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? accent : const Color(0xFFE1E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? accent : const Color(0xFF42566E),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ExpandableSection extends StatelessWidget {
  const _ExpandableSection({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE1E8F0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          children: [child],
        ),
      ),
    );
  }
}

class _ReadinessLine extends StatelessWidget {
  const _ReadinessLine({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          TextSpan(
            text: '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF112846),
            ),
          ),
          TextSpan(text: body),
        ],
      ),
    );
  }
}
