import 'package:flutter/material.dart';

enum AiIntentType {
  generalGreeting,
  leaveBalance,
  leaveApply,
  leaveStatus,
  leaveCancel,
  taskList,
  taskUpdate,
  itTroubleshoot,
  itCreateTicket,
  itTrackTicket,
  payslipView,
  attendanceToday,
  attendanceHistory,
  policySearch,
  workplaceSearch,
  unknown,
}

enum AiResponseType {
  text,
  bulletList,
  leaveBalanceCard,
  leaveFormCard,
  leaveConfirmationCard,
  leaveStatusCard,
  taskListCard,
  itClassificationCard,
  itTicketFormCard,
  itTicketStatusCard,
  payslipCard,
  attendanceCard,
  policyCard,
  searchResultCard,
  errorCard,
}

class AiMessage {
  final String id;
  final bool isUser;
  final String text;
  final String time;
  final AiResponseType responseType;
  final Map<String, dynamic>? data;
  final List<String>? quickActions;

  AiMessage({
    required this.id,
    required this.isUser,
    required this.text,
    required this.time,
    this.responseType = AiResponseType.text,
    this.data,
    this.quickActions,
  });

  AiMessage copyWith({
    String? id,
    bool? isUser,
    String? text,
    String? time,
    AiResponseType? responseType,
    Map<String, dynamic>? data,
    List<String>? quickActions,
  }) {
    return AiMessage(
      id: id ?? this.id,
      isUser: isUser ?? this.isUser,
      text: text ?? this.text,
      time: time ?? this.time,
      responseType: responseType ?? this.responseType,
      data: data ?? this.data,
      quickActions: quickActions ?? this.quickActions,
    );
  }
}

class LeaveBalanceItem {
  final String type;
  final int total;
  final int used;
  final int available;
  final Color color;

  LeaveBalanceItem({
    required this.type,
    required this.total,
    required this.used,
    required this.available,
    required this.color,
  });
}

class TaskItem {
  final String id;
  final String title;
  final String category;
  final String dueDate;
  final String priority; // High, Medium, Low
  final String status; // Pending, In Progress, Completed
  final bool isOverdue;

  TaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.isOverdue = false,
  });
}

class ITTicketItem {
  final String ticketId;
  final String issue;
  final String category;
  final String priority;
  final String status;
  final String assignedTo;
  final String lastUpdated;

  ITTicketItem({
    required this.ticketId,
    required this.issue,
    required this.category,
    required this.priority,
    required this.status,
    required this.assignedTo,
    required this.lastUpdated,
  });
}

class ConversationHistoryItem {
  final String id;
  final String title;
  final String dateStr;
  final String category; // Today, Yesterday, Older
  final String lastMessage;
  final bool isSaved;

  ConversationHistoryItem({
    required this.id,
    required this.title,
    required this.dateStr,
    required this.category,
    required this.lastMessage,
    this.isSaved = false,
  });
}

class SavedBookmarkItem {
  final String id;
  final String title;
  final String category; // Policies, Answers, Documents, Conversations
  final String snippet;
  final String savedDate;

  SavedBookmarkItem({
    required this.id,
    required this.title,
    required this.category,
    required this.snippet,
    required this.savedDate,
  });
}
