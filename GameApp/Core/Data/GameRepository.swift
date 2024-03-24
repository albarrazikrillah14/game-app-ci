//
//  GameRepository.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation

import RxSwift

protocol GameRepositoryProtocol: AnyObject {
  func getGames() -> Observable<[GameModel]>
  func getGameDetail(id: String) -> Observable<DetailModel>
  func searchGames(query: String) -> Observable<[GameModel]>
  func addToFavorite(from id: Int) -> Observable<Bool>
  func deleteFromFavorite(from id: Int) -> Observable<Bool>
  func getAllFavorites() -> Observable<[GameModel]>
  func isFavorite(id: Int) -> Observable<Bool>
}

class GameRepository: NSObject {
  typealias GameInstance = (RemoteDataSource, LocaleDataSource) -> GameRepository
  
  fileprivate let remote: RemoteDataSource
  fileprivate let locale: LocaleDataSource
  
  private init(remote: RemoteDataSource, locale: LocaleDataSource) {
    self.remote = remote
    self.locale = locale
  }
  
  static let sharedInstance: GameInstance = { remoteRepo, localeRepo in
    return GameRepository(remote: remoteRepo, locale: localeRepo)
  }
}

extension GameRepository: GameRepositoryProtocol {
  
  func getGames() -> Observable<[GameModel]> {
    return locale.getGames()
      .flatMapLatest { gameEntity in
        if gameEntity.isEmpty {
          return self.remote.getGames()
            .flatMap { gameResponses in
              let gameEntities = GameMapper.mapGamesResponsesToEntities(input: gameResponses)
              return self.locale.saveGames(from: gameEntities)
                .map { _ in GameMapper.mapGamesEntitiesToDomains(input: gameEntities) }
            }
        } else {
          return Observable.just(GameMapper.mapGamesEntitiesToDomains(input: gameEntity))
        }
      }
  }
  
  
  func getGameDetail(id: String) -> Observable<DetailModel> {
    return remote.getGameDetail(id: id)
      .map { GameMapper.mapGameDetailResponseToDomains(input: $0) }
  }
  
  func searchGames(query: String) -> Observable<[GameModel]> {
    return remote.getGameSearch(query: query)
      .map { GameMapper.mapGamesResponsesToEntities(input: $0) }
      .map { GameMapper.mapGamesEntitiesToDomains(input: $0) }
  }
  
  func addToFavorite(from id: Int) -> Observable<Bool> {
    return locale.addToFavorite(from: id)
  }
  
  func deleteFromFavorite(from id: Int) -> Observable<Bool> {
    return locale.deleteFromFavorite(from: id)
  }
  
  func getAllFavorites() -> Observable<[GameModel]> {
    return locale.getAllFavorites()
      .map { GameMapper.mapGamesEntitiesToDomains(input: $0) }
  }
  
  func isFavorite(id: Int) -> Observable<Bool> {
    return locale.isFavorite(id: id)
  }
}
