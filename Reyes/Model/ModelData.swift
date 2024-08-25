import Foundation
import FirebaseCore
import FirebaseFirestore

let db = Firestore.firestore()

func getProducts() async throws -> [Product]{
    return try await getData(collection: "Products", as: Product.self)
}

//Retrieve from Database
func getData<T: Decodable>(collection: String, as type: T.Type) async throws -> [T] {
    
    do {
      let querySnapshot = try await db.collection(collection).getDocuments()
        var documentsArray: [T] = []
        
        for document in querySnapshot.documents {
            if let documentData = try? document.data(as: T.self) {
                documentsArray.append(documentData)
            } else {
                print("Error decoding document \(document.documentID)")
            }
        }
        return documentsArray
    } catch {
      print("Error getting documents: \(error)")
        throw error
    }
}

//----------------------------------------------------------------------------------------------------------------
//
//This code below is not used any more but I decided to keep it in case I want to upload a local json to the db
//
//----------------------------------------------------------------------------------------------------------------

/*
let products: [Product] = load("Products.json")
let games: [Game] = load("Games.json")
let players: [Player] = load("Players.json")
let noticias: [Noticia] = load("News.json")
let actualGames: [ActualGame] = load("ActualGame.json")
let rewardsInstructions: [RewardInstruction] = load("RewardsOnboarding.json")
var updates: [Update] = load("Updates.json")
var staff: [StaffMember] = load("Staff.json")

//Parse form Json
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func setProducts(){
    let dbProducts = db.collection("Products")
    
    products.forEach { product in
        dbProducts.document(product.name).setData([
            "id": product.id,
            "name": product.name,
            "price": product.price,
            "size": product.size,
            "description": product.description,
            "imgNames": product.imgNames
        ])
    }
}

func setActualGame(){
    let collection = db.collection("ActualGame")
    
    actualGames.forEach { element in
        collection.document(String(element.id)).setData([
            "id": element.id,
            "gameId": element.gameId
        ])
    }
}

func setGames(){
    let collection = db.collection("Games")
    
    games.forEach { element in
        collection.document(String(element.id)).setData([
            "id": element.id,
            "date": element.date,
            "team": element.team,
            "hour": element.hour,
            "location": element.location,
            "reyesRecord": element.reyesRecord,
            "teamRecord": element.teamRecord,
            "teamImageName": element.teamImageName,
            "qrt_1_reyes": element.qrt_1_reyes,
            "qrt_1_team": element.qrt_1_team,
            "qrt_2_reyes": element.qrt_2_reyes,
            "qrt_2_team": element.qrt_2_team,
            "qrt_3_reyes": element.qrt_3_reyes,
            "qrt_3_team": element.qrt_3_team,
            "qrt_4_reyes": element.qrt_4_reyes,
            "qrt_4_team": element.qrt_4_team,
            "resumeVideoLink": element.resumeVideoLink,
            "gameVideoLink": element.gameVideoLink,
            "interviewVideoLink": element.interviewVideoLink
        ])
    }
}

func setNews(){
    let collection = db.collection("News")
    
    noticias.forEach { element in
        collection.document(String(element.id)).setData([
            "id": element.id,
            "title": element.title,
            "subTitle": element.subTitle,
            "mainImageName": element.mainImageName,
            "by": element.by,
            "date": element.date,
            "paragraphs": element.paragraphs
        ])
    }
}

func setPlayers(){
    let collection = db.collection("Players")
    
    players.forEach { element in
        collection.document(String(element.id)).setData([
            "id": element.id,
            "number": element.number,
            "profileImageName": element.profileImageName,
            "name": element.name,
            "pos": element.pos,
            "weight": element.weight,
            "height": element.height,
            "age": element.age,
            "procedence": element.procedence,
            "lfa": element.lfa,
            "status": element.status,
            "group": element.group,
            "about": element.about,
            "imgNames": element.imgNames
        ])
    }
}

func setRewardsOnboarding(){
    let collection = db.collection("Reward_Instructions")
    
    rewardsInstructions.forEach { element in
        collection.document(String(element.id)).setData([
            "id": element.id,
            "image": element.image,
            "title": element.title,
            "text": element.text
        ])
    }
}

func setStaff(){
    let collection = db.collection("Staff")
    
    staff.forEach { element in
        collection.document(String(element.id)).setData([
            "id": element.id,
            "profileImageName": element.profileImageName,
            "name": element.name,
            "rol": element.rol,
            "age": element.age,
            "about": element.about,
            "imgNames": element.images
        ])
    }
}

func setUpdates(){
    let collection = db.collection("Updates")
    
    updates.forEach { element in
        collection.document(String(element.id)).setData([
            "id": element.id,
            "image": element.image
        ])
    }
}
*/
