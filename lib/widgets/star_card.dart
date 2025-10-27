import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/star.dart';
import '../constants.dart';

class StarCard extends StatelessWidget {
  final Star star;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StarCard({
    Key? key,
    required this.star,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMMMd().format(star.date);

    String getInitials(String name) {
      if (name.isEmpty) return '★';
      final parts = name.trim().split(' ');
      String letters = parts.first.substring(
        0,
        parts.first.length >= 2 ? 2 : 1,
      );
      return letters.toUpperCase();
    }

    return Card(
      color: kCardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      kPrimaryPurple.withOpacity(0.8),
                      kAccentBlue.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryPurple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    getInitials(star.name),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      star.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // 🔹 เปลี่ยนตรงนี้
                    Text(
                      'Brightness: ${star.brightness.toStringAsFixed(1)}    จำนวนดาวที่มองเห็น: ${star.size.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Distance: ${star.distance.toStringAsFixed(1)} ly',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateStr,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: onEdit,
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.lightBlueAccent,
                              ),
                              iconSize: 18,
                            ),
                            IconButton(
                              onPressed: onDelete,
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              iconSize: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
