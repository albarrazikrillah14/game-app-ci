//
//  HomePresenter.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation
import Core
import Game
import Combine

protocol HomePresenterDelegate: AnyObject {
  func didReceiveGames(_ games: [GameDomainModel])
  func didFailWithError(_ error: Error)
  func updateLoadingState(isLoading: Bool)
}

class HomePresenter: ObservableObject {
  var cancellables = Set<AnyCancellable>()
  
  private let interactor: Interactor<
    Any,
    [GameDomainModel],
    GameDomainDetailModel,
    GetGamesRepository<
      GetGamesLocateDataSource,
      GetGamesRemoteDataSouce,
      GameTransformer>
  >
  
  weak var delegate: HomePresenterDelegate?
  
  init(interactor: Interactor<
       Any,
       [GameDomainModel],
       GameDomainDetailModel,
       GetGamesRepository<
       GetGamesLocateDataSource,
       GetGamesRemoteDataSouce,
       GameTransformer>
       >) {
    self.interactor = interactor
  }
  
  func viewDidLoad() {
    fetchGames()
  }
  
  func fetchGames() {
    delegate?.updateLoadingState(isLoading: true)
    interactor.execute(request: nil).sink { completion in
      switch completion {
      case .finished:
        self.delegate?.updateLoadingState(isLoading: false)
      case .failure(let error):
        self.delegate?.updateLoadingState(isLoading: false)
        self.delegate?.didFailWithError(error)
      }
    } receiveValue: { data in
      self.delegate?.didReceiveGames(data)
    }.store(in: &cancellables)
  }
  
  func searchGames(with query: String) {
    delegate?.updateLoadingState(isLoading: true)
    interactor._repository.searchGames(query: query).sink { completion in
      switch completion {
      case .finished:
        self.delegate?.updateLoadingState(isLoading: false)
      case .failure(let error):
        self.delegate?.updateLoadingState(isLoading: false)
        self.delegate?.didFailWithError(error)
      }
    } receiveValue: { data in
      self.delegate?.didReceiveGames(data)
    }.store(in: &cancellables)
  }
}
