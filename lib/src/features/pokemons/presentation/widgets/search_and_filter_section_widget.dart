import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/widgets/advanced_filter_modal_widget.dart';
import 'package:poke_app/src/common/widgets/sort_button_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';

class SearchAndFilterSectionWidget extends StatelessWidget {
  final TextEditingController searchController;
  final PokemonsViewModel pokemonsViewModel;

  const SearchAndFilterSectionWidget({
    super.key,
    required this.searchController,
    required this.pokemonsViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: pokemonsViewModel,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchField(),
              const SizedBox(height: 12),
              _buildFilterButtonsRow(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: pokemonsViewModel.searchPokemon,
        decoration: InputDecoration(
          hintText: 'Pesquisar Pokémon...',
          hintStyle: const TextStyle(
            color: ThemeDesign.textLight,
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search, color: ThemeDesign.textLight),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: ThemeDesign.textLight),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    searchController.clear();
                    pokemonsViewModel.searchPokemon('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButtonsRow(BuildContext context) {
    return Row(
      children: [
        _buildFilterIconButton(
          icon: Icons.tune,
          hasFilter: pokemonsViewModel.selectedTypeFilter != null,
          onPressed: () => _showAdvancedFilterModal(context),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SortButtonWidget(
            label: 'Alfabética (A-Z)',
            isSelected: pokemonsViewModel.currentSort == SortType.alphabetical,
            onPressed: () =>
                pokemonsViewModel.sortPokemon(SortType.alphabetical),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SortButtonWidget(
            label: 'Código (crescente)',
            isSelected: pokemonsViewModel.currentSort == SortType.byNumber,
            onPressed: () => pokemonsViewModel.sortPokemon(SortType.byNumber),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterIconButton({
    required IconData icon,
    required bool hasFilter,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: hasFilter ? ThemeDesign.primaryRed : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: hasFilter ? Colors.white : ThemeDesign.textSecondary,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showAdvancedFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AdvancedFilterModalWidget(
        availableTypes: pokemonsViewModel.availableTypes,
        selectedType: pokemonsViewModel.selectedTypeFilter,
        onTypeSelected: (type) {
          pokemonsViewModel.filterByType(type);
          Navigator.pop(context);
        },
        onClearFilters: () {
          pokemonsViewModel.clearFilters();
          Navigator.pop(context);
        },
      ),
    );
  }
}
