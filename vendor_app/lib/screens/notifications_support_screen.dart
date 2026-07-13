import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class NotificationsSupportScreen extends StatefulWidget {
  const NotificationsSupportScreen({super.key});
  @override
  State<NotificationsSupportScreen> createState() =>
      _NotificationsSupportScreenState();
}

class _NotificationsSupportScreenState
    extends State<NotificationsSupportScreen> {
  final repository = Get.find<VendorRepository>();
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> conversations = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      notifications = await repository.notifications();
      conversations = await repository.conversations();
      error = null;
    } on VendorApiException catch (exception) {
      error = exception.message;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _message(Map<String, dynamic> conversation) async {
    final id = (conversation['id'] ?? conversation['conversation_id'])
        ?.toString();
    if (id == null) return;
    final text = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Send support message'),
        content: TextField(
          controller: text,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Message'),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (text.text.trim().isEmpty) return;
              await repository.sendMessage(id, text.text.trim());
              Get.back();
              Get.snackbar('Sent', 'Your message was sent.');
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Support'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Notifications'),
            Tab(text: 'Support'),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(error!),
                  ElevatedButton(onPressed: _load, child: const Text('Retry')),
                ],
              ),
            )
          : TabBarView(
              children: [
                RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    children: notifications.isEmpty
                        ? [const ListTile(title: Text('No notifications'))]
                        : notifications
                              .map(
                                (row) => ListTile(
                                  leading: const Icon(Icons.notifications),
                                  title: Text(
                                    row['title']?.toString() ?? 'Update',
                                  ),
                                  subtitle: Text(
                                    row['description']?.toString() ?? '',
                                  ),
                                ),
                              )
                              .toList(),
                  ),
                ),
                ListView(
                  children: conversations.isEmpty
                      ? [
                          const ListTile(
                            title: Text('No support conversations'),
                            subtitle: Text(
                              'A conversation appears after Admin or Support opens one for this Vendor.',
                            ),
                          ),
                        ]
                      : conversations
                            .map(
                              (row) => ListTile(
                                leading: const Icon(Icons.support_agent),
                                title: Text(
                                  row['sender_name']?.toString() ??
                                      row['name']?.toString() ??
                                      'Support',
                                ),
                                subtitle: Text(
                                  row['last_message']?.toString() ?? '',
                                ),
                                onTap: () => _message(row),
                              ),
                            )
                            .toList(),
                ),
              ],
            ),
    ),
  );
}
