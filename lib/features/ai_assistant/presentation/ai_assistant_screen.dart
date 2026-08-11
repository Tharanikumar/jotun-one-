import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/ai_intent_orchestrator.dart';
import 'widgets/ai_capabilities_sheet.dart';
import 'widgets/ai_drawer_navigation.dart';
import 'widgets/ai_response_card.dart';
import 'widgets/voice_input_sheet.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIIntentOrchestrator _orchestrator = AIIntentOrchestrator();

  int _activeTab = 0; // 0: Smart, 1: History, 2: Saved
  bool _isTyping = false;
  String _activeSavedFilter = 'All';
  String _historySearchQuery = '';

  final List<AIChatMessage> _messages = [];

  final List<Map<String, dynamic>> _quickQuestions = [
    {
      'title': 'How can I apply for leave?',
      'icon': Icons.calendar_month_rounded,
      'color': const Color(0xFF2563EB),
      'bgColor': const Color(0xFFEFF6FF),
    },
    {
      'title': 'What tasks are assigned to me?',
      'icon': Icons.check_box_rounded,
      'color': const Color(0xFFF59E0B),
      'bgColor': const Color(0xFFFFF7ED),
    },
    {
      'title': 'My IT ticket is not working',
      'icon': Icons.headset_mic_rounded,
      'color': const Color(0xFF8B5CF6),
      'bgColor': const Color(0xFFF5F3FF),
    },
    {
      'title': 'Show my latest payslip',
      'icon': Icons.receipt_long_rounded,
      'color': const Color(0xFF10B981),
      'bgColor': const Color(0xFFECFDF5),
    },
    {
      'title': 'What is the work from home policy?',
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFF06B6D4),
      'bgColor': const Color(0xFFECFEFF),
    },
  ];

  final List<Map<String, dynamic>> _historyItems = [
    {
      'group': 'Today',
      'title': 'Leave application request for Casual Leave',
      'time': '10:14 AM',
      'preview': 'Leave request submitted (LV-2026-00124)',
    },
    {
      'group': 'Today',
      'title': 'IT support ticket tracking',
      'time': '08:45 AM',
      'preview': 'Ticket #IT-1024 status updated to In Progress',
    },
    {
      'group': 'Yesterday',
      'title': 'Payslip query for July 2026',
      'time': 'Yesterday, 04:30 PM',
      'preview': 'Net Salary: ₹85,450 breakdown retrieved',
    },
    {
      'group': 'Yesterday',
      'title': 'Attendance check-in status',
      'time': 'Yesterday, 09:05 AM',
      'preview': 'Today check-in 09:02 AM logged',
    },
    {
      'group': 'Older',
      'title': 'Overtime policy clarification',
      'time': '08 Aug 2026',
      'preview': 'Plant Operations Policy 4.2 details shown',
    },
  ];

  final List<Map<String, dynamic>> _savedItems = [
    {
      'title': 'Annual & Casual Leave Policy',
      'category': 'Policies',
      'date': 'Saved 10 Aug',
      'icon': Icons.article_rounded,
      'color': Color(0xFF2563EB),
    },
    {
      'title': 'July 2026 Payslip Summary',
      'category': 'Answers',
      'date': 'Saved 07 Aug',
      'icon': Icons.receipt_long_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'EHS Plant Safety Manual 2026',
      'category': 'Documents',
      'date': 'Saved 05 Aug',
      'icon': Icons.shield_rounded,
      'color': Color(0xFFF59E0B),
    },
  ];

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final userMsg = AIChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      isUser: true,
      text: text,
      time: timeStr,
    );

    setState(() {
      _messages.add(userMsg);
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Process query via intent orchestrator
    final botResponse = await _orchestrator.processMessage(text);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(botResponse);
      });
      _scrollToBottom();
    }
  }

  void _submitLeaveForm(Map<String, dynamic> formData) {
    final response = _orchestrator.submitLeaveRequest(formData);
    setState(() {
      _messages.add(response);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _openCapabilitiesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AICapabilitiesSheet(
        onSelectCapability: (query) => _sendMessage(query),
      ),
    );
  }

  void _openVoiceInputSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoiceInputSheet(
        onSendVoiceText: (transcribedText) => _sendMessage(transcribedText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AIDrawerNavigation(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            shadowColor: Colors.black12,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: const Icon(Icons.menu_rounded, color: Color(0xFF1E293B), size: 20),
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
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/penguin_ai_assistant.png'),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'AI Assistant',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: Colors.black12,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _openCapabilitiesSheet,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF7C3AED),
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 3, child: _buildMainBody()),
                  Container(width: 1, color: const Color(0xFFE2E8F0)),
                  Expanded(flex: 2, child: _buildRightContextPanel()),
                ],
              )
            : _buildMainBody(),
      ),
    );
  }

  Widget _buildMainBody() {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _activeTab,
            children: [
              _buildSmartTabContent(),
              _buildHistoryTabContent(),
              _buildSavedTabContent(),
            ],
          ),
        ),

        // Bottom Input & Nav Bar
        _buildBottomInputArea(),
      ],
    );
  }

  Widget _buildSmartTabContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero 3D Penguin Mascot
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
                        const Color(0xFF3B82F6).withAlpha(45),
                        const Color(0xFF60A5FA).withAlpha(10),
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

          // 2. Premium Contextual Greeting Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF1D4ED8),
                  Color(0xFF1E40AF),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withAlpha(90),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
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
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(70),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/penguin_ai_assistant.png'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hi Tharani 👋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "I'm your Jotun One AI Workplace Assistant. How can I help you today?",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.5,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Contextual Status Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatusPill('⚡ 3 tasks due this week', () => _sendMessage('What tasks do I have today?')),
                      const SizedBox(width: 8),
                      _buildStatusPill('📅 Leave balance updated', () => _sendMessage('How many leaves do I have?')),
                      const SizedBox(width: 8),
                      _buildStatusPill('💻 IT Ticket #1024 updated', () => _sendMessage('Track IT Ticket #IT-1024')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Render active chat messages
          if (_messages.isNotEmpty) ...[
            ..._messages.map((msg) => _buildChatMessageBubble(msg)),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          ),
                          SizedBox(width: 8),
                          Text('Jotun AI is processing query...', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],

          // 3. Intelligent Quick Questions Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Questions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              InkWell(
                onTap: _openCapabilitiesSheet,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF2563EB)),
                    ],
                  ),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () => _sendMessage(q['title'] as String),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: q['bgColor'] as Color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              q['icon'] as IconData,
                              color: q['color'] as Color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              q['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
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

  Widget _buildStatusPill(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(70)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildChatMessageBubble(AIChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: msg.isUser ? const Color(0xFF2563EB) : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomRight: msg.isUser ? const Radius.circular(4) : const Radius.circular(20),
                  bottomLeft: msg.isUser ? const Radius.circular(20) : const Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isUser ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    msg.time,
                    style: TextStyle(
                      color: msg.isUser ? Colors.white70 : const Color(0xFF94A3B8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Render Rich Card if applicable
          if (!msg.isUser && msg.cardType != AICardType.normalText)
            AIResponseCardRenderer(
              message: msg,
              onActionSelected: (action) => _sendMessage(action),
              onSubmitLeave: (formData) => _submitLeaveForm(formData),
            ),

          // Contextual Action Buttons
          if (!msg.isUser && msg.suggestedActions != null && msg.suggestedActions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                children: msg.suggestedActions!.map((act) {
                  return ActionChip(
                    label: Text(act, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    backgroundColor: const Color(0xFFEFF6FF),
                    side: const BorderSide(color: Color(0xFFBFDBFE)),
                    onPressed: () => _sendMessage(act),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryTabContent() {
    final filteredHistory = _historyItems.where((item) {
      if (_historySearchQuery.isEmpty) return true;
      return (item['title'] as String).toLowerCase().contains(_historySearchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Conversation History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          TextField(
            onChanged: (val) => setState(() => _historySearchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF94A3B8)),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                final item = filteredHistory[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
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
                          Text(item['group'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          Text(item['time'] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(item['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      Text(item['preview'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() => _activeTab = 0);
                              _sendMessage(item['title'] as String);
                            },
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                            label: const Text('Open', style: TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.bookmark_border_rounded, size: 18, color: Color(0xFF64748B)),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _historyItems.removeAt(index)),
                            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedTabContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Saved Items & Answers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Policies', 'Answers', 'Documents'].map((filter) {
                final selected = _activeSavedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: selected ? Colors.white : AppColors.primary),
                    onSelected: (val) {
                      if (val) setState(() => _activeSavedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _savedItems.length,
              itemBuilder: (context, index) {
                final item = _savedItems[index];
                if (_activeSavedFilter != 'All' && item['category'] != _activeSavedFilter) {
                  return const SizedBox.shrink();
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withAlpha(20),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                            const SizedBox(height: 4),
                            Text('${item['category']} • ${item['date']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      const Icon(Icons.bookmark_rounded, color: AppColors.primary, size: 22),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightContextPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Workplace Context', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Today\'s Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary)),
                SizedBox(height: 8),
                Text('• 3 Assigned Tasks Due Today', style: TextStyle(fontSize: 12, color: Color(0xFF1E293B))),
                SizedBox(height: 4),
                Text('• 8 Days Casual Leave Available', style: TextStyle(fontSize: 12, color: Color(0xFF1E293B))),
                SizedBox(height: 4),
                Text('• Check-in at 09:02 AM logged', style: TextStyle(fontSize: 12, color: Color(0xFF1E293B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputArea() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Mic Action Button
              Material(
                color: const Color(0xFFF1F5F9),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _openVoiceInputSheet,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.mic_rounded,
                      color: Color(0xFF2563EB),
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Text Field Input
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                    decoration: const InputDecoration(
                      hintText: 'Ask about leave, tasks, IT, payslip...',
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Send Button
              Material(
                color: const Color(0xFF2563EB),
                shape: const CircleBorder(),
                elevation: 3,
                shadowColor: const Color(0xFF2563EB).withAlpha(90),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _sendMessage(_messageController.text),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Bottom Nav Tabs: Smart, History, Saved
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
            Icon(
              icon,
              size: 18,
              color: isActive ? const Color(0xFF2563EB) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
