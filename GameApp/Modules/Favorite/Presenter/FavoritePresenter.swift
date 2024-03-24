//
//  FavoritePresenter.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//
import Foundation
import Combine
import Core
import Game

protocol FavoritePresenterDelegate: AnyObject {
  func didReceiveFavoriteGames(_ games: [GameDomainModel])
  func didFailWithError(_ error: Error)
  func updateLoadingState(isLoading: Bool)
}

class FavoritePresenter {
  private var cancellables = Set<AnyCancellable>()
  
  private let interactor: FavoriteUseCase
  weak var delegate: FavoritePresenterDelegate?
  
  init(interactor: FavoriteUseCase) {
    self.interactor = interactor
  }
  
  func viewDidLoad() {
    fetchFavoriteGames()
  }
  
  private func fetchFavoriteGames() {
    delegate?.updateLoadingState(isLoading: true)
    interactor.getAllFavoriteGame()
      .sink { completion in
        switch completion {
        case .finished:
          self.delegate?.updateLoadingState(isLoading: false)
        case .failure(let error):
          self.delegate?.updateLoadingState(isLoading: false)
          self.delegate?.didFailWithError(error)
        }
      } receiveValue: { data in
        self.delegate?.didReceiveFavoriteGames(data)
        self.delegate?.updateLoadingState(isLoading: false)
      }.store(in: &cancellables)
    
  }
}
