import 'package:flutter/material.dart';
import 'package:jude/core/widgets/custom_button.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _selectedPaymentMethod = 'Bank Transfer';
  bool _isFavorite = false;
  bool _showSuccess = false;
  bool _isLoading = false;

  final List<String> _paymentMethods = [
    'Bank Transfer',
    'Credit Card',
    'Debit Card',
    'PayPal',
    'Mobile Money',
  ];

  String? _validateRecipient(String? value) {
    if (value == null || value.isEmpty) {
      return 'Recipient name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
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
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _showSuccess = true;
      });

      // Auto-hide success message
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showSuccess = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
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
                  // Recipient Name Field
                  const Text(
                    'Recipient Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _recipientController,
                    validator: _validateRecipient,
                    decoration: InputDecoration(
                      labelText: 'Recipient Name',
                      hintText: 'Enter recipient\'s name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorMaxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Amount Field
                  const Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    validator: _validateAmount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: '0.00',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorMaxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Payment Method Dropdown
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPaymentMethod,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: _paymentMethods.map((String method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Row(
                              children: [
                                Icon(
                                  _getPaymentIcon(method),
                                  size: 20,
                                  color: const Color(0xFF2196F3),
                                ),
                                const SizedBox(width: 12),
                                Text(method),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedPaymentMethod = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Favorite Switch
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.star_outline,
                              color: Color(0xFF2196F3),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Add to Favorites',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isFavorite,
                          onChanged: (bool value) {
                            setState(() {
                              _isFavorite = value;
                            });
                          },
                          activeThumbColor: const Color(0xFF2196F3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Send Button
                  CustomButton(
                    text: 'Send Money',
                    onPressed: _handleSendMoney,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Animated Success Message
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _showSuccess ? 20 : -100,
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _showSuccess ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Money sent successfully!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'Bank Transfer':
        return Icons.account_balance;
      case 'Credit Card':
        return Icons.credit_card;
      case 'Debit Card':
        return Icons.payment;
      case 'PayPal':
        return Icons.account_balance_wallet;
      case 'Mobile Money':
        return Icons.phone_android;
      default:
        return Icons.payment;
    }
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}