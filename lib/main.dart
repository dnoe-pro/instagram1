import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Class story avec comme attribut le id de l'utilisateur son nom et sa photo de profile -> méthode de conversion depuis un json
class Story {
  int userId;
  String name;
  String img;

  Story({required this.userId, required this.name, required this.img});
//Méthode storyfrom Json permettant de retourner un element story à l'aide d'un extrait de json
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      userId: json['userId'],
      name: json['name'],
      img: json['img'],
    );
  }
}

//Class post avec comme attribut le id de l'utilisateur l'image du poste le nombre de like, la description et la date du post -> méthode de conversion depuis un json
class Post {
  int userId;
  //Liste de lien
  List<dynamic> images;
  String nb_like;
  String description;

  DateTime date_post;

  Post(
      {required this.userId,
      required this.images,
      required this.nb_like,
      required this.description,
      required this.date_post});

//Méthode Postfrom Json permettant de retourner un element post à l'aide d'un extrait de json
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      images: json['images'],
      nb_like: json['nb_like'],
      description: json['description'],
      date_post: dateToCorrectFormat(json['date_post']),
    );
  }
}

Future<List<Story>> loadStoryFromJson() async {
  // Charger le contenu du fichier JSON
  final String response = await rootBundle.loadString('assets/data.json');

  // Convertir la chaîne JSON en un objet Map
  final data = jsonDecode(response);

  //Init variable liste qui sera retourner -> elle contiendra touts les élément Story, il s'agit d'une collection d'objet story
  List<Story> liste_element_story = [];

  //boucle pour chaque element dans le json
  for (int i = 0; i < data["story"].length; i++) {
    //Instanciation story temporaire + assignation valeur retourner par la methode story.FromJson de la classe story -> elle retourne un objet story complet
    Story story_temp;
    story_temp = Story.fromJson(data["story"][i]);

    //Ajout dans la liste de l'instanciation temporaire
    liste_element_story.add(story_temp);
  }

  // Créer une instance de Person à partir du JSON
  return liste_element_story;
}

//Méthode loadPostFromJson qui permet de retourner une collections d'objet de story
Future<List<Post>> loadPostFromJson() async {
  // Charger le contenu du fichier JSON
  final String response = await rootBundle.loadString('assets/data.json');

  // Convertir la chaîne JSON en un objet Map
  final data = jsonDecode(response);

  //Init variable liste qui sera retourner -> elle contiendra touts les élément story, il s'agit d'une collection d'objet story
  List<Post> liste_element_post_temp = [];

  //boucle pour chaque element dans le json
  for (int i = 0; i < data["post"].length; i++) {
    //Instanciation story temporaire + assignation valeur retourner par la methode story.FromJson de la classe story -> elle retourne un objet story complet
    Post poste_temp;
    poste_temp = Post.fromJson(data["post"][i]);

    //Ajout dans la liste de l'instanciation temporaire
    liste_element_post_temp.add(poste_temp);
  }

  return liste_element_post_temp;
}

//dateToCorrectFormat qui prend en paramètre une date en string et retourne un format date
DateTime dateToCorrectFormat(String formatdate) {
  String dateCorrectString = formatdate.replaceAll(RegExp(r'h'), ':');
  dateCorrectString = dateCorrectString.replaceAll(RegExp(r'/'), '-');

  //Décomposition de la date en plusieurs partie
  List<String> ListeCompositionDate = dateCorrectString.split("-");
  List<String> DetacheHeureAnnee = ListeCompositionDate[2].split(" ");
  List<String> DecomposeHeure = DetacheHeureAnnee[1].split(":");

  DateTime newDate = DateTime(
      int.parse(DetacheHeureAnnee[0].trim()),
      int.parse(ListeCompositionDate[1]),
      int.parse(ListeCompositionDate[0]),
      int.parse(DecomposeHeure[0]),
      int.parse(DecomposeHeure[1]));
  print(newDate.toString());
  return newDate;
}

class _MyHomePageState extends State<MyHomePage> {
  //Collections d'objet des storys
  List<Story> liste_element_story = [];
  //Collections d'objet des posts
  List<Post> liste_element_post = [];

  @override
  void initState() {
    //Appel fonction retourne liste objet post
    loadPostFromJson().then((value_post) {
      setState(() {
        liste_element_post = value_post;
      });
    });

    //Appel fonction retourne liste objet story
    loadStoryFromJson().then((value) {
      setState(() {
        liste_element_story = value;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    //AppBAR
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Pour vous',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {},
              ),
            ]),
        body: Column(children: [
          // -----------------------------------------------------STORY INSTAGRAM------------------------------------------------------------------------------------- //
          Container(
            height: MediaQuery.of(context).size.height * 0.130,
            child: Row(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                color: Colors.black,
                //ListView où chaques éléments est une des story
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Column(
                          children: [
                            // ------------------------------------- Avatar story -------------------------------------------------- //
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.purpleAccent,
                                    Colors.red,
                                    Colors.yellowAccent,
                                  ],
                                ),
                              ),
                              margin: const EdgeInsets.all(3),
                              child: CircleAvatar(
                                  radius: 40,
                                  child: ClipOval(
                                      child: Image.network(
                                    liste_element_story
                                        .where((element) =>
                                            element.userId ==
                                            liste_element_story[index].userId)
                                        .first
                                        .img,
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    height: MediaQuery.of(context).size.height *
                                        0.30,
                                    fit: BoxFit.cover,
                                  ))),
                            ),
                            // ------------------------------------- Nom story -------------------------------------------------- //
                            Container(
                              child: Text(
                                liste_element_story
                                    .where((element) =>
                                        element.userId ==
                                        liste_element_story[index].userId)
                                    .first
                                    .name,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 184, 184, 184)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ]),
          ),
// -----------------------------------------------------POST INSTAGRAM------------------------------------------------------------------------------------- //
          Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.800,
            child: ListView.builder(
                //ItemCount selon le nombre de post disponible dans le json
                itemCount: liste_element_post.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  //Chaque Poste est une column
                  return Column(children: [
                    // ------------------------------------- Tete du poste -------------------------------------------------- //
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.black,
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 15,
                              child: ClipOval(
                                  child: Image.network(
                                liste_element_story
                                    .where((element) =>
                                        element.userId ==
                                        liste_element_story[index].userId)
                                    .first
                                    .img,
                                width: MediaQuery.of(context).size.width * 0.30,
                                height:
                                    MediaQuery.of(context).size.height * 0.30,
                                fit: BoxFit.cover,
                              ))),
                          Text(
                              liste_element_story
                                  .where((element) =>
                                      element.userId ==
                                      liste_element_story[index].userId)
                                  .first
                                  .name,
                              style: DefaultTextStyle.of(context).style.apply(
                                  fontSizeFactor: 1.1, color: Colors.white)),
                        ],
                      ),
                    ),
                    // ------------------------------------- Image du poste -------------------------------------------------- //
                    CarouselSlider(
                      items: liste_element_post[index].images.map((i) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 3,
                          child: Container(
                            child: Image.network(i, fit: BoxFit.fill),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                          viewportFraction: 1, enableInfiniteScroll: false),
                    ),
                    // ------------------------------------- bas du poste -------------------------------------------------- //
                    Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topLeft,
                      child: Row(children: [
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.white),
                          onPressed: () {},
                        ),
                        Text(liste_element_post[index].nb_like,
                            style: DefaultTextStyle.of(context).style.apply(
                                fontSizeFactor: 1.2, color: Colors.white)),
                        IconButton(
                          icon: const Icon(Icons.comment, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                      ]),
                    ),

                    //Colonne partie basse -> nombre de like,description, date de poste
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.black,
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Description de la publication
                          Text(
                              liste_element_story
                                      .where((element) =>
                                          element.userId ==
                                          liste_element_post[index].userId)
                                      .first
                                      .name +
                                  " " +
                                  liste_element_post[index].description +
                                  "... voir plus",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white)),

                          //Date de la publication
                          Text(
                              "Poster le " +
                                  dateToCorrectFormat(liste_element_post[index]
                                          .date_post
                                          .toString())
                                      .day
                                      .toString() +
                                  "/" +
                                  dateToCorrectFormat(liste_element_post[index]
                                          .date_post
                                          .toString())
                                      .month
                                      .toString() +
                                  "/" +
                                  dateToCorrectFormat(liste_element_post[index]
                                          .date_post
                                          .toString())
                                      .year
                                      .toString() +
                                  " à " +
                                  dateToCorrectFormat(liste_element_post[index]
                                          .date_post
                                          .toString())
                                      .hour
                                      .toString() +
                                  "h" +
                                  dateToCorrectFormat(liste_element_post[index]
                                          .date_post
                                          .toString())
                                      .minute
                                      .toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    )
                  ]);
                }),
          )
        ]));
  }
}
