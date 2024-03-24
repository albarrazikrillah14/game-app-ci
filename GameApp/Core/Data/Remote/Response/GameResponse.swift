//
//  GameResponse.swift
//  GameApp
//
//  Created by Raihan on 17/11/23.
//

import Foundation

struct GameResponse: Codable {
  let count: Int?
  let next: String?
  let previous: String?
  let results: [Game]?
}

struct Game: Codable {
  let id: Int
  let name: String
  let releaseDate: String?
  let rating: Double?
  let gameImage: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case releaseDate = "released"
    case rating
    case gameImage = "background_image"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
    releaseDate = DateFormatterHelper().dateFormatter(date: dateString)
    rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
    gameImage = try container.decodeIfPresent(String.self, forKey: .gameImage) ?? ""
  }
  
  init(id: Int, name: String, releaseDate: String, rating: Double, gameImage: String, desc: String) {
    self.id = id
    self.name = name
    self.releaseDate = releaseDate
    self.rating = rating
    self.gameImage = gameImage
  }
}
