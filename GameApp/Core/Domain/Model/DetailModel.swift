//
//  DetailModel.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation

struct DetailModel: Equatable, Identifiable {
  let id: Int
  let name: String
  let description: String
  let backgroundImage: String
  let rating: Double
  let released: String
  var isFavorite: Bool
}
