import '../models/ai_intent.dart';
import 'workplace_services.dart';

class AiService {
  final WorkplaceServices workplaceServices;

  // Multi-turn slot memory
  String? _activeFlow;
  Map<String, dynamic> _flowData = {};

  AiService({required this.workplaceServices});

  AiMessage processUserMessage(String query) {
    final nowStr = _getFormattedTime();
    final lower = query.toLowerCase().trim();

    // 1. Check Active Flow Continuation
    if (_activeFlow == 'LEAVE_FLOW') {
      return _continueLeaveFlow(lower, nowStr);
    } else if (_activeFlow == 'IT_FLOW') {
      return _continueITFlow(lower, nowStr);
    }

    // 2. Advanced Multi-Slot Extraction for Leave
    if (lower.contains('leave') || lower.contains('vacation') || lower.contains('off')) {
      if (lower.contains('apply') || lower.contains('need') || lower.contains('take') || lower.contains('tomorrow') || lower.contains('friday')) {
        _activeFlow = 'LEAVE_FLOW';
        _flowData = {};

        // Extract Leave Type
        String type = 'Casual Leave';
        if (lower.contains('sick')) type = 'Sick Leave';
        if (lower.contains('annual')) type = 'Annual Leave';
        if (lower.contains('maternity') || lower.contains('paternity')) type = 'Maternity/Paternity';

        // Extract Duration/Days
        int days = 1;
        if (lower.contains('2 days') || lower.contains('two days')) days = 2;
        if (lower.contains('3 days') || lower.contains('three days')) days = 3;
        if (lower.contains('week')) days = 5;

        // If user gave full info in one prompt: "apply 2 days casual leave tomorrow for personal work"
        final hasFullInfo = (lower.contains('for ') || lower.contains('reason')) && (lower.contains('tomorrow') || lower.contains('days'));
        if (hasFullInfo) {
          const startDateStr = '12 Aug 2026';
          final endDateStr = days == 1 ? '12 Aug 2026' : '13 Aug 2026';
          final reason = _extractReason(lower) ?? 'Personal work';

          return AiMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            isUser: false,
            text: '🤖 AI Model extracted your request details. Please review your application:',
            time: nowStr,
            responseType: AiResponseType.leaveConfirmationCard,
            data: {
              'type': type,
              'startDate': startDateStr,
              'endDate': endDateStr,
              'days': days,
              'reason': reason,
              'aiInsight': 'AI Copilot Insight: 8 Casual days remaining. No conflicting high-priority plant tasks detected.',
            },
            quickActions: ['Edit Application', 'Cancel Request'],
          );
        }

        // Standard Leave Form Workflow
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'Sure! I can help you apply for leave. Please verify the leave parameters below:',
          time: nowStr,
          responseType: AiResponseType.leaveFormCard,
          data: {
            'initialType': type,
            'availableCasual': 8,
            'availableSick': 5,
            'availableAnnual': 12,
            'aiInsight': '98% Intent Match: Leave Application Workflow',
          },
          quickActions: ['Check Leave Policy', 'Cancel Request'],
        );
      } else {
        // Leave balance query
        final balances = workplaceServices.getLeaveBalances();
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'Here is your real-time leave balance with predictive carry-forward projection:',
          time: nowStr,
          responseType: AiResponseType.leaveBalanceCard,
          data: {
            'balances': balances,
            'aiInsight': 'Predictive Analysis: You will carry forward 5 Annual Leave days into 2027.',
          },
          quickActions: ['Apply Leave', 'View Leave Policy', 'Show Pending Requests'],
        );
      }
    }

    // 3. Task Management & AI Prioritization
    if (lower.contains('task') || lower.contains('to do') || lower.contains('assigned') || lower.contains('finish today') || lower.contains('overdue')) {
      String filter = 'All';
      if (lower.contains('today')) filter = 'Today';
      if (lower.contains('upcoming') || lower.contains('week')) filter = 'Upcoming';
      final tasks = workplaceServices.getTasks(filter: filter);

      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: false,
        text: 'AI Copilot prioritized your active workplace tasks:',
        time: nowStr,
        responseType: AiResponseType.taskListCard,
        data: {
          'tasks': tasks,
          'activeFilter': filter,
          'aiInsight': 'AI Risk Alert: 1 High-priority plant safety task requires submission before 5:00 PM today.',
        },
        quickActions: ['View High Priority', 'Show Completed', 'Create New Task'],
      );
    }

    // 4. IT Support & Issue Classification Engine
    if (lower.contains('it') || lower.contains('ticket') || lower.contains('laptop') || lower.contains('vpn') || lower.contains('software') || lower.contains('wifi') || lower.contains('printer')) {
      if (lower.contains('status') || lower.contains('track') || lower.contains('my ticket')) {
        final tickets = workplaceServices.getITTickets();
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'AI system retrieved your active IT Support ticket status:',
          time: nowStr,
          responseType: AiResponseType.itTicketStatusCard,
          data: {
            'tickets': tickets,
            'aiInsight': 'SLA Estimate: Ticket #IT-1024 is currently in active investigation by Senior Engineer Alex.',
          },
          quickActions: ['Create New Ticket', 'Contact IT Desk'],
        );
      } else {
        _activeFlow = 'IT_FLOW';
        _flowData = {};
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'Jotun IT Copilot: Which issue category are you experiencing?',
          time: nowStr,
          responseType: AiResponseType.itClassificationCard,
          quickActions: ['Cancel IT Request'],
        );
      }
    }

    // 5. Secure Payslip & Financial Insights
    if (lower.contains('payslip') || lower.contains('salary') || lower.contains('paystub') || lower.contains('earnings')) {
      final payslip = workplaceServices.getLatestPayslip();
      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: false,
        text: 'Your verified July 2026 payslip is ready (End-to-End Encrypted):',
        time: nowStr,
        responseType: AiResponseType.payslipCard,
        data: payslip,
        quickActions: ['Download Payslip PDF', 'Open Payroll Module', 'Tax Breakdown'],
      );
    }

    // 6. Attendance & Shift Monitoring
    if (lower.contains('attendance') || lower.contains('check-in') || lower.contains('check in') || lower.contains('working hours') || lower.contains('late')) {
      final att = workplaceServices.getTodayAttendance();
      return AiMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        isUser: false,
        text: 'Here is your real-time attendance telemetry for today:',
        time: nowStr,
        responseType: AiResponseType.attendanceCard,
        data: att,
        quickActions: ['Attendance Regularization', 'View Monthly Log'],
      );
    }

    // 7. HR Policy RAG Knowledge Engine
    if (lower.contains('policy') || lower.contains('handbook') || lower.contains('rules') || lower.contains('guidelines') || lower.contains('wfh')) {
      final policy = workplaceServices.searchPolicy(lower);
      if (policy != null) {
        return AiMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isUser: false,
          text: 'AI RAG Engine retrieved the official enterprise policy document:',
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
            'errorTitle': 'Policy Citation Not Found',
            'errorMessage': 'No matching official policy document was indexed for your query.',
          },
          quickActions: ['Contact HR', 'Browse HR Portal'],
        );
      }
    }

    // Fallback AI Assistant Response
    return AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isUser: false,
      text: 'I parsed your input as a general workplace query. How would you like me to assist you?',
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

  String? _extractReason(String query) {
    if (query.contains('for ')) {
      final parts = query.split('for ');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    return null;
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
