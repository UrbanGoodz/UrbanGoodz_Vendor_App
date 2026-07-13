import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/reels_controller.dart';
import 'package:urban_goodz_vendor/models/reel_model.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_goodz_vendor/screens/creator_profile_screen.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReelsController c = Get.put(ReelsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reels'),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const CreatorProfileScreen()),
            icon: const Icon(Icons.account_circle),
          ),
          Obx(
            () => Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${c.reels.length} reels',
                  style: const TextStyle(fontSize: 13, color: AppTheme.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.errorMessage.value != null) {
          return _ErrorState(
            message: c.errorMessage.value!,
            retry: c.fetchReels,
          );
        }
        if (c.reels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.videocam,
                  size: 64,
                  color: AppTheme.dark.withOpacity(0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  'No reels yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.dark.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to create your first reel',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.dark.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: c.fetchReels,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: c.reels.length,
            itemBuilder: (_, i) =>
                _ReelCard(reel: c.reels[i], controller: c, index: i),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateReelDialog(context, c),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.dark),
      ),
    );
  }

  void _showCreateReelDialog(BuildContext context, ReelsController c) {
    final descCtrl = TextEditingController();
    final tagsCtrl = TextEditingController();
    XFile? video;
    XFile? thumbnail;
    final picker = ImagePicker();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text(
            'Create Reel',
            style: TextStyle(color: AppTheme.dark),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe your reel',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: tagsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                    hintText: 'Product IDs, e.g. 12, 44',
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.video_file),
                  title: Text(video?.name ?? 'Select reel video'),
                  onTap: () async {
                    final picked = await picker.pickVideo(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) setState(() => video = picked);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(thumbnail?.name ?? 'Select thumbnail'),
                  onTap: () async {
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) setState(() => thumbnail = picked);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final productIds = tagsCtrl.text
                    .split(',')
                    .map((value) => value.trim())
                    .where((value) => int.tryParse(value) != null)
                    .toList();
                if (descCtrl.text.trim().isEmpty ||
                    video == null ||
                    thumbnail == null ||
                    productIds.isEmpty) {
                  Get.snackbar(
                    'Missing information',
                    'Description, video, thumbnail, and at least one numeric product ID are required.',
                  );
                  return;
                }
                final saved = await c.createReel(
                  description: descCtrl.text.trim(),
                  videoPath: video!.path,
                  thumbnailPath: thumbnail!.path,
                  productIds: productIds,
                );
                if (saved) {
                  Get.back();
                  Get.snackbar(
                    'Uploaded',
                    'Reel saved as a draft for moderation.',
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.retry});
  final String message;
  final Future<void> Function() retry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: retry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}

class _ReelCard extends StatelessWidget {
  final ReelModel reel;
  final ReelsController controller;
  final int index;

  const _ReelCard({
    required this.reel,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showReelDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.dark,
          borderRadius: BorderRadius.circular(12),
          image: reel.thumbnailUrl.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(reel.thumbnailUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppTheme.dark.withOpacity(0.85)],
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: reel.isPublished
                          ? Colors.green.withOpacity(0.8)
                          : Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      reel.isPublished ? 'Live' : 'Draft',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => controller.togglePublish(reel.id),
                    child: Icon(
                      reel.isPublished
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                reel.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _StatIcon(
                    icon: Icons.play_arrow,
                    value: _formatCount(reel.views),
                  ),
                  const SizedBox(width: 8),
                  _StatIcon(
                    icon: Icons.favorite,
                    value: _formatCount(reel.likes),
                  ),
                  const SizedBox(width: 8),
                  _StatIcon(
                    icon: Icons.chat,
                    value: _formatCount(reel.comments),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReelDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dark.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              reel.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              reel.description,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.dark.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DetailStat(
                  icon: Icons.play_arrow,
                  label: '${_formatCount(reel.views)} Views',
                ),
                _DetailStat(
                  icon: Icons.favorite,
                  label: '${_formatCount(reel.likes)} Likes',
                ),
                _DetailStat(
                  icon: Icons.chat,
                  label: '${_formatCount(reel.comments)} Comments',
                ),
                _DetailStat(
                  icon: Icons.share,
                  label: '${_formatCount(reel.shares)} Shares',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              children: reel.tags
                  .map(
                    (tag) => Chip(
                      label: Text(
                        '#$tag',
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor: AppTheme.beige.withOpacity(0.3),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.togglePublish(reel.id),
                    icon: Icon(
                      reel.isPublished
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    label: Text(reel.isPublished ? 'Unpublish' : 'Publish'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.deleteReel(reel.id),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}

class _StatIcon extends StatelessWidget {
  final IconData icon;
  final String value;

  const _StatIcon({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 13),
        const SizedBox(width: 2),
        Text(
          value,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}

class _DetailStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.dark.withOpacity(0.7)),
        ),
      ],
    );
  }
}
