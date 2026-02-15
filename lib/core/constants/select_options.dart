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

//------------------------------------------------------------------------Provinces
  static const List<String> provinces = [
    "Western Province",
    "Central Province",
    "Southern Province",
    "Northern Province",
    "Eastern Province",
    "North Western Province",
    "North Central Province",
    "Uva Province",
    "Sabaragamuwa Province",
  ];


  // ------------------------------------------------------------------Subject Options
  static const List<String> subjects = [

    // Primary (Grade 1–5)
    "First Language (Sinhala/Tamil)",
    "Second Language (Tamil/Sinhala)",
    "English",
    "Mathematics",
    "Environmental Studies",
    "Religion",
    "Art",
    "Music",
    "Dancing",
    "Physical Education",

    // Grade 6–9
    "Science",
    "History",
    "Geography",
    "Civics Education",
    "Health & Physical Education",
    "Practical & Technical Skills",
    "Information & Communication Technology (ICT)",

    // O/L Subjects (Grade 10–11)
    "Business & Accounting Studies",
    "Design & Technology",
    "Drama & Theatre",
    "Media Studies",
    "Agriculture",
    "Entrepreneurship Studies",

    // A/L - Science Stream
    "Combined Mathematics",
    "Physics",
    "Chemistry",
    "Biology",
    "Agricultural Science",

    // A/L - Commerce Stream
    "Accounting",
    "Business Studies",
    "Economics",

    // A/L - Arts Stream
    "Political Science",
    "Logic & Scientific Method",
    "Geography (Advanced Level)",
    "History (Advanced Level)",
    "Sinhala (Advanced Level)",
    "Tamil (Advanced Level)",
    "English Literature",
    "Buddhist Civilization",
    "Hindu Civilization",
    "Christian Civilization",
    "Islamic Civilization",

    // A/L - Technology Stream
    "Engineering Technology",
    "Bio Systems Technology",
    "Science for Technology",
    "Information & Communication Technology (Advanced Level)",
  ];



  // ------------------------------------------------------------------ YEars of experience

  static const List<String> yearsOfExperience = [
    "0-1 Years",
    "2-3 Years",
    "4-5 Years",
    "6-10 Years",
    "11-15 Years",
    "16-20 Years",
    "21-25 Years",
    "26-30 Years",
    "30+ Years",
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