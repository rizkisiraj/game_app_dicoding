//
//  ViewController.swift
//  GameApp
//
//  Created by Rizki Siraj on 29/04/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    private var games: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        gameCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
          await getGames()
        }
      }
    
    func getGames() async {
        let network = NetworkService()
        do {
          games = try await network.getGames()
          gameCollectionView.reloadData()
        } catch {
          fatalError("Error: connection failed.")
        }
      }


}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as? GameCollectionViewCell {
            
            let game = games[indexPath.row]
            
            cell.setup(with: game)
            if game.state == .new {
                startDownload(game: game, indexPath: indexPath)
            }
        
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func startDownload(game: Game, indexPath: IndexPath) {
        let imageDownloader = ImageDownloader()
        if game.state == .new {
          Task {
            do {
                let image = try await imageDownloader.downloadImage(url: game.imagePath)
                game.state = .downloaded
                game.image = image
                self.gameCollectionView.reloadItems(at: [indexPath])
            } catch {
              game.state = .failed
              game.image = nil
            }
          }
        }
      }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = gameCollectionView.bounds.width
        return CGSize(width: collectionViewWidth, height: 200)
    }
}

