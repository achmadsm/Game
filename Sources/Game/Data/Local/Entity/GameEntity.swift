//
//  GameEntity.swift
//  Game
//
//  Created by + on 2/24/1446 AH.
//

import Foundation
import RealmSwift

public class GameEntity: Object {
  @objc dynamic var id = 0
  @objc dynamic var name = ""
  @objc dynamic var released = ""
  @objc dynamic var image = ""
  @objc dynamic var rating = 0.0
  @objc dynamic var descriptionRaw = ""
  @objc dynamic var favorite = false

  override public static func primaryKey() -> String? {
    return "id"
  }
}
