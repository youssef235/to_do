import 'package:flutter/material.dart';

class TaskFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const TaskFilterChips({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Inprogress', 'Waiting', 'Finished'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters
              .map(
                (filter) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    color: selectedFilter == filter ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                selected: selectedFilter == filter,
                onSelected: (_) => onFilterSelected(filter),
                selectedColor: Colors.deepPurple,
                backgroundColor: Colors.purple.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                side: BorderSide.none,
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}