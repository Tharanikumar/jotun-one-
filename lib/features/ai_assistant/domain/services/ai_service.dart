import '../models/ai_intent.dart';
import 'workplace_services.dart';

class AiService {
  final WorkplaceServices workplaceServices;

  // Active multi-turn state context
  String? _activeFlow; // 'LEAVE_FLOW', 'IT_FLOW'
  Map<String, dynamic> _flowData = {};

  AiService({required this.workplaceServices});

  AiMessage processUserMessage(String query) {
    final nowStr = _getFormattedTime();
    final lower = query.toLowerCase().trim();

    // 1. Handle Active Multi-Turn Flow Continuations
    if (_activeFlow == 'LEAVE_FLOW') {
      return _continueLeaveFlow(lower, nowStr);
    } else if (_activeFlow == 'IT_FLOW') {
      return _continueITFlow(lower, nowStr);
    }

    // 2. Intent Parsing
    if (lower.contains('leave') || lower.contains('vacation') || lower.contains('time off')) {
      if (lower.contains('apply') || lower.contains('need') || lower.contains('take') || lower.contains('tomorrow') || lower.contains('friday')) {
        _activeFlow = 'LEAVE_FLOW';
        _flowData = {};

        // Extract dates/type if mentioned
        if (lower.contains('casual')) _flowData['type'] = 'Casual Leave';
        if (lower.contains('sick')) _flowData['type'] = 'Sick Leave';
        if (lower.contains('annual')) _flowData['type'] = 'Annual Leave';

        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'Sure, I can help you apply for leave. Please specify your leave details below:',
          time: nowStr,
          responseType: AiResponseType.leaveFormCard,
          data: {
            'initialType': _flowData['type'] ?? 'Casual Leave',
            'availableCasual': 8,
            'availableSick': 5,
            'availableAnnual': 12,
          },
          quickActions: ['Cancel Request'],
        );
      } else {
        // Leave balance inquiry
        final balances = workplaceServices.getLeaveBalances();
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'Here is your current live leave balance summary:',
          time: nowStr,
          responseType: AiResponseType.leaveBalanceCard,
          data: {'balances': balances},
          quickActions: ['Apply Leave', 'View Leave Policy', 'Show Pending Requests'],
        );
      }
    }

    // Task Intents
    if (lower.contains('task') || lower.contains('to do') || lower.contains('assigned') || lower.contains('finish today') || lower.contains('overdue')) {
      String filter = 'All';
      if (lower.contains('today')) filter = 'Today';
      if (lower.contains('upcoming') || lower.contains('week')) filter = 'Upcoming';
      final tasks = workplaceServices.getTasks(filter: filter);

      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: false,
        text: 'Here are your active workplace tasks:',
        time: nowStr,
        responseType: AiResponseType.taskListCard,
        data: {'tasks': tasks, 'activeFilter': filter},
        quickActions: ['View High Priority', 'Show Completed', 'Create New Task'],
      );
    }

    // IT Support Intents
    if (lower.contains('it') || lower.contains('ticket') || lower.contains('laptop') || lower.contains('vpn') || lower.contains('software') || lower.contains('wifi') || lower.contains('printer')) {
      if (lower.contains('status') || lower.contains('track') || lower.contains('my ticket')) {
        final tickets = workplaceServices.getITTickets();
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'Here is the current status of your active IT ticket:',
          time: nowStr,
          responseType: AiResponseType.itTicketStatusCard,
          data: {'tickets': tickets},
          quickActions: ['Create New Ticket', 'Contact IT Desk'],
        );
      } else {
        _activeFlow = 'IT_FLOW';
        _flowData = {};
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'I can assist you with IT Support. Which category best describes your issue?',
          time: nowStr,
          responseType: AiResponseType.itClassificationCard,
          quickActions: ['Cancel IT Request'],
        );
      }
    }

    // Payslip / Salary
    if (lower.contains('payslip') || lower.contains('salary') || lower.contains('paystub') || lower.contains('earnings')) {
      final payslip = workplaceServices.getLatestPayslip();
      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: false,
        text: 'Your latest verified payslip for July 2026 is ready:',
        time: nowStr,
        responseType: AiResponseType.payslipCard,
        data: payslip,
        quickActions: ['Download Payslip PDF', 'Open Payroll Module', 'Tax Breakdown'],
      );
    }

    // Attendance
    if (lower.contains('attendance') || lower.contains('check-in') || lower.contains('check in') || lower.contains('working hours') || lower.contains('late')) {
      final att = workplaceServices.getTodayAttendance();
      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: false,
        text: 'Here is your attendance record for today:',
        time: nowStr,
        responseType: AiResponseType.attendanceCard,
        data: att,
        quickActions: ['Attendance Regularization', 'View Monthly Log'],
      );
    }

    // HR Policy Search
    if (lower.contains('policy') || lower.contains('handbook') || lower.contains('rules') || lower.contains('guidelines') || lower.contains('wfh')) {
      final policy = workplaceServices.searchPolicy(lower);
      if (policy != null) {
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'I found the relevant company policy details:',
          time: nowStr,
          responseType: AiResponseType.policyCard,
          data: policy,
          quickActions: ['View Full Policy', 'Save to Bookmarks'],
        );
      } else {
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: "I couldn't find an official policy matching your query. Please check HR or the official policy portal.",
          time: nowStr,
          responseType: AiResponseType.errorCard,
          data: {
            'errorTitle': 'Policy Not Found',
            'errorMessage': 'No matching official policy document was found for your exact request.',
          },
          quickActions: ['Contact HR', 'Browse HR Portal'],
        );
      }
    }

    // Default Fallback Response
    return AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isUser: false,
      text: 'I can assist you with your request. Would you like me to guide you to the right module or perform an action?',
      time: nowStr,
      responseType: AiResponseType.text,
      quickActions: ['Apply Leave', 'Check Tasks', 'IT Support', 'View Payslip'],
    );
  }

  AiMessage _continueLeaveFlow(String lower, String nowStr) {
    if (lower.contains('cancel')) {
      _resetFlow();
      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: false,
        text: 'Leave application workflow cancelled.',
        time: nowStr,
      );
    }
    return processUserMessage(lower);
  }

  AiMessage _continueITFlow(String lower, String nowStr) {
    if (lower.contains('cancel')) {
      _resetFlow();
      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: false,
        text: 'IT Support request cancelled.',
        time: nowStr,
      );
    }
    return processUserMessage(lower);
  }

  void _resetFlow() {
    _activeFlow = null;
    _flowData.clear();
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
