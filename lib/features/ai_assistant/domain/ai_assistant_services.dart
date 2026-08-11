import 'package:flutter/foundation.dart';

/// Clean Service Layer for Jotun One Enterprise AI Assistant
class LeaveService {
  List<Map<String, dynamic>> getLeaveBalances() {
    return [
      {'type': 'Casual Leave', 'available': 8, 'total': 12, 'used': 4, 'color': 0xFF2563EB},
      {'type': 'Sick Leave', 'available': 5, 'total': 7, 'used': 2, 'color': 0xFF10B981},
      {'type': 'Annual Leave', 'available': 12, 'total': 15, 'used': 3, 'color': 0xFF8B5CF6},
    ];
  }

  List<Map<String, dynamic>> getPendingRequests() {
    return [
      {
        'id': 'LV-2026-00124',
        'type': 'Casual Leave',
        'startDate': '15 Aug 2026',
        'endDate': '16 Aug 2026',
        'days': 2,
        'status': 'Pending Manager Approval',
        'reason': 'Personal work',
      }
    ];
  }

  Map<String, dynamic> submitLeave(Map<String, dynamic> formData) {
    final requestId = 'LV-2026-${(1000 + (DateTime.now().millisecondsSinceEpoch % 8999)).toString()}';
    debugPrint('Submitting leave to backend API: $formData');
    return {
      'requestId': requestId,
      'type': formData['leaveType'] ?? 'Casual Leave',
      'startDate': formData['startDate'] ?? '15 Aug 2026',
      'endDate': formData['endDate'] ?? '16 Aug 2026',
      'days': formData['days'] ?? 2,
      'reason': formData['reason'] ?? 'Personal work',
      'status': 'Pending Manager Approval',
      'submittedAt': 'Just now',
    };
  }
}

class TaskService {
  List<Map<String, dynamic>> getTasks() {
    return [
      {
        'id': 'TSK-101',
        'title': 'Submit Monthly Operations Report',
        'due': 'Today (05:00 PM)',
        'priority': 'High',
        'priorityColor': 0xFFEF4444,
        'status': 'In Progress',
        'category': 'Operations',
      },
      {
        'id': 'TSK-102',
        'title': 'Complete EHS Safety Refresher Training',
        'due': '18 Aug 2026',
        'priority': 'Medium',
        'priorityColor': 0xFFF59E0B,
        'status': 'Pending',
        'category': 'Safety',
      },
      {
        'id': 'TSK-103',
        'title': 'Update Emergency Contact Information',
        'due': '22 Aug 2026',
        'priority': 'Low',
        'priorityColor': 0xFF10B981,
        'status': 'Not Started',
        'category': 'HR',
      },
    ];
  }
}

class ITTicketService {
  Map<String, dynamic> getTicketStatus(String ticketId) {
    return {
      'ticketId': ticketId,
      'issue': 'System running slow / VPN connectivity',
      'category': 'Network & VPN',
      'priority': 'Medium',
      'status': 'In Progress',
      'assignedTo': 'Alex Rivera (Sr. IT Engineer)',
      'lastUpdate': 'IT Support is investigating the gateway routing latency.',
      'createdAt': 'Yesterday, 02:15 PM',
    };
  }

  Map<String, dynamic> createTicket(Map<String, dynamic> details) {
    final ticketId = 'IT-${(1000 + (DateTime.now().millisecondsSinceEpoch % 8999)).toString()}';
    return {
      'ticketId': ticketId,
      'category': details['category'] ?? 'IT Support',
      'issue': details['description'] ?? 'Hardware issue reported via AI',
      'priority': 'Medium',
      'status': 'Open',
      'assignedTo': 'Helpdesk Support Team',
      'createdAt': 'Just now',
    };
  }
}

class PayrollService {
  Map<String, dynamic> getLatestPayslip() {
    return {
      'month': 'July 2026',
      'netSalary': '₹85,450',
      'basic': '₹50,000',
      'allowances': '₹28,450',
      'otherEarnings': '₹12,000',
      'pfDeduction': '₹3,500',
      'taxDeduction': '₹1,500',
      'totalDeductions': '₹5,000',
      'paidDate': '31 Jul 2026',
      'bankAccount': 'HDFC Bank (•••• 4092)',
    };
  }
}

class AttendanceService {
  Map<String, dynamic> getTodayAttendance() {
    return {
      'date': 'Today, 11 Aug 2026',
      'checkIn': '09:02 AM',
      'checkOut': 'Not checked out',
      'workingHours': '04h 32m',
      'status': 'Present',
      'location': 'Jotun HQ - Plant Facility B',
      'regularizationPending': false,
    };
  }
}

class PolicyService {
  Map<String, dynamic> searchPolicy(String query) {
    final q = query.toLowerCase();
    if (q.contains('leave') || q.contains('casual') || q.contains('annual') || q.contains('sick')) {
      return {
        'found': true,
        'title': 'Annual & Casual Leave Policy',
        'shortAnswer': 'Employees are entitled to 12 casual, 7 sick, and 15 annual leaves per calendar year.',
        'keyPoints': [
          'Pre-approval required 24 hours prior for casual leave > 2 days.',
          'Medical certificate mandatory for sick leave exceeding 2 consecutive days.',
          'Annual leaves carry over up to 5 days into the next calendar year.',
        ],
        'fullDocument': 'Jotun HR Manual Section 4.1',
      };
    } else if (q.contains('wfh') || q.contains('home')) {
      return {
        'found': true,
        'title': 'Work From Home (WFH) Policy',
        'shortAnswer': 'Eligible office-based employees can request up to 2 WFH days per week with manager consent.',
        'keyPoints': [
          'Must maintain core working hours (09:00 AM - 05:30 PM).',
          'VPN connection required for security compliance.',
          'Plant operational staff require specific shift exception approvals.',
        ],
        'fullDocument': 'Jotun HR Policy Guidelines v3.2',
      };
    } else if (q.contains('overtime')) {
      return {
        'found': true,
        'title': 'Overtime Compensation Policy',
        'shortAnswer': 'Plant operations overtime requires pre-approval and is calculated at 1.5x standard hourly rate.',
        'keyPoints': [
          'Overtime requests must be submitted at least 24h in advance.',
          'Maximum 12 hours overtime permitted per week.',
          'Calculated automatically via biometric attendance logs.',
        ],
        'fullDocument': 'Jotun Operations Policy 4.2',
      };
    }
    return {'found': false};
  }
}

class SearchKnowledgeService {
  List<Map<String, dynamic>> searchWorkplace(String query) {
    return [
      {
        'title': 'Jotun Enterprise Travel Policy 2026',
        'category': 'Finance & Travel',
        'summary': 'Guidelines on domestic and international business travel allowances, flight bookings, and hotel caps.',
        'lastUpdated': 'Updated Jan 2026',
      },
      {
        'title': 'EHS Plant Safety Manual',
        'category': 'Environment & Safety',
        'summary': 'Mandatory safety protocol for wearing PPE in manufacturing zones and emergency evacuation paths.',
        'lastUpdated': 'Updated Jun 2026',
      },
      {
        'title': 'IT Security & Device Usage Handbook',
        'category': 'IT Support',
        'summary': 'Rules regarding laptop encryption, password rotation, and remote access VPN standards.',
        'lastUpdated': 'Updated Mar 2026',
      },
    ];
  }
}
