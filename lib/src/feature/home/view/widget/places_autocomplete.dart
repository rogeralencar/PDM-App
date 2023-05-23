// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

@immutable
class Places {
  const Places({
    required this.location,
    required this.name,
  });

  final String location;
  final String name;

  @override
  String toString() {
    return '$name, $location';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Places && other.name == name && other.location == location;
  }

  @override
  int get hashCode => Object.hash(location, name);
}

class AutocompletePlaces extends StatelessWidget {
  final List<String> user_interests;

  const AutocompletePlaces({super.key, required this.user_interests});

  static const List<Places> _userOptions = <Places>[
    Places(name: 'São Paulo, SP', location: 'São Paulo'),
    Places(name: 'Rio de Janeiro, RJ', location: 'Rio de Janeiro'),
    Places(name: 'Brasília, DF', location: 'Distrito Federal'),
    Places(name: 'Salvador, BA', location: 'Bahia'),
    Places(name: 'Fortaleza, CE', location: 'Ceará'),
    Places(name: 'Belo Horizonte, MG', location: 'Minas Gerais'),
    Places(name: 'Manaus, AM', location: 'Amazonas'),
    Places(name: 'Curitiba, PR', location: 'Paraná'),
    Places(name: 'Recife, PE', location: 'Pernambuco'),
    Places(name: 'Porto Alegre, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Belém, PA', location: 'Pará'),
    Places(name: 'Goiânia, GO', location: 'Goiás'),
    Places(name: 'Guarulhos, SP', location: 'São Paulo'),
    Places(name: 'Campinas, SP', location: 'São Paulo'),
    Places(name: 'São Luís, MA', location: 'Maranhão'),
    Places(name: 'São Gonçalo, RJ', location: 'Rio de Janeiro'),
    Places(name: 'Maceió, AL', location: 'Alagoas'),
    Places(name: 'Duque de Caxias, RJ', location: 'Rio de Janeiro'),
    Places(name: 'Natal, RN', location: 'Rio Grande do Norte'),
    Places(name: 'Teresina, PI', location: 'Piauí'),
    Places(name: 'Campo Grande, MS', location: 'Mato Grosso do Sul'),
    Places(name: 'Osasco, SP', location: 'São Paulo'),
    Places(name: 'Santo André, SP', location: 'São Paulo'),
    Places(name: 'João Pessoa, PB', location: 'Paraíba'),
    Places(name: 'Jaboatão dos Guararapes, PE', location: 'Pernambuco'),
    Places(name: 'Contagem, MG', location: 'Minas Gerais'),
    Places(name: 'São José dos Campos, SP', location: 'São Paulo'),
    Places(name: 'Uberlândia, MG', location: 'Minas Gerais'),
    Places(name: 'Feira de Santana, BA', location: 'Bahia'),
    Places(name: 'Ribeirão Preto, SP', location: 'São Paulo'),
    Places(name: 'Sorocaba, SP', location: 'São Paulo'),
    Places(name: 'Cuiabá, MT', location: 'Mato Grosso'),
    Places(name: 'Aparecida de Goiânia, GO', location: 'Goiás'),
    Places(name: 'Aracaju, SE', location: 'Sergipe'),
    Places(name: 'Londrina, PR', location: 'Paraná'),
    Places(name: 'Juiz de Fora, MG', location: 'Minas Gerais'),
    Places(name: 'Joinville, SC', location: 'Santa Catarina'),
    Places(name: 'Niterói, RJ', location: 'Rio de Janeiro'),
    Places(name: 'Ananindeua, PA', location: 'Pará'),
    Places(name: 'Belford Roxo, RJ', location: 'Rio de Janeiro'),
    Places(name: 'Ponta Grossa, PR', location: 'Paraná'),
    Places(name: 'Barra Mansa, RJ', location: 'Rio de Janeiro'),
    Places(name: 'Rio Grande, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Catanduva, SP', location: 'São Paulo'),
    Places(name: 'São João de Meriti, RJ', location: 'Rio de Janeiro'),
    Places(name: 'Ferraz de Vasconcelos, SP', location: 'São Paulo'),
    Places(name: 'Jacareí, SP', location: 'São Paulo'),
    Places(name: 'São Carlos, SP', location: 'São Paulo'),
    Places(name: 'Cabo de Santo Agostinho, PE', location: 'Pernambuco'),
    Places(name: 'Varginha, MG', location: 'Minas Gerais'),
    Places(name: 'Abaetetuba, PA', location: 'Pará'),
    Places(name: 'São José, SC', location: 'Santa Catarina'),
    Places(name: 'Paragominas, PA', location: 'Pará'),
    Places(name: 'Itapecerica da Serra, SP', location: 'São Paulo'),
    Places(name: 'Guarapari, ES', location: 'Espírito Santo'),
    Places(name: 'Bragança Paulista, SP', location: 'São Paulo'),
    Places(name: 'Mauá, SP', location: 'São Paulo'),
    Places(name: 'Birigui, SP', location: 'São Paulo'),
    Places(name: 'Itapevi, SP', location: 'São Paulo'),
    Places(name: 'São Sebastião do Paraíso, MG', location: 'Minas Gerais'),
    Places(name: 'São José do Rio Preto, SP', location: 'São Paulo'),
    Places(name: 'Barretos, SP', location: 'São Paulo'),
    Places(name: 'Osasco, SP', location: 'São Paulo'),
    Places(name: 'Bento Gonçalves, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Santa Bárbara d\'Oeste, SP', location: 'São Paulo'),
    Places(name: 'Votorantim, SP', location: 'São Paulo'),
    Places(name: 'Cariacica, ES', location: 'Espírito Santo'),
    Places(name: 'São Leopoldo, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Porto Seguro, BA', location: 'Bahia'),
    Places(name: 'Sumaré, SP', location: 'São Paulo'),
    Places(name: 'Várzea Grande, MT', location: 'Mato Grosso'),
    Places(name: 'Alegrete, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Palhoça, SC', location: 'Santa Catarina'),
    Places(name: 'Montes Claros, MG', location: 'Minas Gerais'),
    Places(name: 'Paulo Afonso, BA', location: 'Bahia'),
    Places(name: 'Araucária, PR', location: 'Paraná'),
    Places(name: 'Carapicuíba, SP', location: 'São Paulo'),
    Places(name: 'Indaiatuba, SP', location: 'São Paulo'),
    Places(name: 'Itumbiara, GO', location: 'Goiás'),
    Places(name: 'Parnaíba, PI', location: 'Piauí'),
    Places(name: 'Santana do Livramento, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Itabira, MG', location: 'Minas Gerais'),
    Places(name: 'Itapipoca, CE', location: 'Ceará'),
    Places(name: 'Araras, SP', location: 'São Paulo'),
    Places(name: 'Paragominas, PA', location: 'Pará'),
    Places(name: 'Araranguá, SC', location: 'Santa Catarina'),
    Places(name: 'Itapetinga, BA', location: 'Bahia'),
    Places(name: 'Assis, SP', location: 'São Paulo'),
    Places(name: 'Ji-Paraná, RO', location: 'Rondônia'),
    Places(name: 'Almirante Tamandaré, PR', location: 'Paraná'),
    Places(name: 'Penedo, AL', location: 'Alagoas'),
    Places(name: 'Garanhuns, PE', location: 'Pernambuco'),
    Places(name: 'Luziânia, GO', location: 'Goiás'),
    Places(name: 'Tatuí, SP', location: 'São Paulo'),
    Places(name: 'Jaguarão, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Santa Inês, MA', location: 'Maranhão'),
    Places(name: 'Conselheiro Lafaiete, MG', location: 'Minas Gerais'),
    Places(name: 'Balsas, MA', location: 'Maranhão'),
    Places(name: 'Tucuruí, PA', location: 'Pará'),
    Places(name: 'Maracanaú, CE', location: 'Ceará'),
    Places(name: 'São Gabriel, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Jataí, GO', location: 'Goiás'),
    Places(name: 'Jaguaquara, BA', location: 'Bahia'),
    Places(name: 'Guanambi, BA', location: 'Bahia'),
    Places(name: 'Guaxupé, MG', location: 'Minas Gerais'),
    Places(name: 'Garanhuns, PE', location: 'Pernambuco'),
    Places(name: 'Mirassol, SP', location: 'São Paulo'),
    Places(name: 'Ariquemes, RO', location: 'Rondônia'),
    Places(name: 'Leme, SP', location: 'São Paulo'),
    Places(name: 'São Luiz Gonzaga, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Santo Ângelo, RS', location: 'Rio Grande do Sul'),
    Places(name: 'Santa Rosa, RS', location: 'Rio Grande do Sul'),
    Places(name: 'São Sepé, RS', location: 'Rio Grande do Sul'),
    Places(name: 'São Francisco do Sul, SC', location: 'Santa Catarina'),
    Places(name: 'João Monlevade, MG', location: 'Minas Gerais'),
    Places(name: 'Palmares, PE', location: 'Pernambuco'),
  ];

  static String _displayStringForOption(Places option) => option.name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Autocomplete<Places>(
          displayStringForOption: _displayStringForOption,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return _userOptions;
            } else {
              return _userOptions.where((option) {
                return option.name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            }
          },
          onSelected: (Places selection) {
            debugPrint(_displayStringForOption(selection));
            debugPrint(user_interests.toString());
          },
        ),
      ],
    );
  }
}
