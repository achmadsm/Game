//
//  File.swift
//
//
//  Created by + on 3/8/1446 AH.
//

import Combine
import Core

public struct UpdateFavoriteGameRepository<
  GameLocalDataSource: LocalDataSource,
  Transformer: Mapper
>: Repository where

  GameLocalDataSource.Request == Int,
  GameLocalDataSource.Response == GameEntity,
  Transformer.Response == GameResponse,
  Transformer.Entity == GameEntity,
  Transformer.Domain == GameModel {
  public typealias Request = Int
  public typealias Response = GameModel

  private let localDataSource: GameLocalDataSource
  private let mapper: Transformer

  public init(
    localDataSource: GameLocalDataSource,
    mapper: Transformer
  ) {
    self.localDataSource = localDataSource
    self.mapper = mapper
  }

  public func execute(request: Int?) -> AnyPublisher<GameModel, Error> {
    return localDataSource.get(id: request ?? 0)
      .map { self.mapper.transformEntityToDomain(entity: $0) }
      .eraseToAnyPublisher()
  }
}
