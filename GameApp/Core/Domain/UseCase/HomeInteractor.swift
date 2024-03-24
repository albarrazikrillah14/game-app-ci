//
//  HomeInteractor.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation
import RxSwift
import Combine
import Core
import Game

protocol HomeUseCase: AnyObject {
  func getGames() -> AnyPublisher<[GameDomainModel], Error>
  func searchGames(query: String) -> AnyPublisher<[GameDomainModel], Error>
}

class HomeInteractor: HomeUseCase {
  
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
  
  func getGames() -> AnyPublisher<[GameDomainModel], Error> {
    repository.execute(request: nil)
  }
  
  func searchGames(query: String) -> AnyPublisher<[GameDomainModel], Error> {
    repository._repository.searchGames(query: query)
  }
  
}
