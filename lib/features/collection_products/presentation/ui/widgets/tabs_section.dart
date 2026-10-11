import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/collection_products/presentation/controllers/collection_products/collection_products_cubit.dart';
import 'package:konoz/features/collection_products/presentation/ui/widgets/category_tab_item.dart';
import 'package:konoz/features/collections/presentation/controllers/collections/collections_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class TabsSection extends StatefulWidget {
  const TabsSection({super.key});

  @override
  State<TabsSection> createState() => _TabsSectionState();
}

class _TabsSectionState extends State<TabsSection> {
  final Map<int, GlobalKey> _keys = {};
  int? _lastScrolled;

  GlobalKey _keyFor(int id) => _keys.putIfAbsent(id, GlobalKey.new);

  void _scrollTo(int id) {
    if (_lastScrolled == id) return;
    _lastScrolled = id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _keys[id]?.currentContext;
      if (ctx == null) {
        _lastScrolled = null; // نجرب تاني في الـ build الجاي
        return;
      }
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: colorScheme.onSurface.withValues(alpha: 0.01),
      floating: true,
      snap: true,
      toolbarHeight: 35.h,
      flexibleSpace: FlexibleSpaceBar(
        background: BlocBuilder<CollectionsCubit, CollectionsState>(
          buildWhen: (p, c) => p.collections != c.collections,
          builder: (context, collectionsState) {
            // التاب الأول: All (id = 0)، وبعدها الكولكشنز
            final tabs = <({int id, String name})>[
              (id: 0, name: LocaleKeys.collections_collections_all.tr()),
              for (final c in collectionsState.collections)
                (id: c.id, name: c.name),
            ];

            return BlocBuilder<CollectionProductsCubit, CollectionProductsState>(
              buildWhen: (p, c) =>
                  p.selectedCollectionId != c.selectedCollectionId,
              builder: (context, state) {
                final selectedId = state.selectedCollectionId;
                if (selectedId >= 0) _scrollTo(selectedId);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: paddingHorizontal(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < tabs.length; i++) ...[
                        if (i > 0) 8.horizontalSpace,
                        KeyedSubtree(
                          key: _keyFor(tabs[i].id),
                          child: CategoryChip(
                            label: tabs[i].name,
                            isSelected: tabs[i].id == selectedId,
                            onTap: () => context
                                .read<CollectionProductsCubit>()
                                .selectCollection(tabs[i].id),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}