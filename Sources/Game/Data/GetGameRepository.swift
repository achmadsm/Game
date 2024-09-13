//
//  File.swift
//
//
//  Created by + on 3/7/1446 AH.
//

import Combine
import Core

public struct GetGameRepository<
  GameLocalDataSource: LocalDataSource,
  RemoteDataSource: DataSource,
  Transformer: Mapper
>: Repository where

  GameLocalDataSource.Response == GameEntity,
  RemoteDataSource.Request == String,
  RemoteDataSource.Response == GameResponse,
  Transformer.Request == Int,
  Transformer.Response == GameResponse,
  Transformer.Entity == GameEntity,
  Transformer.Domain == GameModel {
  public typealias Request = Int
  public typealias Response = GameModel

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

  public func execute(request: Int?) -> AnyPublisher<GameModel, Error> {
    guard let request = request else { fatalError("Request cannot be empty") }

    return localDataSource.get(id: request)
      .flatMap { result -> AnyPublisher<GameModel, Error> in
        if result.name.isEmpty {
          return self.remoteDataSource.execute(request: String(request))
            .map { self.mapper.transformResponseToEntity(request: request, response: $0) }
            .catch { _ in self.localDataSource.get(id: request) }
            .flatMap { self.localDataSource.update(id: request, entity: $0) }
            .filter { $0 }
            .flatMap { _ in self.localDataSource.get(id: request)
              .map { self.mapper.transformEntityToDomain(entity: $0) }
            }.eraseToAnyPublisher()
        } else {
          return self.localDataSource.get(id: request)
            .map { self.mapper.transformEntityToDomain(entity: $0) }
            .eraseToAnyPublisher()
        }
      }.eraseToAnyPublisher()
  }
}
