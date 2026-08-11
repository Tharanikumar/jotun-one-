import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/ai_intent.dart';

// 1. Leave Balance Card Widget
class LeaveBalanceCardWidget extends StatelessWidget {
  final List<LeaveBalanceItem> balances;
  final Function(String) onApplyLeave;

  const LeaveBalanceCardWidget({
    super.key,
    required this.balances,
    required this.onApplyLeave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Leave Balance 2026',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...balances.map((item) {
            final progress = item.total > 0 ? (item.available / item.total) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.type, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      Text('${item.available} days left', style: AppTypography.labelMedium.copyWith(color: item.color, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: item.color.withAlpha(25),
                      valueColor: AlwaysStoppedAnimation<Color>(item.color),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => onApplyLeave('Casual Leave'),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('Apply Leave Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Interactive Leave Application Form Card
class LeaveFormCardWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFormSubmitted;
  final String initialType;

  const LeaveFormCardWidget({
    super.key,
    required this.onFormSubmitted,
    this.initialType = 'Casual Leave',
  });

  @override
  State<LeaveFormCardWidget> createState() => _LeaveFormCardWidgetState();
}

class _LeaveFormCardWidgetState extends State<LeaveFormCardWidget> {
  late String _selectedType;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _reasonController = TextEditingController(text: 'Personal work');

  final List<String> _types = ['Casual Leave', 'Sick Leave', 'Annual Leave', 'Maternity/Paternity'];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    final days = _endDate.difference(_startDate).inDays + 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(40)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.edit_calendar_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Text('Apply Leave Request', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 14),

          // Leave Type Dropdown
          Text('Leave Type', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t, style: AppTypography.bodySmall))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedType = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Start & End Date Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start Date', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );
                        if (picked != null) {
                          setState(() {
                            _startDate = picked;
                            if (_endDate.isBefore(_startDate)) _endDate = _startDate;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderLight)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_startDate.day}/${_startDate.month}/${_startDate.year}', style: AppTypography.bodySmall),
                            const Icon(Icons.date_range_rounded, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('End Date', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );
                        if (picked != null) {
                          setState(() => _endDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderLight)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_endDate.day}/${_endDate.month}/${_endDate.year}', style: AppTypography.bodySmall),
                            const Icon(Icons.date_range_rounded, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Reason Field
          Text('Reason', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          TextField(
            controller: _reasonController,
            style: AppTypography.bodySmall,
            decoration: InputDecoration(
              hintText: 'Enter reason for leave...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
          const SizedBox(height: 14),

          // Total Days Indicator & Continue Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Duration: $days ${days == 1 ? 'day' : 'days'}', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ElevatedButton(
                onPressed: () {
                  widget.onFormSubmitted({
                    'type': _selectedType,
                    'startDate': '${_startDate.day} ${_getMonthName(_startDate.month)} ${_startDate.year}',
                    'endDate': '${_endDate.day} ${_getMonthName(_endDate.month)} ${_endDate.year}',
                    'days': days,
                    'reason': _reasonController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return names[month - 1];
  }
}

// 3. Leave Application Review/Confirmation Card
class LeaveConfirmationCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onConfirm;
  final VoidCallback onEdit;

  const LeaveConfirmationCardWidget({
    super.key,
    required this.data,
    required this.onConfirm,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_turned_in_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('Review Leave Application', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            ],
          ),
          const Divider(height: 20),
          _rowItem('Leave Type', data['type'] as String),
          _rowItem('Duration', '${data['startDate']} - ${data['endDate']} (${data['days']} days)'),
          _rowItem('Reason', data['reason'] as String),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Submit Request'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rowItem(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          Text(val, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 4. Submitted Leave Status Card
class LeaveStatusCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const LeaveStatusCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Text('Leave Request Submitted', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.navyDark)),
            ],
          ),
          const SizedBox(height: 10),
          Text('Request ID: ${data['requestId']}', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
          Text('Status: ${data['status']}', style: AppTypography.bodySmall.copyWith(color: AppColors.accentOrange, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/app/leave'),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('Go to Leave Module'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 5. Active Task List Card Widget
class TaskListCardWidget extends StatefulWidget {
  final List<TaskItem> tasks;
  final Function(String taskId, String status) onStatusChange;

  const TaskListCardWidget({
    super.key,
    required this.tasks,
    required this.onStatusChange,
  });

  @override
  State<TaskListCardWidget> createState() => _TaskListCardWidgetState();
}

class _TaskListCardWidgetState extends State<TaskListCardWidget> {
  String _activeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.tasks.where((t) {
      if (_activeFilter == 'Today') return t.dueDate.contains('Today') || t.isOverdue;
      if (_activeFilter == 'High') return t.priority == 'High';
      return true;
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.task_alt_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Assigned Tasks', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Text('${filtered.length} active', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 10),

          // Filter Chips
          Row(
            children: ['All', 'Today', 'High'].map((f) {
              final selected = _activeFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(f, style: TextStyle(fontSize: 11, color: selected ? Colors.white : AppColors.textSecondary)),
                  selected: selected,
                  onSelected: (val) => setState(() => _activeFilter = f),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.background,
                  padding: const EdgeInsets.all(2),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          ...filtered.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        t.status == 'Completed' ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: t.status == 'Completed' ? AppColors.success : AppColors.textMuted,
                      ),
                      onPressed: () {
                        widget.onStatusChange(t.id, t.status == 'Completed' ? 'Pending' : 'Completed');
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold, decoration: t.status == 'Completed' ? TextDecoration.lineThrough : null)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(t.dueDate, style: TextStyle(fontSize: 10, color: t.isOverdue ? AppColors.error : AppColors.textSecondary, fontWeight: t.isOverdue ? FontWeight.bold : FontWeight.normal)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(color: t.priority == 'High' ? AppColors.error.withAlpha(20) : AppColors.info.withAlpha(20), borderRadius: BorderRadius.circular(6)),
                                child: Text(t.priority, style: TextStyle(fontSize: 9, color: t.priority == 'High' ? AppColors.error : AppColors.info, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// 6. IT Ticket Classification Card Widget
class ITClassificationCardWidget extends StatelessWidget {
  final Function(String category) onSelectCategory;

  const ITClassificationCardWidget({super.key, required this.onSelectCategory});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Network & VPN', 'icon': Icons.wifi_rounded, 'color': AppColors.primary},
      {'name': 'Laptop & Hardware', 'icon': Icons.laptop_mac_rounded, 'color': AppColors.accentPurple},
      {'name': 'Software & Apps', 'icon': Icons.apps_rounded, 'color': AppColors.accentMint},
      {'name': 'Email & Account', 'icon': Icons.email_rounded, 'color': AppColors.accentOrange},
      {'name': 'Printer', 'icon': Icons.print_rounded, 'color': AppColors.accentCyan},
      {'name': 'Other Issue', 'icon': Icons.help_outline_rounded, 'color': AppColors.textSecondary},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.accentPurple.withAlpha(30))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.headset_mic_rounded, color: AppColors.accentPurple, size: 20),
              const SizedBox(width: 8),
              Text('Select IT Issue Category', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              return ActionChip(
                avatar: Icon(cat['icon'] as IconData, size: 16, color: cat['color'] as Color),
                label: Text(cat['name'] as String, style: AppTypography.labelMedium),
                onPressed: () => onSelectCategory(cat['name'] as String),
                backgroundColor: (cat['color'] as Color).withAlpha(15),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// 7. IT Ticket Status Card Widget
class ITTicketStatusCardWidget extends StatelessWidget {
  final List<ITTicketItem> tickets;

  const ITTicketStatusCardWidget({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) return const SizedBox.shrink();
    final t = tickets.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.accentPurple.withAlpha(40))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.confirmation_number_rounded, color: AppColors.accentPurple, size: 20),
                  const SizedBox(width: 8),
                  Text('Ticket #${t.ticketId}', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.info.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                child: Text(t.status, style: AppTypography.labelSmall.copyWith(color: AppColors.info, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(t.issue, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text('Assigned to: ${t.assignedTo}', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
          Text('Updated: ${t.lastUpdated}', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => context.push('/app/helpdesk'),
            icon: const Icon(Icons.support_agent_rounded, size: 16),
            label: const Text('Go to IT Helpdesk'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentPurple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ],
      ),
    );
  }
}

// 8. Secure Payslip Card Widget
class PayslipCardWidget extends StatefulWidget {
  final Map<String, dynamic> data;

  const PayslipCardWidget({super.key, required this.data});

  @override
  State<PayslipCardWidget> createState() => _PayslipCardWidgetState();
}

class _PayslipCardWidgetState extends State<PayslipCardWidget> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(30)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Payslip (${widget.data['month']})', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              IconButton(
                icon: Icon(_isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: AppColors.textSecondary, size: 20),
                onPressed: () => setState(() => _isVisible = !_isVisible),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Net Salary', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                Text(_isVisible ? (widget.data['netSalary'] as String) : '₹ • • • • • •', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Earnings: ${_isVisible ? widget.data['basic'] : '₹•••'}', style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
              Text('Deductions: ${_isVisible ? widget.data['totalDeductions'] : '₹•••'}', style: AppTypography.labelSmall.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('Download PDF'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 9. Attendance Card Widget
class AttendanceCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const AttendanceCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.accentMint.withAlpha(40))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_filled_rounded, color: AppColors.accentMint, size: 20),
                  const SizedBox(width: 8),
                  Text("Today's Attendance", style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.success.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                child: Text(data['status'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _attItem('Check-In', data['checkIn'] as String),
              _attItem('Check-Out', data['checkOut'] as String),
              _attItem('Working Hours', data['workingHours'] as String),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Regularize Attendance'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attItem(String label, String val) {
    return Column(
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(val, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// 10. HR Policy Card Widget
class PolicyCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const PolicyCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final points = (data['keyPoints'] as List<dynamic>? ?? []).cast<String>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.accentOrange.withAlpha(30))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.article_rounded, color: AppColors.accentOrange, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(data['policyTitle'] as String, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          Text(data['shortAnswer'] as String, style: AppTypography.bodySmall.copyWith(color: AppColors.navyDark)),
          const SizedBox(height: 10),
          Text('Key Policy Guidelines:', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          ...points.map((pt) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentOrange)),
                    Expanded(child: Text(pt, style: AppTypography.bodySmall)),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.push(data['fullDocRoute'] as String? ?? '/app/leave'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentOrange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('View Full Policy Document'),
          ),
        ],
      ),
    );
  }
}

// 11. Error Recovery Card Widget
class ErrorCardWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorCardWidget({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.error.withAlpha(15), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.error.withAlpha(40))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 6),
          Text(message, style: AppTypography.bodySmall.copyWith(color: AppColors.navyDark)),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ],
      ),
    );
  }
}
