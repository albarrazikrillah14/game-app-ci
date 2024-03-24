//
//  FavoriteInteractor.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation
import Combine
import Core
import Game

protocol FavoriteUseCase {
  func getAllFavoriteGame() -> AnyPublisher<[GameDomainModel], Error>
}

class FavoriteInteractor: FavoriteUseCase {
  
  private let repository: Interactor<
    Any,
    [GameDomainModel],
    GameDomainDetailModel,
    GetGamesRepository<
      GetGamesLocateDataSource,
      GetGamesRemoteDataSouce,
      GameTransformer>
  >
  
  init(repository: Interactor<
       Any,
       [GameDomainModel],
       GameDomainDetailModel,
       GetGamesRepository<
         GetGamesLocateDataSource,
         GetGamesRemoteDataSouce,
         GameTransformer>>) {
    self.repository = repository
  }
  
  func getAllFavoriteGame() -> AnyPublisher<[GameDomainModel], Error> {
    repository._repository.getAllFavorite()
  }
}
