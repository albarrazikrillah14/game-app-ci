//
//  RemoteDataSource.swift
//  GameApp
//
//  Created by BEI-Zikri on 02/01/24.
//

import Foundation
import Alamofire
import RxSwift

protocol RemoteDataSourceProtocol: AnyObject {
  func getGames() -> Observable<GameResponse>
  func getGameDetail(id: String) -> Observable<GameDetailResponse>
  func getGameSearch(query: String) -> Observable<GameResponse>
}

final class RemoteDataSource: NSObject {
  private override init() { }
  static let sharedInstance: RemoteDataSource = RemoteDataSource()
}

extension RemoteDataSource: RemoteDataSourceProtocol {
  
  func getGames() -> Observable<GameResponse> {
    return Observable<GameResponse>.create { observer in
      
      if let url = URL(string: Endpoints.Gets.games.url) {
        let parameters: Parameters = ["key": API.apiKeys]
        
        AF.request(url, parameters: parameters)
          .validate()
          .responseDecodable(of: GameResponse.self) { response in
            switch response.result {
            case .success(let value):
              observer.onNext(value)
              observer.onCompleted()
            case .failure:
              observer.onError(URLError.invalidResponse)
            }
          }
      }
      return Disposables.create()
    }
  }
  
  func getGameDetail(id: String) -> Observable<GameDetailResponse> {
    return Observable<GameDetailResponse>.create { observer in
      
      if let url = URL(string: Endpoints.Gets.detail(id).url) {
        let parameters: Parameters = ["key": API.apiKeys]
        
        AF.request(url, parameters: parameters)
          .validate()
          .responseDecodable(of: GameDetailResponse.self) { response in
            switch response.result {
            case .success(let value):
              observer.onNext(value)
              observer.onCompleted()
            case .failure:
              observer.onError(URLError.invalidResponse)
            }
          }
      }
      return Disposables.create()
    }
  }
  
  func getGameSearch(query: String) -> Observable<GameResponse> {
    return Observable<GameResponse>.create { observer in
      if let url = URL(string: Endpoints.Gets.search.url) {
        let parameters: Parameters = [
          "key": API.apiKeys,
          "search": query
        ]
        
        AF.request(url, parameters: parameters)
          .validate()
          .responseDecodable(of: GameResponse.self) { response in
            switch response.result {
            case .success(let value):
              observer.onNext(value)
              observer.onCompleted()
            case .failure:
              observer.onError(URLError.invalidResponse)
            }
          }
      }
      return Disposables.create()
    }
  }
}
