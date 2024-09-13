//
//  File.swift
//
//
//  Created by + on 3/6/1446 AH.
//

public struct GamesResponse: Decodable {
  let results: [GameResponse]
}

public struct GameResponse: Decodable {
  let id: Int
  let name, released: String
  let image: String
  let rating: Double
  let descriptionRaw: String

  private enum CodingKeys: String, CodingKey {
    case id, name, released
    case image = "background_image"
    case rating
    case descriptionRaw = "description_raw"
  }
}
