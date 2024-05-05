//
//  Game.swift
//  GameApp
//
//  Created by Rizki Siraj on 04/05/24.
//

import Foundation
import UIKit

enum DownloadState {
  case new, downloaded, failed
}

class Game {
    let id: Int
    let name: String
    let released: Date
    let imagePath: URL
    let rating: Double
    let genres: [EsrbRating]
    let parentPlatforms: [PlatformParent]
    
    var image: UIImage?
    var state: DownloadState = .new
    
    init(id: Int, name: String, released: Date, imagePath: URL, rating: Double, genres: [EsrbRating], parentPlatforms: [PlatformParent]) {
        self.id = id
        self.name = name
        self.released = released
        self.imagePath = imagePath
        self.rating = rating
        self.genres = genres
        self.parentPlatforms = parentPlatforms
    }
}

struct APIResponse: Decodable {
    var results: [GameResponse]
}

struct GameResponse: Decodable {
    var id: Int
    var name: String
    var released: Date
    var imagePath: URL
    var rating: Double
    var genres: [EsrbRating]?
    var parentPlatforms: [PlatformParent]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case imagePath = "background_image"
        case rating
        case genres
        case parentPlatforms = "parent_platforms"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let dateString = try container.decode(String.self, forKey: .released)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        released = dateFormatter.date(from: dateString)!
        
        let path = try container.decode(String.self, forKey: .imagePath)
        imagePath = URL(string: path)!
        
        rating = try container.decode(Double.self, forKey: .rating)
        genres = try container.decode([EsrbRating].self, forKey: .genres)
        parentPlatforms = try container.decode([PlatformParent].self, forKey: .parentPlatforms)
    }
}

struct EsrbRating: Decodable {
    var id: Int
    var name: String
}

struct PlatformParent: Decodable {
    var platform: EsrbRating
}
