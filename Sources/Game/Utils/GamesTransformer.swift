//
//  File.swift
//
//
//  Created by + on 3/6/1446 AH.
//

import Core

public struct GamesTransformer: Mapper {
  public typealias Request = String
  public typealias Response = [GameResponse]
  public typealias Entity = [GameEntity]
  public typealias Domain = [GameModel]

  public init() {}

  public func transformResponseToEntity(
    request: String?,
    response: [GameResponse]
  ) -> [GameEntity] {
    return response.map { result in
      let newGame = GameEntity()

      newGame.id = result.id
      newGame.name = result.name
      newGame.released = result.released
      newGame.image = result.image
      newGame.rating = result.rating
      newGame.descriptionRaw = result.descriptionRaw

      return newGame
    }
  }

  public func transformEntityToDomain(
    entity: [GameEntity]
  ) -> [GameModel] {
    return entity.map { result in
      GameModel(
        id: result.id,
        name: result.name,
        released: result.released,
        image: result.image,
        rating: result.rating,
        descriptionRaw: result.descriptionRaw
      )
    }
  }
}
