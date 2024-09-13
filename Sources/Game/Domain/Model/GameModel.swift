//
//  File.swift
//
//
//  Created by + on 3/6/1446 AH.
//

public struct GameModel: Equatable, Identifiable {
  public let id: Int
  public let name, released: String
  public let image: String
  public let rating: Double
  public let descriptionRaw: String
  public var favorite: Bool = false
}
