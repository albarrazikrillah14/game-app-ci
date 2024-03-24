//
//  DetailPresenter.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation
import Core
import Game
import Combine


protocol DetailPresenterDelegate: AnyObject {
  func didReceiveGameDetail(_ gameDetail: GameDomainDetailModel)
  func didUpdateFavoriteStatus(isFavorite: Bool)
  func didFailWithError(_ error: Error)
  func updateLoadingState(isLoading: Bool)
}

class DetailPresenter {
  
  private let interactor: Interactor<
    Any,
    [GameDomainModel],
    GameDomainDetailModel,
    GetGamesRepository<
      GetGamesLocateDataSource,
      GetGamesRemoteDataSouce,
      GameTransformer>
  >
  
  private var gameId: Int
  weak var delegate: DetailPresenterDelegate?
  private var gameDetail: GameDomainDetailModel?
  var isFavorite: Bool?
  
  var cancellables = Set<AnyCancellable>()


  init(interactor: Interactor<
       Any,
       [GameDomainModel],
       GameDomainDetailModel,
       GetGamesRepository<
         GetGamesLocateDataSource,
         GetGamesRemoteDataSouce,
         GameTransformer>
     >, gameId: Int) {
    self.interactor = interactor
    self.gameId = gameId
  }
  
  func viewDidLoad() {
    delegate?.updateLoadingState(isLoading: true)
    interactor._repository.isFavorite(from: gameId)
      .sink { completion in
        switch completion {
        case .finished:
          self.delegate?.updateLoadingState(isLoading: false)
        case .failure(let error):
          self.delegate?.didFailWithError(error)
          self.delegate?.updateLoadingState(isLoading: false)
        }
      } receiveValue: { data in
        self.delegate?.updateLoadingState(isLoading: false)
        self.isFavorite = data
      }.store(in: &cancellables)
    
    fetchGameDetail()
  }
  
  private func fetchGameDetail() {
    delegate?.updateLoadingState(isLoading: true)
    interactor._repository.getGameDetail(id: "\(gameId)")
      .sink { completion in
        switch completion {
        case .finished:
          self.delegate?.updateLoadingState(isLoading: false)
        case .failure(let error):
          self.delegate?.didFailWithError(error)
          self.delegate?.updateLoadingState(isLoading: false)
        }
      } receiveValue: { data in
        self.gameDetail = data
        self.delegate?.didReceiveGameDetail(data)
      }.store(in: &cancellables)

    
  }
  
  func toggleFavoriteStatus() {
    if isFavorite ?? false {
      deleteFromFavorite()
    } else {
      addToFavorite()
    }
  }
  
  private func addToFavorite() {
    interactor._repository.addToFavorite(from: gameId)
      .sink { completion in
        switch completion {
        case .finished:
          self.delegate?.updateLoadingState(isLoading: false)
        case .failure(let error):
          self.delegate?.didFailWithError(error)
          self.delegate?.updateLoadingState(isLoading: false)
        }
      } receiveValue: { data in
        self.isFavorite = true
        self.delegate?.didUpdateFavoriteStatus(isFavorite: true)
      }.store(in: &cancellables)

  }
  
  private func deleteFromFavorite() {
    interactor._repository.deleteFromFavorite(from: gameId)
      .sink { completion in
        switch completion {
        case .finished:
          self.delegate?.updateLoadingState(isLoading: false)
        case .failure(let error):
          self.delegate?.didFailWithError(error)
          self.delegate?.updateLoadingState(isLoading: false)
        }
      } receiveValue: { data in
        self.isFavorite = false
        self.delegate?.didUpdateFavoriteStatus(isFavorite: false)
      }.store(in: &cancellables)
  }
}
