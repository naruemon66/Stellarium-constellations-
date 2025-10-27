import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/star_provider.dart';
import '../widgets/star_card.dart';
import '../screens/star_add_edit_screen.dart';
import '../constants.dart';

class StarListScreen extends StatefulWidget {
  static const routeName = '/';
  const StarListScreen({Key? key}) : super(key: key);

  @override
  State<StarListScreen> createState() => _StarListScreenState();
}

class _StarListScreenState extends State<StarListScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStars();
  }

  Future<void> _loadStars() async {
    try {
      await context.read<StarProvider>().fetchAndSetStars();
    } catch (e) {
      debugPrint('Error loading stars: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final starProvider = context.watch<StarProvider>();
    final stars = starProvider.stars;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          'Constella — กลุ่มดาวของฉัน',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: gradientAppBar),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : stars.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีดาว ลองเพิ่มดูหน่อย 🌠',
                style: TextStyle(color: Colors.white60, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: stars.length,
              itemBuilder: (ctx, i) {
                final s = stars[i];
                return StarCard(
                  star: s,
                  onEdit: () => Navigator.of(context)
                      .pushNamed(StarAddEditScreen.routeName, arguments: s)
                      .then((_) => _loadStars()), // ✅ โหลดใหม่หลังแก้ไข
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: kCardBackground,
                        title: const Text(
                          'ลบดาว?',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          'ต้องการลบ ${s.name} หรือไม่',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('ยกเลิก'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await context.read<StarProvider>().deleteStar(
                                s.id!,
                              );
                              Navigator.of(ctx).pop();
                            },
                            child: const Text(
                              'ลบ',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).pushNamed(StarAddEditScreen.routeName);
          await _loadStars(); // ✅ โหลดใหม่หลังเพิ่ม
        },
        backgroundColor: kPrimaryPurple,
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มดาว'),
      ),
    );
  }
}
