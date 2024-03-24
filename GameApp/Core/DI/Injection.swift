//
//  Injection.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation
import RealmSwift
import Core
import Game
import UIKit

final class Injection: NSObject {
  
  private let realm = try? Realm()
  
  func provideGame<U: UseCase>() -> U where U.Request == Any, U.Response == [GameDomainModel], U.ResponseDetail == GameDomainDetailModel {
    
    let locale = GetGamesLocateDataSource(_realm: realm!)
    let remote = GetGamesRemoteDataSouce()
    let mapper = GameTransformer()
    
    let repository = GetGamesRepository(
      localeDataSource: locale,
      remoteDataSource: remote,
      mapper: mapper
    )

    return Interactor(_repository: repository) as! U
  }
  
  
  private func provideRepository() -> GameRepositoryProtocol {
    let realm = try? Realm()
    let locale: LocaleDataSource = LocaleDataSource.sharedInstance(realm)
    let remote: RemoteDataSource = RemoteDataSource.sharedInstance
    return GameRepository.sharedInstance(remote, locale)
  }
  
  func provideHome() -> HomeUseCase {
    return HomeInteractor(repository: provideGame())
  }
  
  func provideDetail() -> DetailUseCase {
    return DetailInteractor(repository: provideGame())
  }
  
  func provideFavorite() -> FavoriteUseCase {
    return FavoriteInteractor(repository: provideGame())
  }
  
}
