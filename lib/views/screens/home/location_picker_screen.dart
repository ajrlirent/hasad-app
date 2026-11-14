import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One selectable location shown in the location picker.
class LocationOption {
  final String name;
  final String region;

  /// Extra search terms (english / arabic spellings, common typos...).
  final List<String> keywords;

  const LocationOption(this.name, this.region, [this.keywords = const []]);

  String get label => '$name, $region';
}

/// Default value shown before the user picks something.
const String kDefaultLocation = 'Baba Hassen, Alger';

/// Offline list: the 58 Algerian wilayas followed by common cities.
const List<LocationOption> kLocations = [
  // --- Algeria: the 58 wilayas ---
  LocationOption('Baba Hassen', 'Alger', ['baba hassen', 'alger', 'algiers']),
  LocationOption('Adrar', 'Algérie'),
  LocationOption('Chlef', 'Algérie', ['chelef', 'chlef']),
  LocationOption('Laghouat', 'Algérie'),
  LocationOption('Oum El Bouaghi', 'Algérie', ['oum el bouaghi', 'oum bouaghi']),
  LocationOption('Batna', 'Algérie'),
  LocationOption('Béjaïa', 'Algérie', ['bejaia', 'bougie']),
  LocationOption('Biskra', 'Algérie'),
  LocationOption('Béchar', 'Algérie', ['bechar']),
  LocationOption('Blida', 'Algérie'),
  LocationOption('Bouira', 'Algérie'),
  LocationOption('Tamanrasset', 'Algérie', ['tamanrasset', 'tamanghasset']),
  LocationOption('Tébessa', 'Algérie', ['tebessa']),
  LocationOption('Tlemcen', 'Algérie'),
  LocationOption('Tiaret', 'Algérie'),
  LocationOption('Tizi Ouzou', 'Algérie', ['tiziouzou', 'tizi ouzou']),
  LocationOption('Alger', 'Algérie', ['alger', 'algiers', 'algérois']),
  LocationOption('Djelfa', 'Algérie'),
  LocationOption('Jijel', 'Algérie'),
  LocationOption('Sétif', 'Algérie', ['setif']),
  LocationOption('Saïda', 'Algérie', ['saida']),
  LocationOption('Skikda', 'Algérie'),
  LocationOption('Sidi Bel Abbès', 'Algérie', ['sidi bel abbes']),
  LocationOption('Annaba', 'Algérie', ['bone']),
  LocationOption('Guelma', 'Algérie'),
  LocationOption('Constantine', 'Algérie', ['qacentina']),
  LocationOption('Médéa', 'Algérie', ['medea']),
  LocationOption('Mostaganem', 'Algérie'),
  LocationOption("M'Sila", 'Algérie', ['msila', 'm sila']),
  LocationOption('Mascara', 'Algérie'),
  LocationOption('Ouargla', 'Algérie', ['wargla']),
  LocationOption('Oran', 'Algérie', ['wahran']),
  LocationOption('El Bayadh', 'Algérie', ['elbayadh']),
  LocationOption('Illizi', 'Algérie'),
  LocationOption('Bordj Bou Arréridj', 'Algérie', ['bordj bou arreridj', 'bba']),
  LocationOption('Boumerdès', 'Algérie', ['boumerdes']),
  LocationOption('El Tarf', 'Algérie', ['eltarf']),
  LocationOption('Tindouf', 'Algérie'),
  LocationOption('Tissemsilt', 'Algérie'),
  LocationOption('El Oued', 'Algérie', ['eloued', 'oued souf']),
  LocationOption('Khenchela', 'Algérie'),
  LocationOption('Souk Ahras', 'Algérie', ['soukahras']),
  LocationOption('Tipaza', 'Algérie', ['tipasa']),
  LocationOption('Mila', 'Algérie'),
  LocationOption('Aïn Defla', 'Algérie', ['ain defla']),
  LocationOption('Naâma', 'Algérie', ['naama']),
  LocationOption('Aïn Témouchent', 'Algérie', ['ain temouchent']),
  LocationOption('Ghardaïa', 'Algérie', ['ghardaia']),
  LocationOption('Relizane', 'Algérie', ['ghilizane']),
  LocationOption('Timimoun', 'Algérie'),
  LocationOption('Bordj Badji Mokhtar', 'Algérie', ['bordj badji mokhtar']),
  LocationOption('Ouled Djellal', 'Algérie', ['ouled djellal']),
  LocationOption('Béni Abbès', 'Algérie', ['beni abbes']),
  LocationOption('In Salah', 'Algérie', ['in salah', 'ainsalah']),
  LocationOption('In Guezzam', 'Algérie', ['in guezzam']),
  LocationOption('Touggourt', 'Algérie'),
  LocationOption('Djanet', 'Algérie'),
  LocationOption("El M'Ghair", 'Algérie', ['el mghair']),
  LocationOption('El Meniaa', 'Algérie', ['el menia']),

  // --- Other cities (searchable) ---
  LocationOption('Tunis', 'Tunisie', ['tunis', 'tunisia']),
  LocationOption('Sfax', 'Tunisie'),
  LocationOption('Sousse', 'Tunisie', ['soussa']),
  LocationOption('Tripoli', 'Libye', ['tarabulus']),
  LocationOption('Benghazi', 'Libye'),
  LocationOption('Casablanca', 'Maroc', ['casa', 'dar el beida']),
  LocationOption('Rabat', 'Maroc'),
  LocationOption('Marrakech', 'Maroc', ['marrakesh']),
  LocationOption('Le Caire', 'Égypte',
      ['cairo', 'le caire', 'caire', 'al qahira', 'القاهرة']),
  LocationOption('Alexandrie', 'Égypte', ['alexandria']),
  LocationOption('Djeddah', 'Arabie Saoudite', ['jeddah', 'jiddah']),
  LocationOption('Riyad', 'Arabie Saoudite', ['riyadh']),
  LocationOption('Dubaï', 'Émirats arabes unis', ['dubai', 'dubayy']),
  LocationOption('Abou Dabi', 'Émirats arabes unis', ['abu dhabi']),
  LocationOption('Doha', 'Qatar'),
  LocationOption('Istanbul', 'Turquie', ['istanbul', 'constantinople']),
  LocationOption('Ankara', 'Turquie'),
  LocationOption('Paris', 'France'),
  LocationOption('Marseille', 'France'),
  LocationOption('Lyon', 'France'),
  LocationOption('Toulouse', 'France'),
  LocationOption('Madrid', 'Espagne'),
  LocationOption('Barcelone', 'Espagne', ['barcelona']),
  LocationOption('Rome', 'Italie', ['roma']),
  LocationOption('Milan', 'Italie', ['milano']),
  LocationOption('Londres', 'Royaume-Uni', ['london']),
  LocationOption('Berlin', 'Allemagne'),
  LocationOption('Bruxelles', 'Belgique', ['brussels']),
  LocationOption('Genève', 'Suisse', ['geneva']),
  LocationOption('Montréal', 'Canada', ['montreal']),
  LocationOption('New York', 'États-Unis', ['new york', 'nyc']),
  LocationOption('Pékin', 'Chine', ['beijing', 'pekin']),
];

/// Lowercase + strip accents so "Béjaïa" is found by typing "bejaia".
String foldForSearch(String value) {
  const from = 'àáâãäåçèéêëìíîïñòóôõöùúûüýÿœæ';
  const to = 'aaaaaaceeeeiiiinooooouuuuyyoa';
  final buffer = StringBuffer();
  for (final rune in value.toLowerCase().runes) {
    final ch = String.fromCharCode(rune);
    final index = from.indexOf(ch);
    buffer.write(index >= 0 ? to[index] : ch);
  }
  return buffer.toString();
}

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationOption> _results = kLocations;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final needle = foldForSearch(query.trim());
    setState(() {
      _results = needle.isEmpty
          ? kLocations
          : kLocations
              .where((option) =>
                  foldForSearch(option.name).contains(needle) ||
                  foldForSearch(option.region).contains(needle) ||
                  option.keywords
                      .any((keyword) => foldForSearch(keyword).contains(needle)))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma localisation'),
        backgroundColor: Colors.white,
        foregroundColor: AppColor.secondaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Rechercher une ville ou une wilaya',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text('Aucun résultat'))
                : ListView.separated(
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final option = _results[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined,
                            color: AppColor.backgroundColor),
                        title: Text(
                          option.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => Get.back(result: option.label),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
