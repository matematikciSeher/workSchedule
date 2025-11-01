import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/wear_os_models.dart';

/// Wear OS için görev kartı
class WearOsTaskCard extends StatelessWidget {
  final WearOsTask task;
  final bool isCompact;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const WearOsTaskCard({
    super.key,
    required this.task,
    this.isCompact = false,
    this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('d MMM', 'tr_TR');
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

    Color priorityColor = Colors.white;
    if (task.priority != null) {
      switch (task.priority) {
        case 3:
          priorityColor = Colors.red;
          break;
        case 2:
          priorityColor = Colors.orange;
          break;
        case 1:
          priorityColor = Colors.blue;
          break;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isCompact ? 10 : 14),
        decoration: BoxDecoration(
          color: task.isCompleted
              ? Colors.grey.withOpacity(0.2)
              : _getUrgencyColor(task.urgencyLevel).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOverdue
                ? Colors.red
                : task.isCompleted
                    ? Colors.grey
                    : priorityColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: onComplete,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: task.isCompleted ? Colors.green : Colors.white70,
                    width: 2,
                  ),
                  color: task.isCompleted ? Colors.green : Colors.transparent,
                ),
                child: task.isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            
            // Görev bilgisi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      color: task.isCompleted ? Colors.grey : Colors.white,
                      fontSize: isCompact ? 13 : 15,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: isCompact ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isCompact && task.dueDate != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          isOverdue ? Icons.warning : Icons.schedule,
                          color: isOverdue ? Colors.red : Colors.white70,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOverdue
                              ? 'Süresi doldu'
                              : dateFormatter.format(task.dueDate!),
                          style: TextStyle(
                            color: isOverdue ? Colors.red : Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Aciliyet ikonu
            if (task.urgencyLevel == 'urgent' && !task.isCompleted)
              const Icon(
                Icons.priority_high,
                color: Colors.red,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgencyLevel) {
    switch (urgencyLevel) {
      case 'overdue':
        return Colors.red;
      case 'urgent':
        return Colors.red;
      case 'soon':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

