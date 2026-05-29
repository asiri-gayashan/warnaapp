import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';

class StudentSearchDialog extends StatefulWidget {
  final Future<Map<String, dynamic>?> Function(String email) onSearch;
  final Function(Map<String, dynamic> student) onStudentSelected;

  const StudentSearchDialog({
    super.key,
    required this.onSearch,
    required this.onStudentSelected,
  });

  @override
  State<StudentSearchDialog> createState() =>
      _StudentSearchDialogState();
}

class _StudentSearchDialogState
    extends State<StudentSearchDialog> {

  final TextEditingController emailController =
      TextEditingController();

  bool isSearching = false;

  Map<String, dynamic>? searchResult;

  String? errorMessage;

  Future<void> searchStudent() async {

    final email = emailController.text.trim();

    if (email.isEmpty) {

      setState(() {
        errorMessage = "Please enter student email";
      });

      return;
    }

    setState(() {
      isSearching = true;
      errorMessage = null;
      searchResult = null;
    });

    final result = await widget.onSearch(email);

    setState(() {

      isSearching = false;

      if (result != null &&
          result['status'] == true) {

        searchResult = result['data'];

      } else {

        errorMessage =
            result?['message'] ??
            "Student not found";
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              /// HEADER
              Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: AppColors.primary
                          .withOpacity(0.1),

                      borderRadius:
                          BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.person_search,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      "Search Student",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () =>
                        Navigator.pop(context),

                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// EMAIL FIELD
              TextField(
                controller: emailController,

                decoration: InputDecoration(
                  hintText: "Enter student email",

                  prefixIcon: const Icon(
                    Icons.email_outlined,
                  ),

                  filled: true,

                  fillColor: AppColors
                      .textSecondary
                      .withOpacity(0.05),

                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// SEARCH BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed:
                      isSearching
                          ? null
                          : searchStudent,

                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                        AppColors.primary,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),

                  child:
                      isSearching
                          ? const SizedBox(
                            width: 22,
                            height: 22,

                            child:
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                          )
                          : const Text(
                            "Search Student",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),

              /// ERROR MESSAGE
              if (errorMessage != null) ...[

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: AppColors.error
                        .withOpacity(0.08),

                    borderRadius:
                        BorderRadius.circular(14),
                  ),

                  child: Text(
                    errorMessage!,

                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],

              /// RESULT CARD
              if (searchResult != null) ...[

                const SizedBox(height: 22),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withOpacity(0.06),

                    borderRadius:
                        BorderRadius.circular(18),

                    border: Border.all(
                      color: AppColors.primary
                          .withOpacity(0.2),
                    ),
                  ),

                  child: Column(
                    children: [

                      CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            AppColors.success,

                        child: Text(
                          (searchResult?['users']
                                      ['full_name'] ??
                                  "S")[0]
                              .toUpperCase(),

                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        searchResult?['users']
                                ['full_name'] ??
                            "N/A",

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        searchResult?['users']
                                ['email'] ??
                            "",

                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),

                      Text(
                        searchResult?['users']
                                ['phone'] ??
                            "",

                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {

                            widget.onStudentSelected(
                              searchResult!,
                            );

                            Navigator.pop(context);
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.success,

                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),

                          child: const Text(
                            "Add Student",

                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}