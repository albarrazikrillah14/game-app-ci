//
//  ImageDownloader.swift
//  GameApp
//
//  Created by Raihan on 17/11/23.
//

import Foundation

struct API {
  static let baseUrl = "https://api.rawg.io/api/"
  static let apiKeys = "d9d10c519d0e41cd95fecac72a3b9574"
}

protocol Endpoint {
  var url: String { get }
}

enum Endpoints {
  
  enum Gets: Endpoint {
    case games
    case search
    case detail(String)
    
    public var url: String {
      switch self {
      case .games: return "\(API.baseUrl)games"
      case .search: return "\(API.baseUrl)games"
      case .detail(let id): return "\(API.baseUrl)games/\(id)"
      }
    }
  }
}
