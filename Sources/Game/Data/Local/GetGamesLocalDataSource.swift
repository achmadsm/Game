//
//  File.swift
//
//
//  Created by + on 3/6/1446 AH.
//

import Combine
import Core
import RealmSwift

public struct GetGamesLocalDataSource: LocalDataSource {
  public typealias Request = String

  public typealias Response = GameEntity

  private let realm: Realm

  public init(realm: Realm) {
    self.realm = realm
  }

  public func list(request: String?) -> AnyPublisher<[GameEntity], Error> {
    return Future<[GameEntity], Error> { completion in
      let games: Results<GameEntity> = {
        self.realm.objects(GameEntity.self)
          .sorted(byKeyPath: "name", ascending: true)
      }()
      completion(.success(games.toArray(ofType: GameEntity.self)))

    }.eraseToAnyPublisher()
  }

  public func add(entities: [GameEntity]) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      do {
        try self.realm.write {
          for game in entities {
            self.realm.add(game, update: .all)
          }
          completion(.success(true))
        }
      } catch {
        completion(.failure(DatabaseError.requestFailed))
      }

    }.eraseToAnyPublisher()
  }

  public func get(id: Int) -> AnyPublisher<GameEntity, Error> {
    return Future<GameEntity, Error> { completion in

      let games: Results<GameEntity> = {
        self.realm.objects(GameEntity.self)
          .filter("id = \(id)")
      }()

      guard let game = games.first else {
        completion(.failure(DatabaseError.requestFailed))
        return
      }

      completion(.success(game))

    }.eraseToAnyPublisher()
  }

  public func update(id: Int, entity: GameEntity) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { completion in
      if let gameEntity = {
        self.realm.objects(GameEntity.self).filter("id = \(id)")
      }().first {
        do {
          try self.realm.write {
            gameEntity.setValue(entity.name, forKey: "name")
            gameEntity.setValue(entity.released, forKey: "released")
            gameEntity.setValue(entity.image, forKey: "image")
            gameEntity.setValue(entity.rating, forKey: "rating")
            gameEntity.setValue(entity.descriptionRaw, forKey: "decriptionRaw")
          }
          completion(.success(true))

        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }
}
