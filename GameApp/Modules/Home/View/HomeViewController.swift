//
//  ViewController.swift
//  GameApp
//
//  Created by Raihan on 15/11/23.
//

import UIKit
import Core
import Game

class HomeViewController: UIViewController {
  
  @IBOutlet weak var emptyView: UIStackView!
  @IBOutlet weak var querySearch: UITextField!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var loading: UIActivityIndicatorView!
  @IBOutlet weak var errorText: UILabel!
  @IBOutlet weak var searchBar: UIView!
  
  private var games: [GameDomainModel] = [] {
    didSet {
      if games.count == 0 {
        emptyView.isHidden = false
      } else {
        emptyView.isHidden = true
      }
    }
  }
  
  private var useCase: HomeUseCase?
  private var presenter: HomePresenter?
  
  let gameUseCase: Interactor<
    Any,
    [GameDomainModel],
    GameDomainDetailModel,
    GetGamesRepository<
      GetGamesLocateDataSource,
      GetGamesRemoteDataSouce,
      GameTransformer>
  > = Injection.init().provideGame()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = HomePresenter(interactor: gameUseCase)
    presenter!.delegate = self
    presenter?.viewDidLoad()
    
    setup()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  
  private func setup() {
    searchBar.layer.cornerRadius = 16
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
    querySearch.delegate = self
  }
  @IBAction func profileButtonTapped(_ sender: Any) {
    navigationController?.isNavigationBarHidden = true
    self.showProfileViewController()
  }
  
  @IBAction func favoriteButtonTapped(_ sender: Any) {
    navigationController?.isNavigationBarHidden = true
    self.showFavoriteViewController()
  }
}

extension HomeViewController: HomePresenterDelegate {
  func didReceiveGames(_ games: [GameDomainModel]) {
    self.games = games
    collectionView.reloadData()
  }
  
  func didFailWithError(_ error: Error) {
    emptyView.isHidden = false
    errorText.text = error.localizedDescription
  }
  
  func updateLoadingState(isLoading: Bool) {
    if isLoading {
      loading.isHidden = false
      loading.startAnimating()
    } else {
      loading.isHidden = true
      loading.stopAnimating()
    }
  }
  
  
}

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return games.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let data = games[indexPath.row]
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
    
    cell.gameName.text = data.name
    cell.gameRate.text = "\(data.rating ?? 0.0)"
    cell.gameRelease.text = data.releaseDate
    
    let imageUrlString = data.gameImage
    if let imageUrl = URL(string: imageUrlString ?? "") {
      
      let session = URLSession.shared
      let task = session.dataTask(with: imageUrl) { (data, _, error) in
        if let error = error {
          print("Error fetching image: \(error.localizedDescription)")
        }
        
        if let imageData = data, let image = UIImage(data: imageData) {
          DispatchQueue.main.async {
            cell.gameImage.image = image
          }
        }
      }
      task.resume()
      
    }
    
    cell.gameBackground.layer.cornerRadius = 8
    cell.gameImage.layer.cornerRadius = 8
    return cell
  }
  
  
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.showDetailViewController(id: games[indexPath.row].id)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = ((view.frame.width - 32) / 2) - 7
    return CGSize( width: width, height: 200)
  }
}


extension HomeViewController: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    let query = textField.text
    presenter!.searchGames(with: query ?? "")
  }
}
