import UIKit
import Core
import Game

class FavoriteViewController: UIViewController {
  @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
  
  private var games: [GameDomainModel] = [] {
    didSet {
      collectionView.reloadData()
      emptyView.isHidden = !games.isEmpty
    }
  }
  
  private var useCase: FavoriteUseCase?
  private var presenter: FavoritePresenter?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    useCase = Injection.init().provideFavorite()
    presenter = FavoritePresenter(interactor: useCase!)
    presenter?.delegate = self
    presenter?.viewDidLoad()
    
    setupCollectionView()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    presenter?.viewDidLoad()
  }
  
  func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellWithReuseIdentifier: "FavoriteCell")
  }
  
  
  @IBAction func backButtonTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

extension FavoriteViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return games.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let data = games[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
    
    cell.contentView.layer.cornerRadius = 8
    cell.favoriteName.text = data.name
    cell.favoriteRate.text = "\(data.rating ?? 0.0)"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: data.releaseDate ?? "")
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "MMM, d YYYY"
    cell.favoriteReleaseDate.text = dateFormatter1.string(from: date ?? Date())
    
    
    let imageUrlString = data.gameImage
    if let imageUrl = URL(string: imageUrlString ?? "") {
      
      let session = URLSession.shared
      let task = session.dataTask(with: imageUrl) { (data, _, error) in
        if let error = error {
          print("Error fetching image: \(error.localizedDescription)")
        }
        
        if let imageData = data, let image = UIImage(data: imageData) {
          DispatchQueue.main.async {
            cell.favoriteImage.image = image
          }
        }
      }
      task.resume()
      
    }
    
    
    return cell
  }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    navigationController?.isNavigationBarHidden = true
    showDetailViewController(id: games[indexPath.row].id)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width
    return CGSize(width: width, height: 100)
  }
}


extension FavoriteViewController: FavoritePresenterDelegate {
  func didReceiveFavoriteGames(_ games: [GameDomainModel]) {
    self.games = games
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
  func showFavoriteViewController() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "favorite") as! FavoriteViewController
    
    navigationController?.pushViewController(viewController, animated: true)
  }
}
