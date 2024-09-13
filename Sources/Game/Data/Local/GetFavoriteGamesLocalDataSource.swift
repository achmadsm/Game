//
//  File.swift
//
//
//  Created by + on 3/8/1446 AH.
//

import Combine
import Core
import RealmSwift

public struct GetFavoriteGamesLocalDataSource: LocalDataSource {
  public typealias Request = Int

  public typealias Response = GameEntity

  private let realm: Realm

  public init(realm: Realm) {
    self.realm = realm
  }

  public func list(request: Int?) -> AnyPublisher<[GameEntity], Error> {
    return Future<[GameEntity], Error> { completion in

      let gameEntities = {
        realm.objects(GameEntity.self)
          .filter("favorite = \(true)")
          .sorted(byKeyPath: "name", ascending: true)
      }()
      completion(.success(gameEntities.toArray(ofType: GameEntity.self)))

    }.eraseToAnyPublisher()
  }

  public func add(entities: [GameEntity]) -> AnyPublisher<Bool, Error> {
    fatalError()
  }

  public func get(id: Int) -> AnyPublisher<GameEntity, Error> {
    return Future<GameEntity, Error> { completion in
      if let gameEntity = {
        self.realm.objects(GameEntity.self).filter("id = \(id)")
      }().first {
        do {
          try self.realm.write {
            gameEntity.setValue(!gameEntity.favorite, forKey: "favorite")
          }
          completion(.success(gameEntity))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

  public func update(id: Int, entity: GameEntity) -> AnyPublisher<Bool, Error> {
    fatalError()
  }
}
