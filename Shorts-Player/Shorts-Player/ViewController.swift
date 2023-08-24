//
//  ViewController.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 16/08/23.
//

import UIKit

struct VideoModel {
    let caption: String
}

let customColor = UIColor(red: 15/255.0, green: 6/255.0, blue: 23/255.0, alpha: 1.0)

class ViewController: UIViewController {
    
    var currentlyPlayingCell: CollectionViewCell?
    
    private var currentlyPlayingCellIndex: Int = 0
    
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
//        layout.sectionInset =
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.
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

        APICaller.shared.fetchVideos { [weak self] items in
            DispatchQueue.main.async {
                self?.assets = items
                self?.collectionView.reloadData()
            }
        }
        collectionView.contentInsetAdjustmentBehavior = .never
//        collectionView.scr
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupTopBar(){
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBottomBar(){
        view.addSubview(bottomBar)
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBar.heightAnchor.constraint(equalToConstant: 50),
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
            collectionView.topAnchor.constraint(equalTo: topBar.bottomAnchor,constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor,constant: -5)
        ])
        
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.minimumLineSpacing = 0
//        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: assets[indexPath.item])
        
        if indexPath.item != currentlyPlayingCellIndex {
            cell.stopVideoPlayback()
        } else {
            cell.startVideoPlayback()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? CollectionViewCell {
            currentlyPlayingCellIndex = indexPath.item
            print("from will display cell func-",indexPath.item)
            videoCell.startVideoPlayback()
        }
        
        // Stop video playback for the cell below the currently displayed cell
        let nextIndexPath = IndexPath(item: indexPath.item + 1, section: .zero)
        if let nextCell = collectionView.cellForItem(at: nextIndexPath) as? CollectionViewCell {
            nextCell.stopVideoPlayback()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? CollectionViewCell {
            videoCell.stopVideoPlayback() 
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func stopVideoPlaybackForNextCell(at indexPath: IndexPath) {
        let nextIndexPath = IndexPath(item: indexPath.item + 1, section: .zero)
        print("inside the stopplayback func called by",indexPath.row)
        // Check if the nextIndexPath is within the bounds of the assets array
        if let nextCell = collectionView.cellForItem(at: nextIndexPath) as? CollectionViewCell {
            // Check if the nextCell is currently visible on the screen
            print("before the visible item contains-",nextIndexPath.row)

            if collectionView.indexPathsForVisibleItems.contains(nextIndexPath) {
                print("stopping video playback at index- ", nextIndexPath)
                nextCell.stopVideoPlayback()
            }
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 3
//    }
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
