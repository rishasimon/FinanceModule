import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
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
  final Future<void> Function(LoanCase) onSubmitted;

  @override
  State<ApplyLoanScreen> createState() => _ApplyLoanScreenState();
}

class _ApplyLoanScreenState extends State<ApplyLoanScreen> {
  static const List<String> _employmentOptions = [
    'Salaried',
    'Self-employed',
    'Business owner',
    'Consultant',
  ];

  final _formKey = GlobalKey<FormState>();
  late LoanProduct _selectedProduct;
  late LoanApplicationDraft _draft;
  bool _isSubmitting = false;

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

  bool get _needsAdditionalSecurity =>
      _selectedProduct.type == LoanType.home ||
      _selectedProduct.type == LoanType.business;

  void _selectProduct(LoanProduct product) {
    final retainedSelections = <String, DraftDocumentSelection>{};
    for (final document in product.requiredDocuments) {
      retainedSelections[document.id] =
          _draft.documentSelections[document.id] ??
          const DraftDocumentSelection();
    }

    setState(() {
      _selectedProduct = product;
      _draft = LoanDemoData.emptyDraft(product).copyWith(
        amount:
            _draft.amount >= product.minAmount &&
                _draft.amount <= product.maxAmount
            ? _draft.amount
            : product.suggestedAmount,
        fullName: _draft.fullName,
        email: _draft.email,
        phone: _draft.phone,
        loanPurpose: _draft.loanPurpose,
        employmentType: _draft.employmentType,
        employerName: _draft.employerName,
        monthlyIncome: _draft.monthlyIncome,
        monthlyObligations: _draft.monthlyObligations,
        bankName: _draft.bankName,
        accountNumber: _draft.accountNumber,
        dateOfBirth: _draft.dateOfBirth,
        governmentId: _draft.governmentId,
        taxId: _draft.taxId,
        addressLine: _draft.addressLine,
        city: _draft.city,
        collateralDetails: _draft.collateralDetails,
        hasCoApplicant: product.type == LoanType.education
            ? true
            : _draft.hasCoApplicant,
        coApplicantName: _draft.coApplicantName,
        documentSelections: retainedSelections,
      );
    });
  }

  DraftDocumentSelection _selectionFor(String documentId) {
    return _draft.documentSelections[documentId] ??
        const DraftDocumentSelection();
  }

  void _toggleDocument(String documentId, bool selected) {
    final updated = Map<String, DraftDocumentSelection>.from(
      _draft.documentSelections,
    );
    final current = _selectionFor(documentId);
    updated[documentId] = selected
        ? current.copyWith(selectedForUpload: true)
        : const DraftDocumentSelection();

    setState(() {
      _draft = _draft.copyWith(documentSelections: updated);
    });
  }

  Future<void> _pickDocument(LoanDocumentTemplate document) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: false,
    );
    if (!mounted || result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.single;
    final updated = Map<String, DraftDocumentSelection>.from(
      _draft.documentSelections,
    );
    updated[document.id] = DraftDocumentSelection(
      selectedForUpload: true,
      attachment: LocalDocumentFile(
        fileName: file.name,
        sizeLabel: _formatFileSize(file.size),
        uploadedAt: DateTime.now(),
        path: file.path,
      ),
    );

    setState(() {
      _draft = _draft.copyWith(documentSelections: updated);
    });
  }

  void _removeDocument(String documentId) {
    final updated = Map<String, DraftDocumentSelection>.from(
      _draft.documentSelections,
    );
    updated[documentId] = DraftDocumentSelection(
      selectedForUpload: true,
      attachment: null,
    );

    setState(() {
      _draft = _draft.copyWith(documentSelections: updated);
    });
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final missingPickedFiles = _selectedProduct.requiredDocuments
        .where((doc) {
          final selection = _selectionFor(doc.id);
          return selection.selectedForUpload && selection.attachment == null;
        })
        .toList(growable: false);

    if (missingPickedFiles.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Pick a file for ${missingPickedFiles.first.title}.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final loanCase = LoanDemoData.createCase(
        product: _selectedProduct,
        draft: _draft,
        submittedOn: DateTime.now(),
      );
      await widget.onSubmitted(loanCase);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Loan saved locally as ${loanCase.applicationId}.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentShell(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              eyebrow: 'Apply',
              title: 'New loan request',
              subtitle: 'Choose a loan, fill the basics, and upload documents.',
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 980;
                  return compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMainColumn(context),
                            const SizedBox(height: 18),
                            _buildSummaryColumn(context),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child: _buildMainColumn(context)),
                            const SizedBox(width: 18),
                            Expanded(
                              flex: 4,
                              child: _buildSummaryColumn(context),
                            ),
                          ],
                        );
                },
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildMainColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FrostPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loan type',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 760;
                  final itemWidth = compact
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: widget.products
                        .map(
                          (product) => SizedBox(
                            width: itemWidth,
                            child: _LoanTypeCard(
                              product: product,
                              selected: product.type == _selectedProduct.type,
                              onTap: () => _selectProduct(product),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FrostPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Basic details',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _buildFieldGrid(
                context: context,
                children: [
                  _buildTextField(
                    label: 'Full name',
                    initialValue: _draft.fullName,
                    validator: _requiredText,
                    onChanged: (value) =>
                        _draft = _draft.copyWith(fullName: value),
                  ),
                  _buildTextField(
                    label: 'Phone',
                    initialValue: _draft.phone,
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                    onChanged: (value) =>
                        _draft = _draft.copyWith(phone: value),
                  ),
                  _buildTextField(
                    label: 'Email',
                    initialValue: _draft.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    onChanged: (value) =>
                        _draft = _draft.copyWith(email: value),
                  ),
                  _buildTextField(
                    label: 'Purpose',
                    initialValue: _draft.loanPurpose,
                    maxLines: 2,
                    validator: _requiredText,
                    onChanged: (value) =>
                        _draft = _draft.copyWith(loanPurpose: value),
                    fullWidth: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Amount: ${AppFormatters.currency(_draft.amount)}',
                style: Theme.of(context).textTheme.titleMedium,
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
              const SizedBox(height: 8),
              Text('Tenure', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _selectedProduct.termOptions
                    .map(
                      (months) => _PillButton(
                        label: '$months mo',
                        selected: _draft.tenureMonths == months,
                        accent: _selectedProduct.accent,
                        onTap: () {
                          setState(() {
                            _draft = _draft.copyWith(tenureMonths: months);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FrostPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Documents',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Select only the documents you want to upload now.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ..._selectedProduct.requiredDocuments.map(
                (document) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _DocumentUploadTile(
                    document: document,
                    selection: _selectionFor(document.id),
                    accent: _selectedProduct.accent,
                    onToggle: (selected) =>
                        _toggleDocument(document.id, selected),
                    onPickFile: () => _pickDocument(document),
                    onRemove: () => _removeDocument(document.id),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FrostPanel(
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text(
                'Additional details',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text('Open only if needed'),
              children: [
                const SizedBox(height: 8),
                _buildFieldGrid(
                  context: context,
                  children: [
                    _buildTextField(
                      label: 'Date of birth',
                      initialValue: _draft.dateOfBirth,
                      onChanged: (value) =>
                          _draft = _draft.copyWith(dateOfBirth: value),
                    ),
                    _buildTextField(
                      label: 'Government ID',
                      initialValue: _draft.governmentId,
                      onChanged: (value) =>
                          _draft = _draft.copyWith(governmentId: value),
                    ),
                    _buildTextField(
                      label: 'Tax ID / PAN',
                      initialValue: _draft.taxId,
                      onChanged: (value) =>
                          _draft = _draft.copyWith(taxId: value),
                    ),
                    _buildTextField(
                      label: 'City',
                      initialValue: _draft.city,
                      onChanged: (value) =>
                          _draft = _draft.copyWith(city: value),
                    ),
                    _buildTextField(
                      label: 'Address',
                      initialValue: _draft.addressLine,
                      onChanged: (value) =>
                          _draft = _draft.copyWith(addressLine: value),
                      fullWidth: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Employment',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _employmentOptions
                      .map(
                        (option) => _PillButton(
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
                const SizedBox(height: 16),
                _buildFieldGrid(
                  context: context,
                  children: [
                    _buildTextField(
                      label: 'Employer / business',
                      initialValue: _draft.employerName,
                      onChanged: (value) =>
                          _draft = _draft.copyWith(employerName: value),
                    ),
                    _buildTextField(
                      label: 'Monthly income',
                      initialValue: _draft.monthlyIncome == 0
                          ? ''
                          : _draft.monthlyIncome.toStringAsFixed(0),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _draft = _draft.copyWith(
                        monthlyIncome: double.tryParse(value) ?? 0,
                      ),
                    ),
                    _buildTextField(
                      label: 'Monthly obligations',
                      initialValue: _draft.monthlyObligations == 0
                          ? ''
                          : _draft.monthlyObligations.toStringAsFixed(0),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _draft = _draft.copyWith(
                        monthlyObligations: double.tryParse(value) ?? 0,
                      ),
                    ),
                    _buildTextField(
                      label: 'Bank name',
                      initialValue: _draft.bankName,
                      onChanged: (value) =>
                          _draft = _draft.copyWith(bankName: value),
                    ),
                    _buildTextField(
                      label: 'Account number',
                      initialValue: _draft.accountNumber,
                      onChanged: (value) =>
                          _draft = _draft.copyWith(accountNumber: value),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _draft.hasCoApplicant,
                      activeColor: _selectedProduct.accent,
                      onChanged: (value) {
                        setState(() {
                          _draft = _draft.copyWith(
                            hasCoApplicant: value ?? false,
                            coApplicantName: value == true
                                ? _draft.coApplicantName
                                : '',
                          );
                        });
                      },
                    ),
                    const Expanded(child: Text('Add co-applicant')),
                  ],
                ),
                if (_draft.hasCoApplicant) ...[
                  const SizedBox(height: 8),
                  _buildTextField(
                    label: 'Co-applicant name',
                    initialValue: _draft.coApplicantName,
                    onChanged: (value) =>
                        _draft = _draft.copyWith(coApplicantName: value),
                  ),
                ],
                if (_needsAdditionalSecurity) ...[
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: _selectedProduct.type == LoanType.home
                        ? 'Property details'
                        : 'Collateral details',
                    initialValue: _draft.collateralDetails,
                    onChanged: (value) =>
                        _draft = _draft.copyWith(collateralDetails: value),
                    maxLines: 3,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryColumn(BuildContext context) {
    final readyCount = _selectedProduct.requiredDocuments.where((document) {
      return _selectionFor(document.id).attachment != null;
    }).length;
    final emi = LoanDemoData.estimateEmi(
      principal: _draft.amount,
      annualRate: _selectedProduct.interestRate,
      months: _draft.tenureMonths,
    );

    return FrostPanel(
      accent: _selectedProduct.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          DetailLine(label: 'Loan', value: _selectedProduct.title),
          const SizedBox(height: 12),
          DetailLine(
            label: 'Amount',
            value: AppFormatters.currency(_draft.amount),
          ),
          const SizedBox(height: 12),
          DetailLine(label: 'Tenure', value: '${_draft.tenureMonths} months'),
          const SizedBox(height: 12),
          DetailLine(label: 'EMI', value: AppFormatters.currency(emi)),
          const SizedBox(height: 12),
          DetailLine(
            label: 'Files picked',
            value: '$readyCount/${_selectedProduct.requiredDocuments.length}',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedProduct.accent,
              ),
              onPressed: _isSubmitting ? null : () => _submit(),
              child: Text(_isSubmitting ? 'Saving...' : 'Save loan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldGrid({
    required BuildContext context,
    required List<Widget> children,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final half = compact
            ? constraints.maxWidth
            : (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: children.map((child) {
            if (child is _FullWidthField) {
              return SizedBox(width: constraints.maxWidth, child: child.child);
            }
            return SizedBox(width: half, child: child);
          }).toList(),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool fullWidth = false,
  }) {
    final field = TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    );
    return fullWidth ? _FullWidthField(field) : field;
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    if (!value.contains('@')) {
      return 'Invalid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    if (value.replaceAll(RegExp(r'\D'), '').length < 10) {
      return 'Invalid phone';
    }
    return null;
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) {
      return '0 B';
    }
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final size = math.log(bytes) / math.log(1024);
    final index = size.floor().clamp(0, suffixes.length - 1);
    final value = bytes / math.pow(1024, index);
    return '${value.toStringAsFixed(value >= 10 || index == 0 ? 0 : 1)} ${suffixes[index]}';
  }
}

class _LoanTypeCard extends StatelessWidget {
  const _LoanTypeCard({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  final LoanProduct product;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? product.accent.withValues(alpha: 0.08)
              : const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? product.accent : const Color(0xFFE1E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: product.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(product.icon, color: product.accent, size: 20),
                ),
                const Spacer(),
                if (selected)
                  StatusBadge(label: 'Selected', color: product.accent),
              ],
            ),
            const SizedBox(height: 12),
            Text(product.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              product.subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentUploadTile extends StatelessWidget {
  const _DocumentUploadTile({
    required this.document,
    required this.selection,
    required this.accent,
    required this.onToggle,
    required this.onPickFile,
    required this.onRemove,
  });

  final LoanDocumentTemplate document;
  final DraftDocumentSelection selection;
  final Color accent;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickFile;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  document.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Checkbox(
                value: selection.selectedForUpload,
                activeColor: accent,
                onChanged: (value) => onToggle(value ?? false),
              ),
            ],
          ),
          Text(
            document.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (selection.selectedForUpload) ...[
            const SizedBox(height: 12),
            if (selection.attachment == null)
              OutlinedButton.icon(
                onPressed: onPickFile,
                icon: const Icon(Icons.attach_file_rounded),
                label: const Text('Pick document'),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusBadge(
                    label: selection.attachment!.fileName,
                    color: accent,
                  ),
                  OutlinedButton(
                    onPressed: onPickFile,
                    child: const Text('Replace'),
                  ),
                  TextButton(onPressed: onRemove, child: const Text('Remove')),
                ],
              ),
          ],
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.12) : Colors.white,
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

class _FullWidthField extends StatelessWidget {
  const _FullWidthField(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
