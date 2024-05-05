//
//  NetworkManager.swift
//  GameApp
//
//  Created by Rizki Siraj on 04/05/24.
//

import Foundation

class NetworkService {

  // MARK: Gunakan API Key dalam akun Anda.
  let apiKey = "3303063f4ffb427695a265b89bf0697f"
  let pageSize = "10"

  func getGames() async throws -> [Game] {
    var components = URLComponents(string: "https://api.rawg.io/api/games")!
    components.queryItems = [
      URLQueryItem(name: "key", value: apiKey),
      URLQueryItem(name: "page_size", value: pageSize),
    ]
    let request = URLRequest(url: components.url!)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      fatalError("Error: Can't fetching data.")
    }

      let decoder = JSONDecoder()
      var result = APIResponse(results: [])
      do {
        result = try decoder.decode(APIResponse.self, from: data)
      } catch let DecodingError.keyNotFound(key, context) {
          print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
      } catch let DecodingError.typeMismatch(type, context) {
          print("Type mismatch for type \(type): \(context.debugDescription)")
      } catch let DecodingError.valueNotFound(type, context) {
          print("Value not found for type \(type): \(context.debugDescription)")
      } catch let DecodingError.dataCorrupted(context) {
          print("Data corrupted: \(context.debugDescription)")
      } catch {
          print("Unknown error: \(error)")
      }
    

      return gameMapper(input: result.results)
  }
}

extension NetworkService {
  fileprivate func gameMapper(
    input gameResponses: [GameResponse]
  ) -> [Game] {
    return gameResponses.map { result in
      return Game(
        id: result.id,
        name: result.name,
        released: result.released,
        imagePath: result.imagePath,
        rating: result.rating,
        genres: result.genres ?? [],
        parentPlatforms: result.parentPlatforms ?? []
      )
    }
  }
}
