//
//  DetailInteractor.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation
import Combine
import Core
import Game

protocol DetailUseCase {
  func getGameDetail(id: String) -> AnyPublisher<GameDomainDetailModel, Error>
  func addToFavorite(id: Int) -> AnyPublisher<Bool, Error>
  func deleteFromFavorite(id: Int) -> AnyPublisher<Bool, Error>
  func isFavorite(id: Int) -> AnyPublisher<Bool, Error>
}


class DetailInteractor: DetailUseCase {
 
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
         GameTransformer>
     >) {
    self.repository = repository
  }
  
  func getGameDetail(id: String) -> AnyPublisher<GameDomainDetailModel, Error> {
    repository._repository.getGameDetail(id: id)
  }
  
  func addToFavorite(id: Int) -> AnyPublisher<Bool, Error> {
    repository._repository.addToFavorite(from: id)
  }
  
  func deleteFromFavorite(id: Int) -> AnyPublisher<Bool, Error> {
    repository._repository.deleteFromFavorite(from: id)
  }
  
  func isFavorite(id: Int) -> AnyPublisher<Bool, Error> {
    repository._repository.isFavorite(from: id)
  }
  
  
}
