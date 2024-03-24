//
//  GameProvider.swift
//  GameApp
//
//  Created by Raihan on 18/11/23.
//
import Foundation
import RealmSwift
import RxSwift

protocol LocaleDataSourceProtocol: AnyObject {
  func getGames() -> Observable<[GameEntity]>
  func saveGames(from games: [GameEntity]) -> Observable<Bool>
  func addToFavorite(from id: Int) -> Observable<Bool>
  func deleteFromFavorite(from id: Int) -> Observable<Bool>
  func getAllFavorites() -> Observable<[GameEntity]>
  func isFavorite(id: Int) -> Observable<Bool>
}

final class LocaleDataSource: NSObject {
  private let realm: Realm?
  
  private init(realm: Realm?) {
    self.realm = realm
  }
  
  static let sharedInstance: (Realm?) -> LocaleDataSource = {
    realmDatabase in return LocaleDataSource(realm: realmDatabase)
  }
}

extension LocaleDataSource: LocaleDataSourceProtocol {
  func getGames() -> Observable<[GameEntity]> {
    return Observable.create { observer in
      if let realm = self.realm {
        let games: Results<GameEntity> = realm.objects(GameEntity.self)
          .sorted(byKeyPath: "name", ascending: true)
        observer.onNext(games.toArray(ofType: GameEntity.self))
        observer.onCompleted()
      } else {
        observer.onError(DatabaseError.invalidInstance)
      }
      return Disposables.create()
    }
  }
  
  func saveGames(from games: [GameEntity]) -> Observable<Bool> {
    return Observable.create { observer in
      if let realm = self.realm {
        do {
          try realm.write {
            realm.add(games, update: .all)
            observer.onNext(true)
            observer.onCompleted()
          }
        } catch {
          observer.onError(DatabaseError.requestFailed)
        }
      } else {
        observer.onError(DatabaseError.invalidInstance)
      }
      return Disposables.create()
    }
  }
  
  func addToFavorite(from id: Int) -> Observable<Bool> {
    return Observable.create { observer in
      if let realm = self.realm, let game = realm.object(ofType: GameEntity.self, forPrimaryKey: id) {
        do {
          try realm.write {
            game.isFavorite = true
            realm.add(game, update: .modified)
            observer.onNext(true)
            observer.onCompleted()
          }
        } catch {
          observer.onError(DatabaseError.requestFailed)
        }
      } else {
        observer.onError(DatabaseError.invalidInstance)
      }
      return Disposables.create()
    }
  }
  
  func deleteFromFavorite(from id: Int) -> Observable<Bool> {
    return Observable.create { observer in
      if let realm = self.realm, let game = realm.object(ofType: GameEntity.self, forPrimaryKey: id) {
        do {
          try realm.write {
            game.isFavorite = false
            realm.add(game, update: .modified)
            observer.onNext(true)
            observer.onCompleted()
          }
        } catch {
          observer.onError(DatabaseError.requestFailed)
        }
      } else {
        observer.onError(DatabaseError.invalidInstance)
      }
      return Disposables.create()
    }
  }
  
  func getAllFavorites() -> Observable<[GameEntity]> {
    return Observable.create { observer in
      if let realm = self.realm {
        let favorites = realm.objects(GameEntity.self)
          .filter("isFavorite == true")
          .sorted(byKeyPath: "name", ascending: true)
        observer.onNext(favorites.toArray(ofType: GameEntity.self))
        observer.onCompleted()
      } else {
        observer.onError(DatabaseError.invalidInstance)
      }
      return Disposables.create()
    }
  }
  
  func isFavorite(id: Int) -> Observable<Bool> {
    return Observable.create { observer in
      if let realm = self.realm {
        let game = realm.object(ofType: GameEntity.self, forPrimaryKey: id)
        let isFavorite = game?.isFavorite ?? false
        observer.onNext(isFavorite)
        observer.onCompleted()
      } else {
        observer.onError(DatabaseError.invalidInstance)
      }
      return Disposables.create()
    }
  }
}

extension Results {
  func toArray<T>(ofType: T.Type) -> [T] {
    return compactMap { $0 as? T }
  }
}
