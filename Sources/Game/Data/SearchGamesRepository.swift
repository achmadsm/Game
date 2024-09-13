//
//  File.swift
//
//
//  Created by + on 3/7/1446 AH.
//

import Combine
import Core

public struct SearchGamesRepository<
  RemoteDataSource: DataSource,
  Transformer: Mapper
>: Repository where

  RemoteDataSource.Request == String,
  RemoteDataSource.Response == [GameResponse],
  Transformer.Request == String,
  Transformer.Response == [GameResponse],
  Transformer.Entity == [GameEntity],
  Transformer.Domain == [GameModel] {
  public typealias Request = String
  public typealias Response = [GameModel]

  private let remoteDataSource: RemoteDataSource
  private let mapper: Transformer

  public init(
    remoteDataSource: RemoteDataSource,
    mapper: Transformer
  ) {
    self.remoteDataSource = remoteDataSource
    self.mapper = mapper
  }

  public func execute(request: String?) -> AnyPublisher<[GameModel], Error> {
    return remoteDataSource.execute(request: request)
      .map { self.mapper.transformResponseToEntity(request: request, response: $0) }
      .map { self.mapper.transformEntityToDomain(entity: $0) }
      .eraseToAnyPublisher()
  }
}
