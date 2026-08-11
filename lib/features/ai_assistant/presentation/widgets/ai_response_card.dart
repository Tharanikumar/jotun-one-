import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/ai_intent_orchestrator.dart';

class AIResponseCardRenderer extends StatefulWidget {
  final AIChatMessage message;
  final Function(String action)? onActionSelected;
  final Function(Map<String, dynamic> formData)? onSubmitLeave;

  const AIResponseCardRenderer({
    super.key,
    required this.message,
    this.onActionSelected,
    this.onSubmitLeave,
  });

  @override
  State<AIResponseCardRenderer> createState() => _AIResponseCardRendererState();
}

class _AIResponseCardRendererState extends State<AIResponseCardRenderer> {
  bool _showPayslipBreakdown = false;
  bool _isReviewingLeave = false;

  late String _selectedLeaveType;
  late String _startDate;
  late String _endDate;
  late String _reason;

  @override
  void initState() {
    super.initState();
    final d = widget.message.data ?? {};
    _selectedLeaveType = d['leaveType'] as String? ?? 'Casual Leave';
    _startDate = d['startDate'] as String? ?? '15 Aug 2026';
    _endDate = d['endDate'] as String? ?? '16 Aug 2026';
    _reason = d['reason'] as String? ?? 'Personal work';
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.message.cardType) {
      case AICardType.leaveBalance:
        return _buildLeaveBalanceCard();

      case AICardType.leaveForm:
        return _isReviewingLeave ? _buildLeaveReviewCard() : _buildLeaveFormCard();

      case AICardType.leaveSubmitted:
        return _buildLeaveSubmittedCard();

      case AICardType.taskList:
        return _buildTaskListCard();

      case AICardType.itClassifier:
        return _buildITClassifierCard();

      case AICardType.itTicketStatus:
        return _buildITTicketStatusCard();

      case AICardType.payslip:
        return _buildPayslipCard();

      case AICardType.attendance:
        return _buildAttendanceCard();

      case AICardType.policy:
        return _buildPolicyCard();

      case AICardType.documentSearch:
        return _buildDocumentSearchCard();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLeaveBalanceCard() {
    final balances = (widget.message.data?['balances'] as List<dynamic>?) ?? [];
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Leave Balance Summary 2026',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: balances.map((b) {
              final color = Color(b['color'] as int);
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withAlpha(40)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${b['available']}',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        b['type'] as String,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveFormCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.edit_calendar_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Apply Leave Request',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Leave Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ['Casual Leave', 'Sick Leave', 'Annual Leave'].map((type) {
              final selected = _selectedLeaveType == type;
              return ChoiceChip(
                label: Text(type, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.primary)),
                selected: selected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.primary.withAlpha(15),
                onSelected: (val) {
                  if (val) setState(() => _selectedLeaveType = type);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(_startDate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
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
                    const Text('End Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(_endDate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Reason', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          TextField(
            controller: TextEditingController(text: _reason),
            onChanged: (val) => _reason = val,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              fillColor: const Color(0xFFF8FAFC),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _isReviewingLeave = true),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Review Application', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveReviewCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.task_alt_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Review Leave Application', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
            ],
          ),
          const Divider(height: 20),
          _detailRow('Leave Type', _selectedLeaveType),
          _detailRow('From', _startDate),
          _detailRow('To', _endDate),
          _detailRow('Duration', '2 Days'),
          _detailRow('Reason', _reason),
          const SizedBox(height: 14),
          Row(
            children: [
              OutlinedButton(
                onPressed: () => setState(() => _isReviewingLeave = false),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text('Edit'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (widget.onSubmitLeave != null) {
                      widget.onSubmitLeave!({
                        'leaveType': _selectedLeaveType,
                        'startDate': _startDate,
                        'endDate': _endDate,
                        'days': 2,
                        'reason': _reason,
                      });
                    }
                  },
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text('Submit Request', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveSubmittedCard() {
    final data = widget.message.data ?? {};
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10B981).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22),
              SizedBox(width: 8),
              Text('Leave Request Submitted', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF065F46))),
            ],
          ),
          const SizedBox(height: 12),
          _detailRow('Request ID', data['requestId'] as String? ?? 'LV-2026-00124'),
          _detailRow('Status', data['status'] as String? ?? 'Pending Manager Approval'),
          _detailRow('Type', data['type'] as String? ?? 'Casual Leave'),
          _detailRow('Dates', '${data['startDate']} - ${data['endDate']}'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => widget.onActionSelected?.call('Go to Leave Module'),
                  icon: const Icon(Icons.arrow_outward_rounded, size: 16),
                  label: const Text('Go to Leave Module'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskListCard() {
    final tasks = (widget.message.data?['tasks'] as List<dynamic>?) ?? [];
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.check_box_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Active Assigned Tasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 12),
          ...tasks.map((task) {
            final color = Color(task['priorityColor'] as int);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 40,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                        const SizedBox(height: 2),
                        Text('Due: ${task['due']} • ${task['priority']} Priority', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => widget.onActionSelected?.call('Open Task ${task['id']}'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Open', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildITClassifierCard() {
    final categories = (widget.message.data?['categories'] as List<dynamic>?) ?? [];
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.headset_mic_rounded, color: Color(0xFF8B5CF6), size: 20),
              SizedBox(width: 8),
              Text('Select Issue Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              return ActionChip(
                avatar: const Icon(Icons.build_rounded, size: 14, color: Color(0xFF8B5CF6)),
                label: Text(cat as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                backgroundColor: const Color(0xFFF5F3FF),
                onPressed: () => widget.onActionSelected?.call('Create IT Ticket: $cat'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildITTicketStatusCard() {
    final data = widget.message.data ?? {};
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ticket #${data['ticketId'] ?? 'IT-1024'}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF5B21B6)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data['status'] as String? ?? 'In Progress',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _detailRow('Issue', data['issue'] as String? ?? 'System slow'),
          _detailRow('Assigned To', data['assignedTo'] as String? ?? 'IT Support'),
          _detailRow('Latest Update', data['lastUpdate'] as String? ?? 'Investigating'),
        ],
      ),
    );
  }

  Widget _buildPayslipCard() {
    final data = widget.message.data ?? {};
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2563EB).withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Text('Payslip: ${data['month'] ?? 'July 2026'}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                ],
              ),
              Text(data['paidDate'] as String? ?? '31 Jul 2026', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Net Salary Paid', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF))),
                Text(
                  data['netSalary'] as String? ?? '₹85,450',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => setState(() => _showPayslipBreakdown = !_showPayslipBreakdown),
            icon: Icon(_showPayslipBreakdown ? Icons.expand_less_rounded : Icons.expand_more_rounded, size: 18),
            label: Text(_showPayslipBreakdown ? 'Hide Breakdown' : 'Show Earnings & Deductions Breakdown'),
          ),
          if (_showPayslipBreakdown) ...[
            const Divider(height: 16),
            _detailRow('Basic Salary', data['basic'] as String? ?? '₹50,000'),
            _detailRow('Allowances', data['allowances'] as String? ?? '₹28,450'),
            _detailRow('PF & Tax Deductions', data['totalDeductions'] as String? ?? '₹5,000'),
          ],
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    final data = widget.message.data ?? {};
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['date'] as String? ?? 'Today', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(data['status'] as String? ?? 'Present', style: const TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _timeStat('Check-in', data['checkIn'] as String? ?? '09:02 AM'),
              _timeStat('Check-out', data['checkOut'] as String? ?? 'Pending'),
              _timeStat('Working Hours', data['workingHours'] as String? ?? '04h 32m'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard() {
    final data = widget.message.data ?? {};
    final points = (data['keyPoints'] as List<dynamic>?) ?? [];
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['title'] as String? ?? 'HR Policy', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
          const SizedBox(height: 6),
          Text(data['shortAnswer'] as String? ?? '', style: const TextStyle(fontSize: 13, height: 1.3, color: Color(0xFF334155))),
          const SizedBox(height: 10),
          const Text('Key Points:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569))),
          const SizedBox(height: 4),
          ...points.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    Expanded(child: Text(p as String, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDocumentSearchCard() {
    final docs = (widget.message.data?['documents'] as List<dynamic>?) ?? [];
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: docs.map((doc) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(doc['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                      child: Text(doc['category'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(doc['summary'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _detailRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _timeStat(String label, String time) {
    return Column(
      children: [
        Text(time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ],
    );
  }
}
