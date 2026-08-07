import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/extensions/navigation_extensions.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  String _selectedLeaveType = 'Casual Leave';
  final _fromDateController = TextEditingController(text: '20 May 2024');
  final _toDateController = TextEditingController(text: '21 May 2024');
  final _reasonController = TextEditingController(text: 'Personal work');
  bool _isSubmitted = false;

  void _submitApplication() {
    setState(() {
      _isSubmitted = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave application submitted successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.safePop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Apply Leave'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Leave Type',
                        style: AppTypography.labelMedium.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 4),
                      const Text('*', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLeaveType,
                    items: ['Casual Leave', 'Sick Leave', 'Annual Leave', 'Maternity/Paternity Leave']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedLeaveType = val;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'From Date',
                    controller: _fromDateController,
                    prefixIcon: Icons.calendar_today_rounded,
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'To Date',
                    controller: _toDateController,
                    prefixIcon: Icons.calendar_today_rounded,
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Reason',
                    controller: _reasonController,
                    maxLines: 3,
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Upload Document (Optional)',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.upload_file_rounded, color: AppColors.primary),
                    label: const Text('Upload File'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: AppColors.borderLight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Submit Application',
                      backgroundColor: AppColors.success,
                      isGradient: false,
                      isLoading: _isSubmitted,
                      onPressed: _submitApplication,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
