import 'package:flutter/material.dart';
import '../models/ai_intent.dart';

class WorkplaceServices {
  // Mock In-Memory Workplace State
  final List<LeaveBalanceItem> _leaveBalances = [
    LeaveBalanceItem(
      type: 'Casual Leave',
      total: 12,
      used: 4,
      available: 8,
      color: const Color(0xFF2563EB),
    ),
    LeaveBalanceItem(
      type: 'Sick Leave',
      total: 10,
      used: 5,
      available: 5,
      color: const Color(0xFF10B981),
    ),
    LeaveBalanceItem(
      type: 'Annual Leave',
      total: 15,
      used: 3,
      available: 12,
      color: const Color(0xFF8B5CF6),
    ),
    LeaveBalanceItem(
      type: 'Maternity/Paternity',
      total: 30,
      used: 0,
      available: 30,
      color: const Color(0xFFF59E0B),
    ),
  ];

  final List<TaskItem> _tasks = [
    TaskItem(
      id: 'TSK-101',
      title: 'Submit Monthly Plant Safety Report',
      category: 'Safety & EHS',
      dueDate: 'Today, 5:00 PM',
      priority: 'High',
      status: 'In Progress',
      isOverdue: false,
    ),
    TaskItem(
      id: 'TSK-102',
      title: 'Complete Mandatory ISO Compliance Training',
      category: 'Training',
      dueDate: '18 Aug 2026',
      priority: 'Medium',
      status: 'Pending',
      isOverdue: false,
    ),
    TaskItem(
      id: 'TSK-103',
      title: 'Update Emergency Contact Details in HR Portal',
      category: 'HR Services',
      dueDate: '22 Aug 2026',
      priority: 'Low',
      status: 'Not Started',
      isOverdue: false,
    ),
    TaskItem(
      id: 'TSK-104',
      title: 'Approve Warehouse Stock Audit Sheet',
      category: 'Warehouse',
      dueDate: 'Yesterday',
      priority: 'High',
      status: 'Pending',
      isOverdue: true,
    ),
  ];

  final List<ITTicketItem> _itTickets = [
    ITTicketItem(
      ticketId: 'IT-1024',
      issue: 'VPN Connection drops intermittently during remote work',
      category: 'Network',
      priority: 'Medium',
      status: 'In Progress',
      assignedTo: 'Alex Chen (IT Support)',
      lastUpdated: '10 mins ago',
    ),
    ITTicketItem(
      ticketId: 'IT-0988',
      issue: 'Request for Adobe Acrobat Pro License',
      category: 'Software',
      priority: 'Low',
      status: 'Resolved',
      assignedTo: 'Sarah Jenkins (IT Asset Manager)',
      lastUpdated: '2 days ago',
    ),
  ];

  final List<ConversationHistoryItem> _historyItems = [
    ConversationHistoryItem(
      id: 'HIS-001',
      title: 'Casual Leave Application for Tomorrow',
      dateStr: 'Today, 10:14 AM',
      category: 'Today',
      lastMessage: '✓ Leave request submitted successfully (#LV-2026-00124)',
      isSaved: true,
    ),
    ConversationHistoryItem(
      id: 'HIS-002',
      title: 'IT Ticket VPN Troubleshooting',
      dateStr: 'Today, 08:30 AM',
      category: 'Today',
      lastMessage: 'IT Support is currently investigating ticket #IT-1024.',
      isSaved: false,
    ),
    ConversationHistoryItem(
      id: 'HIS-003',
      title: 'July 2026 Payslip & Salary Inquiry',
      dateStr: 'Yesterday',
      category: 'Yesterday',
      lastMessage: 'Your Net Salary of ₹84,500 was credited on 31st July.',
      isSaved: true,
    ),
    ConversationHistoryItem(
      id: 'HIS-004',
      title: 'Annual & Sick Leave Policy Query',
      dateStr: '07 Aug 2026',
      category: 'Older',
      lastMessage: 'Annual leave accrues at 1.25 days per month of service.',
      isSaved: true,
    ),
  ];

  final List<SavedBookmarkItem> _savedBookmarks = [
    SavedBookmarkItem(
      id: 'SAV-001',
      title: 'Annual Leave & Carry Forward Policy 2026',
      category: 'Policies',
      snippet: 'Employees can carry forward up to 5 days of unused annual leave into the next calendar year.',
      savedDate: 'Today',
    ),
    SavedBookmarkItem(
      id: 'SAV-002',
      title: 'IT Helpdesk Escalation Matrix & SLA',
      category: 'Answers',
      snippet: 'High priority system outages are resolved within 2 hours. Call Extension #4400 for emergency assistance.',
      savedDate: 'Yesterday',
    ),
    SavedBookmarkItem(
      id: 'SAV-003',
      title: 'Plant Safety Operations Handbook PDF',
      category: 'Documents',
      snippet: 'Mandatory PPE guidelines and evacuation maps for Zone A and Zone B facilities.',
      savedDate: '06 Aug 2026',
    ),
  ];

  // Service Methods
  List<LeaveBalanceItem> getLeaveBalances() => _leaveBalances;

  Map<String, dynamic> submitLeaveRequest({
    required String type,
    required String startDate,
    required String endDate,
    required int days,
    required String reason,
  }) {
    final reqId = 'LV-2026-0${120 + _historyItems.length}';
    return {
      'requestId': reqId,
      'type': type,
      'startDate': startDate,
      'endDate': endDate,
      'days': days,
      'reason': reason,
      'status': 'Pending Manager Approval',
      'submittedAt': 'Just now',
    };
  }

  List<TaskItem> getTasks({String filter = 'All'}) {
    if (filter == 'Today') {
      return _tasks.where((t) => t.dueDate.contains('Today') || t.isOverdue).toList();
    } else if (filter == 'Upcoming') {
      return _tasks.where((t) => !t.dueDate.contains('Today') && !t.isOverdue && t.status != 'Completed').toList();
    } else if (filter == 'Completed') {
      return _tasks.where((t) => t.status == 'Completed').toList();
    }
    return _tasks;
  }

  void updateTaskStatus(String taskId, String newStatus) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      final old = _tasks[idx];
      _tasks[idx] = TaskItem(
        id: old.id,
        title: old.title,
        category: old.category,
        dueDate: old.dueDate,
        priority: old.priority,
        status: newStatus,
        isOverdue: old.isOverdue,
      );
    }
  }

  Map<String, dynamic> createITTicket({
    required String category,
    required String priority,
    required String description,
  }) {
    final newId = 'IT-${1025 + _itTickets.length}';
    final ticket = ITTicketItem(
      ticketId: newId,
      issue: description,
      category: category,
      priority: priority,
      status: 'Open',
      assignedTo: 'Jotun IT Desk (Unassigned)',
      lastUpdated: 'Just now',
    );
    _itTickets.insert(0, ticket);
    return {
      'ticketId': newId,
      'category': category,
      'priority': priority,
      'description': description,
      'status': 'Open',
    };
  }

  List<ITTicketItem> getITTickets() => _itTickets;

  Map<String, dynamic> getLatestPayslip() {
    return {
      'month': 'July 2026',
      'netSalary': '₹84,500',
      'basic': '₹48,000',
      'allowances': '₹32,500',
      'otherEarnings': '₹10,000',
      'pfDeduction': '₹4,000',
      'taxDeduction': '₹2,000',
      'totalDeductions': '₹6,000',
      'status': 'Paid on 31 Jul 2026',
    };
  }

  Map<String, dynamic> getTodayAttendance() {
    return {
      'checkIn': '09:02 AM',
      'checkOut': 'Not checked out',
      'workingHours': '05h 18m',
      'status': 'Present',
      'location': 'Jotun HQ - Plant 1',
    };
  }

  Map<String, dynamic>? searchPolicy(String query) {
    final q = query.toLowerCase();
    if (q.contains('leave') || q.contains('annual') || q.contains('casual')) {
      return {
        'policyTitle': 'Jotun Enterprise Leave Policy (Ref: HR-POL-2026-04)',
        'shortAnswer': 'Full-time employees receive 12 Casual Leaves, 10 Sick Leaves, and 15 Annual Leaves per calendar year.',
        'keyPoints': [
          'Casual leave requires 24h prior manager notice.',
          'Sick leave over 2 consecutive days requires a medical certificate.',
          'Up to 5 days of Annual Leave can be carried forward into the next year.',
          'Leave applications are submitted via Jotun One AI Assistant or Leave Module.'
        ],
        'fullDocRoute': '/app/leave',
      };
    } else if (q.contains('wfh') || q.contains('work from home') || q.contains('remote')) {
      return {
        'policyTitle': 'Flexible Workplace & Remote Work Guidelines (Ref: HR-POL-2026-11)',
        'shortAnswer': 'Eligible office staff are permitted up to 2 Work-From-Home days per week with line manager pre-approval.',
        'keyPoints': [
          'Must connect via Jotun Secure Enterprise VPN.',
          'Core hours (10:00 AM - 4:00 PM) availability is mandatory.',
          'Not applicable to plant manufacturing and warehouse operational personnel.'
        ],
        'fullDocRoute': '/app/helpdesk',
      };
    }
    return null;
  }

  List<ConversationHistoryItem> getHistory() => _historyItems;
  List<SavedBookmarkItem> getSavedBookmarks() => _savedBookmarks;
}
