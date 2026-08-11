import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../domain/models/ai_intent.dart';
import '../domain/services/ai_service.dart';
import '../domain/services/workplace_services.dart';
import 'widgets/ai_capabilities_sheet.dart';
import 'widgets/ai_response_cards.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  late final WorkplaceServices _workplaceServices;
  late final AiService _aiService;

  int _activeTab = 0; // 0: Smart, 1: History, 2: Saved
  bool _isTyping = false;
  String _historySearchQuery = '';
  String _savedSearchQuery = '';
  String _savedCategoryFilter = 'All';

  final List<AiMessage> _messages = [];
  final List<String> _typingSuggestions = [];

  final List<Map<String, dynamic>> _quickQuestions = [
    {
      'title': 'How can I apply for leave?',
      'category': 'Leave & Attendance',
      'icon': Icons.calendar_month_rounded,
      'color': const Color(0xFF2563EB),
      'bgColor': const Color(0xFFEFF6FF),
    },
    {
      'title': 'My IT ticket is not working',
      'category': 'IT Support',
      'icon': Icons.headset_mic_rounded,
      'color': const Color(0xFF8B5CF6),
      'bgColor': const Color(0xFFF5F3FF),
    },
    {
      'title': 'Show my latest payslip',
      'category': 'Payslip',
      'icon': Icons.receipt_long_rounded,
      'color': const Color(0xFF10B981),
      'bgColor': const Color(0xFFECFDF5),
    },
    {
      'title': 'What tasks are assigned to me?',
      'category': 'Tasks',
      'icon': Icons.task_alt_rounded,
      'color': const Color(0xFFF59E0B),
      'bgColor': const Color(0xFFFFF7ED),
    },
    {
      'title': 'What is my attendance status?',
      'category': 'Attendance',
      'icon': Icons.access_time_filled_rounded,
      'color': const Color(0xFF06B6D4),
      'bgColor': const Color(0xFFECFEFF),
    },
    {
      'title': 'What is the annual leave policy?',
      'category': 'HR Policy',
      'icon': Icons.article_rounded,
      'color': const Color(0xFFEC4899),
      'bgColor': const Color(0xFFFDF2F8),
    },
  ];

  @override
  void initState() {
    super.initState();
    _workplaceServices = WorkplaceServices();
    _aiService = AiService(workplaceServices: _workplaceServices);

    _messageController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onInputChanged);
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    final text = _messageController.text.toLowerCase().trim();
    setState(() {
      _typingSuggestions.clear();
      if (text.contains('leave')) {
        _typingSuggestions.addAll(['Apply for leave', 'Check leave balance', 'View pending leave', 'Cancel leave request', 'Leave policy']);
      } else if (text.contains('it') || text.contains('ticket') || text.contains('laptop')) {
        _typingSuggestions.addAll(['Track IT ticket #IT-1024', 'VPN issue', 'Create IT ticket', 'Contact IT Desk']);
      } else if (text.contains('task')) {
        _typingSuggestions.addAll(['What do I need to finish today?', 'Show high priority tasks', 'Overdue tasks']);
      } else if (text.contains('pay') || text.contains('salary')) {
        _typingSuggestions.addAll(['Show my latest payslip', 'Download July 2026 payslip', 'Tax deductions breakdown']);
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = AiMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isUser: true,
      text: text,
      time: _getFormattedTime(),
    );

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
      _messageController.clear();
      _typingSuggestions.clear();
    });

    _scrollToBottom(smooth: true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        final botMsg = _aiService.processUserMessage(text);
        setState(() {
          _isTyping = false;
          _messages.add(botMsg);
        });
        _scrollToBottom(smooth: true);
      }
    });
  }

  void _scrollToBottom({bool smooth = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      final target = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      final distance = (target - current).abs();

      if (distance < 5) return; // Already at bottom

      if (smooth) {
        _scrollController.animateTo(
          target,
          duration: Duration(milliseconds: (distance > 300 ? 450 : 250)),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _scrollController.jumpTo(target);
      }
    });
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (scaffoldContext) => Padding(
            padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: Colors.black12,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Scaffold.of(scaffoldContext).openDrawer(),
                child: const Icon(Icons.menu_rounded, color: AppColors.navyDark, size: 20),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8),
                ],
              ),
              child: const Stack(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/images/penguin_ai_assistant.png'),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(radius: 4, backgroundColor: AppColors.success),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI Assistant',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.navyDark),
                ),
                Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('Online Copilot', style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (_messages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 6, top: 8, bottom: 8),
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 2,
                shadowColor: Colors.black12,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    setState(() {
                      _messages.clear();
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.refresh_rounded, color: AppColors.navyDark, size: 18),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: Colors.black12,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => AiCapabilitiesSheet.show(context, _sendMessage),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.auto_awesome, color: AppColors.accentPurple, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  // Mobile Single-Column Layout
  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(child: _buildTabBody()),
        _buildBottomBar(),
      ],
    );
  }

  // Desktop Dual-Column Layout
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(child: _buildTabBody()),
              _buildBottomBar(),
            ],
          ),
        ),
        const VerticalDivider(width: 1, color: AppColors.borderLight),
        Expanded(
          flex: 2,
          child: _buildRightContextualPanel(),
        ),
      ],
    );
  }

  Widget _buildRightContextualPanel() {
    final tasks = _workplaceServices.getTasks(filter: 'Today');
    final balances = _workplaceServices.getLeaveBalances();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contextual Workplace Overview', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Today Tasks Priority', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          ...tasks.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(t.title, style: AppTypography.bodySmall)),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          Text('Quick Leave Balances', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          ...balances.take(3).map((b) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(b.type, style: AppTypography.bodySmall),
                    Text('${b.available} days', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold, color: b.color)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTabBody() {
    if (_activeTab == 1) return _buildHistoryTabView();
    if (_activeTab == 2) return _buildSavedTabView();
    return _buildSmartTabView();
  }

  // Tab 0: Smart AI Chat View
  Widget _buildSmartTabView() {
    final hasMessages = _messages.isNotEmpty;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Waving Penguin Mascot (Compact when conversation is active)
          if (!hasMessages) ...[
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withAlpha(45),
                          AppColors.primaryLight.withAlpha(10),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/penguin_ai_assistant.png',
                    height: 165,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Contextual Blue Gradient Greeting Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8), Color(0xFF1E40AF)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withAlpha(80), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(color: Colors.white.withAlpha(70), shape: BoxShape.circle),
                      child: const CircleAvatar(radius: 20, backgroundImage: AssetImage('assets/images/penguin_ai_assistant.png')),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi Tharani 👋', style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("I'm your Jotun One AI Workplace Assistant.", style: TextStyle(color: Colors.white.withAlpha(240), fontSize: 14)),
                          Text('How can I help you today?', style: TextStyle(color: Colors.white.withAlpha(240), fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Live Workplace Contextual Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _contextChip('3 tasks due this week', Icons.task_alt_rounded, () => _sendMessage('What tasks do I have today?')),
                    _contextChip('Leave balance updated', Icons.calendar_month_rounded, () => _sendMessage('How many casual leaves do I have?')),
                    _contextChip('1 IT ticket in progress', Icons.headset_mic_rounded, () => _sendMessage('Track IT ticket status')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Render Chat Messages List
          if (_messages.isNotEmpty) ...[
            ..._messages.map((msg) => _buildMessageBubble(msg)),
            if (_isTyping) _buildTypingIndicator(),
            const SizedBox(height: 20),
          ],

          // Quick Questions Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quick Questions', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.navyDark)),
              InkWell(
                onTap: () => AiCapabilitiesSheet.show(context, _sendMessage),
                child: Row(
                  children: [
                    Text('View All', style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ..._quickQuestions.map((q) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () => _sendMessage(q['title'] as String),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: q['bgColor'] as Color, borderRadius: BorderRadius.circular(12)),
                            child: Icon(q['icon'] as IconData, color: q['color'] as Color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  q['title'] as String,
                                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.navyDark),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  q['category'] as String,
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _contextChip(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: Colors.white.withAlpha(45), borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 4),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // Message Bubble & Card Renderer
  Widget _buildMessageBubble(AiMessage msg) {
    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18).copyWith(bottomRight: const Radius.circular(4)),
              boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(40), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35)),
          ),
        ),
      );
    }

    // AI Bot Response with Dynamic Cards
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 12, backgroundImage: AssetImage('assets/images/penguin_ai_assistant.png')),
              const SizedBox(width: 8),
              Text('Jotun Copilot', style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.navyDark)),
              const SizedBox(width: 6),
              Text(msg.time, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.88),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (msg.text.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18).copyWith(topLeft: const Radius.circular(4)), boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 3))]),
                    child: Text(msg.text, style: AppTypography.bodySmall.copyWith(color: AppColors.navyDark, height: 1.4)),
                  ),
                _renderCardForResponse(msg),
                if (msg.quickActions != null && msg.quickActions!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: msg.quickActions!.map((act) {
                      return ActionChip(
                        label: Text(act, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        backgroundColor: AppColors.primary.withAlpha(15),
                        side: BorderSide(color: AppColors.primary.withAlpha(40)),
                        onPressed: () => _sendMessage(act),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderCardForResponse(AiMessage msg) {
    switch (msg.responseType) {
      case AiResponseType.leaveBalanceCard:
        final balances = (msg.data?['balances'] as List<dynamic>? ?? []).cast<LeaveBalanceItem>();
        return LeaveBalanceCardWidget(
          balances: balances,
          onApplyLeave: (type) => _sendMessage('Apply $type'),
        );

      case AiResponseType.leaveFormCard:
        return LeaveFormCardWidget(
          initialType: msg.data?['initialType'] as String? ?? 'Casual Leave',
          onFormSubmitted: (formData) {
            setState(() {
              _messages.add(AiMessage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                isUser: false,
                text: 'Please review your leave application before submission:',
                time: _getFormattedTime(),
                responseType: AiResponseType.leaveConfirmationCard,
                data: formData,
              ));
            });
            _scrollToBottom();
          },
        );

      case AiResponseType.leaveConfirmationCard:
        final formData = msg.data ?? {};
        return LeaveConfirmationCardWidget(
          data: formData,
          onEdit: () => _sendMessage('Apply leave'),
          onConfirm: () {
            final res = _workplaceServices.submitLeaveRequest(
              type: formData['type'] as String? ?? 'Casual Leave',
              startDate: formData['startDate'] as String? ?? 'Tomorrow',
              endDate: formData['endDate'] as String? ?? 'Tomorrow',
              days: formData['days'] as int? ?? 1,
              reason: formData['reason'] as String? ?? 'Personal work',
            );
            setState(() {
              _messages.add(AiMessage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                isUser: false,
                text: '✓ Leave request submitted successfully.',
                time: _getFormattedTime(),
                responseType: AiResponseType.leaveStatusCard,
                data: res,
                quickActions: ['Show My Leave Balance', 'View All Leave Requests'],
              ));
            });
            _scrollToBottom();
          },
        );

      case AiResponseType.leaveStatusCard:
        return LeaveStatusCardWidget(data: msg.data ?? {});

      case AiResponseType.taskListCard:
        final tasks = (msg.data?['tasks'] as List<dynamic>? ?? []).cast<TaskItem>();
        return TaskListCardWidget(
          tasks: tasks,
          onStatusChange: (taskId, newStatus) {
            _workplaceServices.updateTaskStatus(taskId, newStatus);
            setState(() {});
          },
        );

      case AiResponseType.itClassificationCard:
        return ITClassificationCardWidget(
          onSelectCategory: (cat) => _sendMessage('Report $cat issue'),
        );

      case AiResponseType.itTicketStatusCard:
        final tickets = (msg.data?['tickets'] as List<dynamic>? ?? []).cast<ITTicketItem>();
        return ITTicketStatusCardWidget(tickets: tickets);

      case AiResponseType.payslipCard:
        return PayslipCardWidget(data: msg.data ?? {});

      case AiResponseType.attendanceCard:
        return AttendanceCardWidget(data: msg.data ?? {});

      case AiResponseType.policyCard:
        return PolicyCardWidget(data: msg.data ?? {});

      case AiResponseType.errorCard:
        return ErrorCardWidget(
          title: msg.data?['errorTitle'] as String? ?? 'Error',
          message: msg.data?['errorMessage'] as String? ?? 'Service unavailable.',
          onRetry: () => _sendMessage('Retry policy search'),
        );

      case AiResponseType.text:
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        const CircleAvatar(radius: 10, backgroundImage: AssetImage('assets/images/penguin_ai_assistant.png')),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: const Row(
            children: [
              SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 8),
              Text('Jotun Copilot is analyzing workplace data...', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  // Tab 1: Conversation History View
  Widget _buildHistoryTabView() {
    final history = _workplaceServices.getHistory().where((h) {
      if (_historySearchQuery.isEmpty) return true;
      return h.title.toLowerCase().contains(_historySearchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search past conversation topics...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.borderLight)),
            ),
            onChanged: (val) => setState(() => _historySearchQuery = val),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 1,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.background,
                      child: Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text(item.title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.dateStr} • ${item.lastMessage}', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                    onTap: () {
                      setState(() => _activeTab = 0);
                      _sendMessage(item.title);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Tab 2: Saved Bookmarks View
  Widget _buildSavedTabView() {
    final saved = _workplaceServices.getSavedBookmarks().where((s) {
      if (_savedCategoryFilter != 'All' && s.category != _savedCategoryFilter) return false;
      if (_savedSearchQuery.isNotEmpty && !s.title.toLowerCase().contains(_savedSearchQuery.toLowerCase())) return false;
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search saved policies & answers...',
              prefixIcon: const Icon(Icons.bookmark_border_rounded, color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.borderLight)),
            ),
            onChanged: (val) => setState(() => _savedSearchQuery = val),
          ),
          const SizedBox(height: 10),
          Row(
            children: ['All', 'Policies', 'Answers', 'Documents'].map((cat) {
              final sel = _savedCategoryFilter == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(cat, style: TextStyle(fontSize: 11, color: sel ? Colors.white : AppColors.textSecondary)),
                  selected: sel,
                  selectedColor: AppColors.primary,
                  onSelected: (val) => setState(() => _savedCategoryFilter = cat),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              itemCount: saved.length,
              itemBuilder: (context, index) {
                final item = saved[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 1,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFEFF6FF),
                      child: Icon(Icons.bookmark_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text(item.title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.snippet, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_remove_rounded, color: AppColors.error, size: 18),
                      onPressed: () {
                        setState(() {
                          _workplaceServices.getSavedBookmarks().removeWhere((b) => b.id == item.id);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Input & Navigation Bar Widget
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 16, offset: const Offset(0, -6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Typing Suggestions Overlay
          if (_typingSuggestions.isNotEmpty)
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _typingSuggestions.length,
                separatorBuilder: (context, index) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final sug = _typingSuggestions[index];
                  return ActionChip(
                    label: Text(sug, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    backgroundColor: AppColors.primary.withAlpha(15),
                    onPressed: () => _sendMessage(sug),
                  );
                },
              ),
            ),
          if (_typingSuggestions.isNotEmpty) const SizedBox(height: 8),

          Row(
            children: [
              // Voice Input Microphone Button
              Material(
                color: AppColors.background,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.push('/app/voice-ai-assistant'),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.mic_rounded, color: AppColors.primary, size: 22),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Search Text Field Input
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: TextField(
                    controller: _messageController,
                    focusNode: _inputFocusNode,
                    style: AppTypography.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: 'Ask about leave, tasks, IT, payslip...',
                      hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Send Action Button
              Material(
                color: AppColors.primary,
                shape: const CircleBorder(),
                elevation: 3,
                shadowColor: AppColors.primary.withAlpha(100),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _sendMessage(_messageController.text),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Navigation Tabs: Smart, History, Saved
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavTab(0, Icons.auto_awesome, 'Smart'),
              _buildNavTab(1, Icons.history_rounded, 'History'),
              _buildNavTab(2, Icons.bookmark_border_rounded, 'Saved'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab(int index, IconData icon, String label) {
    final isActive = _activeTab == index;
    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isActive ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
