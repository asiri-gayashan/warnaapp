import 'package:flutter/material.dart';
import '../../shared/widgets/custom_select.dart';

class SelectOptions {
  // Grade/Level Options
  static List<SelectOption> grades = [
    const SelectOption(value: 'grade1', label: 'Grade 1', icon: Icons.looks_one),
    const SelectOption(value: 'grade2', label: 'Grade 2', icon: Icons.looks_two),
    const SelectOption(value: 'grade3', label: 'Grade 3', icon: Icons.looks_3),
    const SelectOption(value: 'grade4', label: 'Grade 4', icon: Icons.looks_4),
    const SelectOption(value: 'grade5', label: 'Grade 5', icon: Icons.looks_5),
    const SelectOption(value: 'grade6', label: 'Grade 6', icon: Icons.looks_6),
    const SelectOption(value: 'grade7', label: 'Grade 7', icon: Icons.filter_7),
    const SelectOption(value: 'grade8', label: 'Grade 8', icon: Icons.filter_8),
    const SelectOption(value: 'grade9', label: 'Grade 9', icon: Icons.filter_9),
    const SelectOption(value: 'grade10', label: 'Grade 10', icon: Icons.filter_9_plus),
    const SelectOption(value: 'grade11', label: 'Grade 11', icon: Icons.plus_one),
    const SelectOption(value: 'grade12', label: 'Grade 12', icon: Icons.plus_one),
    const SelectOption(value: 'grade13', label: 'Grade 13', icon: Icons.plus_one),
  ];


  // Grade/Level Options
  static List<SelectOption> provinces = [
    const SelectOption(value: 'sabaragamuwa', label: 'Sabaragamuwa'),
    const SelectOption(value: 'grade1', label: 'Grade 1'),
    const SelectOption(value: 'grade1', label: 'Grade 1'),
  ];

  // Subject Options
  static List<SelectOption> subjects = [
    const SelectOption(
      value: 'math',
      label: 'Mathematics',
      icon: Icons.calculate,
      searchKeywords: ['math', 'maths', 'calculus', 'algebra', 'geometry'],
    ),
    const SelectOption(
      value: 'science',
      label: 'Science',
      icon: Icons.science,
      searchKeywords: ['science', 'physics', 'chemistry', 'biology'],
    ),
    const SelectOption(
      value: 'english',
      label: 'English',
      icon: Icons.menu_book,
      searchKeywords: ['english', 'grammar', 'literature'],
    ),
    const SelectOption(
      value: 'physics',
      label: 'Physics',
      icon: Icons.bolt,
      searchKeywords: ['physics', 'mechanics', 'optics'],
    ),
    const SelectOption(
      value: 'chemistry',
      label: 'Chemistry',
      icon: Icons.science,
      searchKeywords: ['chemistry', 'organic', 'inorganic'],
    ),
    const SelectOption(
      value: 'biology',
      label: 'Biology',
      icon: Icons.eco,
      searchKeywords: ['biology', 'botany', 'zoology'],
    ),
    const SelectOption(
      value: 'history',
      label: 'History',
      icon: Icons.history,
      searchKeywords: ['history', 'world history', 'indian history'],
    ),
    const SelectOption(
      value: 'geography',
      label: 'Geography',
      icon: Icons.public,
      searchKeywords: ['geography', 'maps', 'earth'],
    ),
    const SelectOption(
      value: 'computer',
      label: 'Computer Science',
      icon: Icons.computer,
      searchKeywords: ['computer', 'programming', 'coding'],
    ),
    const SelectOption(
      value: 'art',
      label: 'Art & Drawing',
      icon: Icons.palette,
      searchKeywords: ['art', 'drawing', 'painting'],
    ),
    const SelectOption(
      value: 'music',
      label: 'Music',
      icon: Icons.music_note,
      searchKeywords: ['music', 'singing', 'instruments'],
    ),
    const SelectOption(
      value: 'physical',
      label: 'Physical Education',
      icon: Icons.sports,
      searchKeywords: ['pe', 'physical', 'sports'],
    ),
  ];

  // Institute Type Options
  static List<SelectOption> instituteTypes = [
    const SelectOption(value: 'school', label: 'School', icon: Icons.school),
    const SelectOption(value: 'tuition', label: 'Tuition Center', icon: Icons.groups),
    const SelectOption(value: 'academy', label: 'Academy', icon: Icons.account_balance),
    const SelectOption(value: 'college', label: 'College', icon: Icons.cast_for_education),
    const SelectOption(value: 'university', label: 'University', icon: Icons.account_balance),
  ];

  // Teaching Type Options
  static List<SelectOption> teachingTypes = [
    const SelectOption(value: 'independent', label: 'Independent Teacher', icon: Icons.person),
    const SelectOption(value: 'institute', label: 'Works under Institute', icon: Icons.business),
  ];

  // Years of Experience
  static List<SelectOption> experienceYears = [
    const SelectOption(value: '0', label: 'Fresh Graduate'),
    const SelectOption(value: '1', label: '1 year'),
    const SelectOption(value: '2', label: '2 years'),
    const SelectOption(value: '3', label: '3 years'),
    const SelectOption(value: '4', label: '4 years'),
    const SelectOption(value: '5', label: '5 years'),
    const SelectOption(value: '5+', label: '5+ years'),
    const SelectOption(value: '10+', label: '10+ years'),
    const SelectOption(value: '15+', label: '15+ years'),
  ];
}