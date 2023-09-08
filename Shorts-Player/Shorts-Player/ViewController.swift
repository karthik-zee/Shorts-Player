//
//  ViewController.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 16/08/23.
//

import UIKit
import CoreData
import AVFoundation

struct VideoModel {
    let caption: String
}

let customColor = UIColor(red: 0.059, green: 0.0235, blue: 0.09, alpha: 1.0)

class ViewController: UIViewController {
    private var isGlobalMute: Bool = false
    var currentlyPlayingCell: CollectionViewCell?
    private var topBarHeight: CGFloat = 50
    private var bottomBarHeight: CGFloat = 50
    private var currentlyPlayingCellIndex: Int = 0
    private var urlString = "https://zshorts-dev.zee5.com/v1/zShorts"
    private let volumeMute = "volumeMute"
    private let volumeIcon = "volumeIcon"
    private let chevronButton = "chevronButton"
    private let topIconsHeight: CGFloat = 40
    private let topIconsWidth: CGFloat = 40
    private let volumeButtonTrailingConstraint: CGFloat = -24
    private let volumeButtonTopConstraint: CGFloat = 66
    private let chevronButtonLeadingConstraint: CGFloat = 16
    private let chevronButtonTopContraint: CGFloat = 66
    
    var assets: [Asset] = [Asset]()
    
    private var topBar:UIView = {
        let view = UIView()
        view.backgroundColor = customColor
        return view
    }()
    
    private var bottomBar:UIView = {
        let view = UIView()
        view.backgroundColor = customColor
        return view
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBar()
        setupBottomBar()
        setupCollectionView()
        setupVolumeMuteButton()
        setupChevronButton()
        
        APICaller.shared.fetchVideos(with: urlString) { [weak self] items in
            DispatchQueue.main.async {
                self?.assets = items
                self?.collectionView.reloadData()
            }
        }
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupTopBar(){
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: topBarHeight)
        ])
    }
    
    private func setupBottomBar(){
        view.addSubview(bottomBar)
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBar.heightAnchor.constraint(equalToConstant: bottomBarHeight),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor)
        ])
    }
    
    lazy var volumeMuteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: volumeIcon), for: .normal)
        button.setImage(UIImage(named: volumeMute), for: .selected)
        return button
    }()
    
    
    private func setupVolumeMuteButton() {
        volumeMuteButton.addTarget(self, action: #selector(unmuteButtonTapped), for: .touchUpInside)
        view.addSubview(volumeMuteButton)
        volumeMuteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            volumeMuteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: volumeButtonTrailingConstraint),
            volumeMuteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: volumeButtonTopConstraint),
            volumeMuteButton.widthAnchor.constraint(equalToConstant: topIconsWidth), // Set width
            volumeMuteButton.heightAnchor.constraint(equalToConstant: topIconsHeight) // Set height
        ])
    }
    
    private func setupChevronButton(){
        let chevronLeftButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: chevronButton), for: .normal)
            button.addTarget(self, action: #selector(chevronButtonTapped), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(chevronLeftButton)
        chevronLeftButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronLeftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: chevronButtonLeadingConstraint),
            chevronLeftButton.topAnchor.constraint(equalTo: view.topAnchor, constant: chevronButtonTopContraint),
            chevronLeftButton.widthAnchor.constraint(equalToConstant: topIconsWidth), // Set width
            chevronLeftButton.heightAnchor.constraint(equalToConstant: topIconsHeight) // Set height
        ])
    }
    
    @objc private func unmuteButtonTapped() {
        if !volumeMuteButton.isSelected {
            isGlobalMute = true
            volumeMuteButton.isSelected = true
        }
        else{
            isGlobalMute = false
            volumeMuteButton.isSelected = false
        }
        NotificationCenter.default.post(name: Notification.Name("MuteStateChanged"), object: nil , userInfo: ["isMuted" : isGlobalMute])
    }
    
    @objc private func chevronButtonTapped(){
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.myListDelegate = self
        cell.shareDelegate = self
        cell.configure(with: assets[indexPath.item])
        if indexPath.item != currentlyPlayingCellIndex {
            cell.stopVideoPlayback(with: isGlobalMute)
        } else {
            cell.startVideoPlayback(with: isGlobalMute)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let videoCell = cell as? CollectionViewCell {
            currentlyPlayingCellIndex = indexPath.item
            print(assets[indexPath.item].assetDetails.id)
            DispatchQueue.main.async {
                videoCell.startVideoPlayback(with: self.isGlobalMute)
                videoCell.isAddedToWatchlist()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? CollectionViewCell {
            videoCell.stopVideoPlayback(with: isGlobalMute)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func stopVideoPlaybackForNextCell(at indexPath: IndexPath) {
        let nextIndexPath = IndexPath(item: indexPath.item + 1, section: .zero)
        // Check if the nextIndexPath is within the bounds of the assets array
        if let nextCell = collectionView.cellForItem(at: nextIndexPath) as? CollectionViewCell {
            // Check if the nextCell is currently visible on the screen
            if collectionView.indexPathsForVisibleItems.contains(nextIndexPath) {
                nextCell.stopVideoPlayback(with: isGlobalMute)
            }
        }
    }
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellHeight = collectionView.bounds.height
        let offset = targetContentOffset.pointee.y
        let currentIndex = round(offset / cellHeight)
        let newIndex = min(max(0, currentIndex), CGFloat(assets.count - 1))
        let adjustedOffset = newIndex * cellHeight
        targetContentOffset.pointee.y = adjustedOffset
    }
}

extension ViewController: MyListDelegates {
    func didToggleMyListButton(id: String, completion: @escaping (Bool) -> Void) {
        let result = addToWatchlist(id: id)
        completion(result)
    }
    
    func checkItemInWatchlist(id: String, completion: @escaping (Bool) -> Void) {
        let result = isAddedToWatchlist(id: id)
        completion(result)
    }
}

extension ViewController {
    func addToWatchlist(id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        var isAdded = false
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let movies = try managedContext.fetch(fetchRequest)
            if let movie = movies.first {
                managedContext.delete(movie)
                try managedContext.save()
                isAdded = false
            } else {
                let movie = MovieEntity(context: managedContext)
                movie.id = id
                movie.isAddedToWatchlist = true
                try managedContext.save()
                isAdded = true
                print("Newly Added Movie - ID: \(movie.id ?? ""), isAddedToWatchlist: \(isAdded)")
            }
            
            let allMoviesFetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            let allMovies = try managedContext.fetch(allMoviesFetchRequest)
            
            // Print details of all the MovieEntity objects
            for movie in allMovies {
                print("Movie - ID: \(movie.id ?? ""), isAddedToWatchlist: \(movie.isAddedToWatchlist)")
            }
            
        } catch let error as NSError {
            print("Could not update movie: \(error)")
        }
        return isAdded
    }
    
    func isAddedToWatchlist(id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        var isAdded = false
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let movies = try managedContext.count(for: fetchRequest)
            if movies > 0 {
                isAdded = true
            }
            else {
                isAdded = false
            }
        } catch {
            print("failed")
        }
        return isAdded
    }
}

extension ViewController: ShareDelegate {
    func presentShareSheet(videoURL: String, button: UIButton) {
        let activityViewController = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = button
        self.present(activityViewController, animated: true, completion: nil)
    }
}
