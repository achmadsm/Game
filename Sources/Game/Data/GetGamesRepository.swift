//
//  File.swift
//
//
//  Created by + on 3/6/1446 AH.
//

import Combine
import Core

public struct GetGamesRepository<
  GameLocalDataSource: LocalDataSource,
  RemoteDataSource: DataSource,
  Transformer: Mapper
>: Repository where

  GameLocalDataSource.Response == GameEntity,
  RemoteDataSource.Response == [GameResponse],
  Transformer.Response == [GameResponse],
  Transformer.Entity == [GameEntity],
  Transformer.Domain == [GameModel] {
  public typealias Request = Any
  public typealias Response = [GameModel]

  private let localDataSource: GameLocalDataSource
  private let remoteDataSource: RemoteDataSource
  private let mapper: Transformer

  public init(
    localDataSource: GameLocalDataSource,
    remoteDataSource: RemoteDataSource,
    mapper: Transformer
  ) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
    self.mapper = mapper
  }

  public func execute(request: Any?) -> AnyPublisher<[GameModel], Error> {
    return localDataSource.list(request: nil)
      .flatMap { result -> AnyPublisher<[GameModel], Error> in
        if result.isEmpty {
          return self.remoteDataSource.execute(request: nil)
            .map { self.mapper.transformResponseToEntity(request: nil, response: $0) }
            .catch { _ in self.localDataSource.list(request: nil) }
            .flatMap { self.localDataSource.add(entities: $0) }
            .filter { $0 }
            .flatMap { _ in self.localDataSource.list(request: nil)
              .map { self.mapper.transformEntityToDomain(entity: $0) }
            }
            .eraseToAnyPublisher()
        } else {
          return self.localDataSource.list(request: nil)
            .map { self.mapper.transformEntityToDomain(entity: $0) }
            .eraseToAnyPublisher()
        }
      }.eraseToAnyPublisher()
  }
}
