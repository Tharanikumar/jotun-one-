import 'ai_assistant_services.dart';

enum AIIntent {
  leaveApply,
  leaveBalance,
  leaveStatus,
  leaveCancel,
  taskList,
  taskDetails,
  taskUpdate,
  taskComplete,
  attendanceToday,
  attendanceHistory,
  attendanceRegularization,
  payslipView,
  payslipDownload,
  itCreateTicket,
  itTrackTicket,
  itTroubleshoot,
  policySearch,
  documentSearch,
  profileView,
  notificationView,
  clarificationNeeded,
  generalQuery,
}

enum AICardType {
  normalText,
  bulletList,
  leaveForm,
  leaveReview,
  leaveSubmitted,
  leaveBalance,
  taskList,
  itClassifier,
  itTicketStatus,
  payslip,
  attendance,
  policy,
  documentSearch,
  clarification,
  errorRecovery,
}

class AIChatMessage {
  final String id;
  final bool isUser;
  final String text;
  final String time;
  final AICardType cardType;
  final Map<String, dynamic>? data;
  final List<String>? suggestedActions;

  AIChatMessage({
    required this.id,
    required this.isUser,
    required this.text,
    required this.time,
    this.cardType = AICardType.normalText,
    this.data,
    this.suggestedActions,
  });
}

class AIIntentOrchestrator {
  final LeaveService _leaveService = LeaveService();
  final TaskService _taskService = TaskService();
  final ITTicketService _itService = ITTicketService();
  final PayrollService _payrollService = PayrollService();
  final AttendanceService _attendanceService = AttendanceService();
  final PolicyService _policyService = PolicyService();
  final SearchKnowledgeService _searchService = SearchKnowledgeService();

  // Active conversational state for multi-turn slot filling
  String? _activeWorkflow; // 'leave', 'it_ticket'
  Map<String, dynamic> _draftWorkflowData = {};

  AIIntent parseIntent(String userInput) {
    final text = userInput.toLowerCase().trim();

    if (_activeWorkflow == 'leave') {
      if (text.contains('cancel') || text.contains('stop')) {
        _activeWorkflow = null;
        _draftWorkflowData.clear();
      } else {
        return AIIntent.leaveApply;
      }
    }

    if (text.contains('apply leave') ||
        text.contains('need leave') ||
        text.contains('take leave') ||
        text.contains('request leave') ||
        text.contains('sick leave') ||
        text.contains('casual leave')) {
      return AIIntent.leaveApply;
    }

    if (text.contains('leave balance') || text.contains('how many leaves')) {
      return AIIntent.leaveBalance;
    }

    if (text.contains('pending leave') || text.contains('leave status')) {
      return AIIntent.leaveStatus;
    }

    if (text.contains('task') ||
        text.contains('assigned') ||
        text.contains('todo') ||
        text.contains('to finish')) {
      return AIIntent.taskList;
    }

    if (text.contains('ticket') ||
        text.contains('it support') ||
        text.contains('laptop') ||
        text.contains('computer') ||
        text.contains('wifi') ||
        text.contains('network') ||
        text.contains('printer')) {
      if (text.contains('track') || text.contains('status') || text.contains('#it')) {
        return AIIntent.itTrackTicket;
      }
      return AIIntent.itCreateTicket;
    }

    if (text.contains('payslip') || text.contains('salary') || text.contains('pay slip')) {
      return AIIntent.payslipView;
    }

    if (text.contains('attendance') ||
        text.contains('check in') ||
        text.contains('check out') ||
        text.contains('late today')) {
      return AIIntent.attendanceToday;
    }

    if (text.contains('policy') ||
        text.contains('wfh') ||
        text.contains('work from home') ||
        text.contains('overtime') ||
        text.contains('maternity')) {
      return AIIntent.policySearch;
    }

    if (text.contains('find') ||
        text.contains('document') ||
        text.contains('handbook') ||
        text.contains('where is')) {
      return AIIntent.documentSearch;
    }

    return AIIntent.generalQuery;
  }

  Future<AIChatMessage> processMessage(String userInput) async {
    final intent = parseIntent(userInput);
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final msgId = DateTime.now().millisecondsSinceEpoch.toString();

    switch (intent) {
      case AIIntent.leaveApply:
        return _handleLeaveApplyFlow(userInput, msgId, timeStr);

      case AIIntent.leaveBalance:
        final balances = _leaveService.getLeaveBalances();
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: "Here is your current leave balance for 2026:",
          time: timeStr,
          cardType: AICardType.leaveBalance,
          data: {'balances': balances},
          suggestedActions: ['Apply Leave', 'View Pending Requests', 'Leave Policy'],
        );

      case AIIntent.leaveStatus:
        final pending = _leaveService.getPendingRequests();
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: "Here are your pending leave requests:",
          time: timeStr,
          cardType: AICardType.leaveBalance,
          data: {'pending': pending},
          suggestedActions: ['Apply Leave', 'Back to Dashboard'],
        );

      case AIIntent.taskList:
        final tasks = _taskService.getTasks();
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: "Here are the tasks currently assigned to you:",
          time: timeStr,
          cardType: AICardType.taskList,
          data: {'tasks': tasks},
          suggestedActions: ['View All Tasks', 'High Priority Only', 'Completed Tasks'],
        );

      case AIIntent.itCreateTicket:
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: "I can help you report an IT issue and create a support ticket.",
          time: timeStr,
          cardType: AICardType.itClassifier,
          data: {
            'categories': ['Network', 'Laptop', 'Software', 'Email', 'Printer', 'Other'],
          },
          suggestedActions: ['Track IT Ticket #IT-1024', 'Contact IT Desk'],
        );

      case AIIntent.itTrackTicket:
        final ticket = _itService.getTicketStatus('IT-1024');
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: "Here is the status of your recent IT support ticket:",
          time: timeStr,
          cardType: AICardType.itTicketStatus,
          data: ticket,
          suggestedActions: ['Contact IT Support', 'Report New Issue'],
        );

      case AIIntent.payslipView:
        final payslip = _payrollService.getLatestPayslip();
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: "Your latest payslip for ${payslip['month']} is available securely.",
          time: timeStr,
          cardType: AICardType.payslip,
          data: payslip,
          suggestedActions: ['Download Payslip (PDF)', 'Open Payroll Module'],
        );

      case AIIntent.attendanceToday:
        final att = _attendanceService.getTodayAttendance();
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: "Here is your attendance record for today:",
          time: timeStr,
          cardType: AICardType.attendance,
          data: att,
          suggestedActions: ['Regularize Attendance', 'View Monthly Log'],
        );

      case AIIntent.policySearch:
        final policy = _policyService.searchPolicy(userInput);
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: policy['found'] == true
              ? "Here is the official company policy for ${policy['title']}:"
              : "I couldn't find an official policy for that. Please check HR or the official policy portal.",
          time: timeStr,
          cardType: policy['found'] == true ? AICardType.policy : AICardType.normalText,
          data: policy,
          suggestedActions: ['View Full Policy Document', 'Contact HR Desk'],
        );

      case AIIntent.documentSearch:
        final docs = _searchService.searchWorkplace(userInput);
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: "Here are matching workplace documents and resources:",
          time: timeStr,
          cardType: AICardType.documentSearch,
          data: {'documents': docs},
          suggestedActions: ['Search HR Portal', 'Ask HR Desk'],
        );

      default:
        final q = userInput.toLowerCase();
        if (q.contains('hello') || q.contains('hi')) {
          return AIChatMessage(
            id: msgId,
            isUser: false,
            text: "Hello Tharani! 👋 I am your Jotun One AI Workplace Assistant. You can ask me about leave balances, active tasks, IT support tickets, payslips, or company HR policies.",
            time: timeStr,
            suggestedActions: ['How many leaves do I have?', 'What tasks do I have today?', 'Show my payslip'],
          );
        }
        return AIChatMessage(
          id: msgId,
          isUser: false,
          text: "I am processing your query: \"$userInput\". I can help you apply for leave, manage assigned tasks, track IT tickets, check attendance, view payslips, or search HR policies.",
          time: timeStr,
          suggestedActions: ['Apply for leave', 'Show my tasks', 'Report IT issue'],
        );
    }
  }

  AIChatMessage _handleLeaveApplyFlow(String input, String msgId, String timeStr) {
    _activeWorkflow = 'leave';
    final text = input.toLowerCase();

    String defaultType = 'Casual Leave';
    if (text.contains('sick')) defaultType = 'Sick Leave';
    if (text.contains('annual')) defaultType = 'Annual Leave';

    _draftWorkflowData = {
      'leaveType': defaultType,
      'startDate': '15 Aug 2026',
      'endDate': '16 Aug 2026',
      'days': 2,
      'reason': 'Personal work',
      'availableBalance': 8,
    };

    return AIChatMessage(
      id: msgId,
      isUser: false,
      text: "Sure! I can help you apply for leave. Please fill in the details below:",
      time: timeStr,
      cardType: AICardType.leaveForm,
      data: _draftWorkflowData,
      suggestedActions: ['Check Leave Balance', 'Cancel Request'],
    );
  }

  AIChatMessage submitLeaveRequest(Map<String, dynamic> formData) {
    final result = _leaveService.submitLeave(formData);
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _activeWorkflow = null;
    _draftWorkflowData.clear();

    return AIChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isUser: false,
      text: "✓ Leave request submitted successfully.",
      time: timeStr,
      cardType: AICardType.leaveSubmitted,
      data: result,
      suggestedActions: ['View Request', 'Go to Leave Module'],
    );
  }
}
