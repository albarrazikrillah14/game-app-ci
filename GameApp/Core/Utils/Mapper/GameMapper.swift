//
//  GameMapper.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation

final class GameMapper {

  static func mapGamesResponsesToEntities(
    input gameResponse: GameResponse
  ) -> [GameEntity] {
    return gameResponse.results!.map { result in
      let newGame = GameEntity()
      
      newGame.id = result.id 
      newGame.image = result.gameImage ?? "unknown"
      newGame.rating = result.rating ?? 0
      newGame.releaseDate = result.releaseDate ?? "unknown"
      newGame.name = result.name
      
      return newGame
    }
  }
   
  static func mapGamesEntitiesToDomains(
    input gameEntities: [GameEntity]
  ) -> [GameModel] {
    return gameEntities.map { result in
      return GameModel(
        id: result.id,
        name: result.name,
        releaseDate: result.releaseDate,
        rating: result.rating,
        gameImage: result.image
      )
    }
  }
 
  static func mapGameDetailResponseToDomains(
    input gameReponse: GameDetailResponse
  ) -> DetailModel {
    return DetailModel(
      id: gameReponse.id,
      name: gameReponse.name,
      description: gameReponse.description,
      backgroundImage: gameReponse.backgroundImage,
      rating: gameReponse.rating,
      released: gameReponse.released,
      isFavorite: false
    )
  }
}
