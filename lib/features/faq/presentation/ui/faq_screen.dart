import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  // -1 يعني كل الأسئلة مقفولة، أي رقم تاني يبقى ده اللي مفتوح
  int _expandedIndex = -1;

  late final List<_FaqData> _faqs = [
    _FaqData(
      question: LocaleKeys.faq_q1_question.tr(),
      answer: LocaleKeys.faq_q1_answer.tr(),
    ),
    _FaqData(
      question: LocaleKeys.faq_q2_question.tr(),
      answer: LocaleKeys.faq_q2_answer.tr(),
    ),
    _FaqData(
      question: LocaleKeys.faq_q3_question.tr(),
      answer: LocaleKeys.faq_q3_answer.tr(),
    ),
    _FaqData(
      question: LocaleKeys.faq_q4_question.tr(),
      answer: LocaleKeys.faq_q4_answer.tr(),
    ),
    _FaqData(
      question: LocaleKeys.faq_q5_question.tr(),
      answer: LocaleKeys.faq_q5_answer.tr(),
    ),
    _FaqData(
      question: LocaleKeys.faq_q6_question.tr(),
      answer: LocaleKeys.faq_q6_answer.tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: paddingSymmetric(20, 24),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: CustomBackIcon(),
            ),
            Column(
              children: [
                Container(
                  padding: paddingAll(16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.help_outline_rounded),
                ),
                Text(
                  LocaleKeys.faq_header_title.tr(),
                  style: AppTextStyles.text18Bold,
                ),
                8.verticalSpace,
                Text(
                  LocaleKeys.faq_header_subtitle.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text14Regular.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            32.verticalSpace,

            // FAQ list
            ...List.generate(_faqs.length, (index) {
              final isExpanded = _expandedIndex == index;
              return Padding(
                padding: paddingOnly(bottom: 12),
                child: _FaqTile(
                  question: _faqs[index].question,
                  answer: _faqs[index].answer,
                  isExpanded: isExpanded,
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? -1 : index;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FaqData {
  final String question;
  final String answer;

  const _FaqData({required this.question, required this.answer});
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.br16,
        border: Border.all(
          color: isExpanded
              ? colorScheme.primary
              : Colors.grey.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isExpanded ? 0.05 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: AppRadius.br16,
        onTap: onTap,
        child: Padding(
          padding: paddingAll(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(question, style: AppTextStyles.text14Bold),
                  ),
                  12.horizontalSpace,
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isExpanded
                          ? colorScheme.primary
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: isExpanded
                    ? Padding(
                        padding: paddingOnly(top: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            answer,
                            textAlign: TextAlign.right,
                            style: AppTextStyles.text12Regular,
                          ),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
