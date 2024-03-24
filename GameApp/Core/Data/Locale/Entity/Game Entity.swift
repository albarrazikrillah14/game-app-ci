//
//  Game Entity.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation
import RealmSwift

class GameEntity: Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var releaseDate: String = ""
  @objc dynamic var rating: Double = 0.0
  @objc dynamic var image: String = ""
  @objc dynamic var isFavorite: Bool = false
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

