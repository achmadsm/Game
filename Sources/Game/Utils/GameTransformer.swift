//
//  File.swift
//
//
//  Created by + on 3/7/1446 AH.
//

import Core

public struct GameTransformer: Mapper {
  public typealias Request = Int
  public typealias Response = GameResponse
  public typealias Entity = GameEntity
  public typealias Domain = GameModel

  public init() {}

  public func transformResponseToEntity(request: Int?, response: GameResponse) -> GameEntity {
    let gameEntity = GameEntity()

    gameEntity.id = response.id
    gameEntity.name = response.name
    gameEntity.released = response.released
    gameEntity.image = response.image
    gameEntity.rating = response.rating
    gameEntity.descriptionRaw = response.descriptionRaw

    return gameEntity
  }

  public func transformEntityToDomain(entity: GameEntity) -> GameModel {
    return GameModel(
      id: entity.id,
      name: entity.name,
      released: entity.released,
      image: entity.image,
      rating: entity.rating,
      descriptionRaw: entity.descriptionRaw,
      favorite: entity.favorite
    )
  }
}
