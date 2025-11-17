import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jude/core/widgets/custom_button.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/custom_text_field.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  String _selectedPaymentMethod = 'Bank Transfer';
  bool _isFavorite = false;
  bool _showSuccess = false;
  bool _isLoading = false;
  
  late AnimationController _successController;
  late Animation<double> _successScale;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Bank Transfer', 'icon': Icons.account_balance},
    {'name': 'Credit Card', 'icon': Icons.credit_card},
    {'name': 'Debit Card', 'icon': Icons.payment},
    {'name': 'PayPal', 'icon': Icons.account_balance_wallet},
    {'name': 'Mobile Money', 'icon': Icons.phone_android},
  ];

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _successScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    _recipientController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? _validateRecipient(String? value) {
    if (value == null || value.isEmpty) {
      return 'Recipient name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }
    if (amount <= 0) {
      return 'Amount must be greater than zero';
    }
    if (amount > 10000) {
      return 'Amount exceeds limit (\$10,000)';
    }
    return null;
  }

  void _handleSendMoney() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuccess = true;
        });
        
        _successController.forward();
        
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _successController.reverse();
            setState(() => _showSuccess = false);
            
            // Clear form
            _recipientController.clear();
            _amountController.clear();
            _noteController.clear();
            _isFavorite = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Money',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipient Section
                  const _SectionHeader(
                    icon: Icons.person_outline,
                    title: 'Recipient Details',
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _recipientController,
                    label: 'Recipient Name',
                    hint: 'Enter full name',
                    prefixIcon: Icons.person,
                    validator: _validateRecipient,
                  ),
                  const SizedBox(height: 24),
                  
                  // Amount Section
                  const _SectionHeader(
                    icon: Icons.attach_money,
                    title: 'Amount',
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _amountController,
                    label: 'Amount',
                    hint: '0.00',
                    prefixIcon: Icons.attach_money,
                    validator: _validateAmount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Payment Method Section
                  const _SectionHeader(
                    icon: Icons.payment,
                    title: 'Payment Method',
                  ),
                  const SizedBox(height: 16),
                  CustomCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPaymentMethod,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: _paymentMethods.map((method) {
                          return DropdownMenuItem<String>(
                            value: method['name'],
                            child: Row(
                              children: [
                                Icon(
                                  method['icon'],
                                  size: 20,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  method['name'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _selectedPaymentMethod = newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Note Section
                  const _SectionHeader(
                    icon: Icons.note_outlined,
                    title: 'Note (Optional)',
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _noteController,
                    label: 'Add a note',
                    hint: 'What\'s this for?',
                    prefixIcon: Icons.edit_outlined,
                    maxLength: 100,
                  ),
                  const SizedBox(height: 24),
                  
                  // Favorite Toggle
                  CustomCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isFavorite ? Icons.star : Icons.star_outline,
                              color: _isFavorite
                                  ? Colors.amber
                                  : AppTheme.textSecondary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add to Favorites',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Quick access for next time',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: _isFavorite,
                          onChanged: (bool value) {
                            setState(() => _isFavorite = value);
                          },
                          activeThumbColor: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Summary Card
                  if (_amountController.text.isNotEmpty &&
                      _recipientController.text.isNotEmpty)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: CustomCard(
                        color: AppTheme.primaryColor.withValues(alpha: 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Transaction Summary',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _SummaryRow(
                              label: 'Recipient',
                              value: _recipientController.text,
                            ),
                            _SummaryRow(
                              label: 'Amount',
                              value: '\${_amountController.text}',
                            ),
                            _SummaryRow(
                              label: 'Payment Method',
                              value: _selectedPaymentMethod,
                            ),
                            const Divider(height: 24),
                            _SummaryRow(
                              label: 'Total',
                              value: '\${_amountController.text}',
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  
                  // Send Button
                  CustomButton(
                    text: 'Send Money',
                    onPressed: _handleSendMoney,
                    isLoading: _isLoading,
                    icon: Icons.send_rounded,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // Animated Success Message
          if (_showSuccess)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: ScaleTransition(
                scale: _successScale,
                child: CustomCard(
                  color: AppTheme.successColor,
                  padding: const EdgeInsets.all(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.successColor.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Success!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Money sent successfully',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

// Summary Row Widget
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}