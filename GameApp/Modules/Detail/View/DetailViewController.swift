//
//  DetailViewController.swift
//  GameApp
//
//  Created by Raihan on 15/11/23.
//

import UIKit
import Core
import Game
import Combine

class DetailViewController: UIViewController {
  
  @IBOutlet weak var nav: UINavigationItem!
  @IBOutlet weak var loading: UIActivityIndicatorView!
  @IBOutlet weak var detailDescription: UILabel!
  @IBOutlet weak var detailDate: UILabel!
  @IBOutlet weak var detailRate: UILabel!
  @IBOutlet weak var detailName: UILabel!
  @IBOutlet weak var favoriteButton: UIBarButtonItem!
  @IBOutlet weak var detailImage: UIImageView!
  @IBOutlet weak var backgroundView: UIView!
  
  var id: Int = 0
  private var data: GameDomainDetailModel?
  
  private var useCase: DetailUseCase?
  private var presenter: DetailPresenter?
  
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
  
    presenter = DetailPresenter(interactor: gameUseCase, gameId: id)
    presenter?.delegate = self
    presenter?.viewDidLoad()
    setup()
  }
  
  func setupData() {
    nav.title = self.data!.name.uppercased()
    detailName.text = self.data!.name
    detailRate.text = "\(data!.rating)"
    detailDescription.text = data!.description
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: data?.released ?? "")
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "MMM, d YYYY"
    detailDate.text = dateFormatter1.string(from: date ?? Date())
    
    let imageUrlString = data?.backgroundImage ?? ""
    if let imageUrl = URL(string: imageUrlString) {
      
      let session = URLSession.shared
      let task = session.dataTask(with: imageUrl) { [weak self] (data, _, error) in
        if let error = error {
          print("Error fetching image: \(error.localizedDescription)")
        }
        
        if let imageData = data, let image = UIImage(data: imageData) {
          DispatchQueue.main.async { [weak self] in
            self!.detailImage.image = image
          }
        }
      }
      task.resume()
      
    }
  }
  func setup() {
    backgroundView.layer.cornerRadius = 16
    detailImage.layer.cornerRadius = 16
    
  }
  
  @IBAction func backButtonTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func favoriteButtonTapped(_ sender: Any) {
    presenter?.toggleFavoriteStatus()
  }
  
  func updateFavoriteButtonAppearance() {
    if self.presenter!.isFavorite ?? false {
      self.favoriteButton.image = UIImage(named: "like")
    } else {
      self.favoriteButton.image = UIImage(systemName: "heart")
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.isNavigationBarHidden = true
  }
}

extension DetailViewController: DetailPresenterDelegate {
  func didReceiveGameDetail(_ gameDetail: GameDomainDetailModel) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.data = gameDetail
      self.updateFavoriteButtonAppearance()
      self.setupData()
    }
  }
  
  
  func didUpdateFavoriteStatus(isFavorite: Bool) {
    DispatchQueue.main.async { [weak self] in
      self?.updateFavoriteButtonAppearance()
    }
  }
  
  
  func didFailWithError(_ error: Error) {
    print("\(error)")
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

extension UIViewController {
  func showDetailViewController(id: Int) {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "detail") as! DetailViewController
    viewController.id = id
    
    navigationController?.pushViewController(viewController, animated: true)
  }
}
