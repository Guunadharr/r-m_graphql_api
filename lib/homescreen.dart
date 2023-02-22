import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = false;
  List<dynamic>? characters = [];

  void fetchData() async {
    setState(() {
      _loading = true;
    });

    HttpLink link = HttpLink('https://rickandmortyapi.com/graphql');
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        dataIdFromObject: (object) {},
      ),
    );

    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        document: gql(
          r"""query {
           characters{
             results {
               name 
               image
               gender 
             }
            }  
          }""",
        ),
      ),
    );
    setState(() {
      characters = queryResult.data!['characters']['results'];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Screen'),
      ),
      body: _loading
          ? CircularProgressIndicator()
          : characters!.isEmpty
              ? Center(
                  child: ElevatedButton(
                    child: Text('Fetch Data'),
                    onPressed: () {
                      fetchData();
                    },
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Image(
                            image: NetworkImage(
                              characters![index]['image'],
                            ),
                          ),
                          title: Text(
                            characters![index]['name'],
                          ),
                          subtitle: Text(
                            characters![index]['gender'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
