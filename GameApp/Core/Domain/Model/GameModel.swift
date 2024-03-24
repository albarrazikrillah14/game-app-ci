//
//  GameModel.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation

struct GameModel: Equatable, Identifiable {
  let id: Int
  let name: String
  let releaseDate: String?
  let rating: Double?
  let gameImage: String?
}
