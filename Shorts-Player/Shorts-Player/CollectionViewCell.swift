//
//  CollectionViewCell.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 16/08/23.
//

import UIKit
import AVFoundation

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    private var avPlayer: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer?
    
    public var videoURL:String = "https://zshorts-dev.zee5.com/zshorts/file2/index.m3u8"
    
    let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        var videoURL:String
        return view
    }()
    
    let volumeMuteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "volumeMute"), for: .selected)
        button.setImage(UIImage(named: "volumeIcon"), for: .normal)
        return button
    }()
    
    let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.notoFont(size: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.notoFont(size: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.notoFont(size: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.notoFont(size: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let dotLabel1: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "•"
        return label
    }()
    
    let dotLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "•"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVideoView()
        setupSubviews()
        setupIconStackView()
        setupChevronButton()
        setupVolumeMuteButton()
        setupIconViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVideoView(){
        contentView.addSubview(videoView)
        videoURL = "https://zshorts-dev.zee5.com/zshorts/file2/index.m3u8"
        if let avAssetURL = URL(string: videoURL) {
            let asset = AVURLAsset(url: avAssetURL)
            let playerItem = AVPlayerItem(asset: asset)
            avPlayer = AVPlayer(playerItem: playerItem)
        }
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        let playerLayerFrame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
        avPlayerLayer?.frame = playerLayerFrame
        avPlayerLayer?.videoGravity = .resizeAspectFill
        avPlayerLayer?.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 0.6)
        avPlayer?.play()
        videoView.layer.addSublayer(avPlayerLayer!)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupSubviews() {
        contentView.addSubview(movieDescriptionLabel)
        
        movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupIconViews() {
        let horizontalStackView = UIStackView(arrangedSubviews: [
            titleLabel, dotLabel1, genreLabel, dotLabel2, ratingLabel
        ])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center // Center-align items
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.spacing = 0 // No spacing between items
        
        contentView.addSubview(horizontalStackView) // Only horizontalStackView is needed
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor, constant: 0), // Adjust the spacing as needed
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -89),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -104)
        ])

            
        let verticalStackView = UIStackView(arrangedSubviews: [
            movieDescriptionLabel, horizontalStackView
        ])
        verticalStackView.axis = .vertical
        //verticalStackView.alignment = .fill
        verticalStackView.spacing = 0 // Adjust the spacing between cells
        verticalStackView.distribution = .fillProportionally
        
        contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 619),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -89),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -104)
        ])
    }

    private func setupVolumeMuteButton() {
        volumeMuteButton.isSelected = avPlayer?.isMuted ?? false
        volumeMuteButton.addTarget(self, action: #selector(unmuteButtonTapped), for: .touchUpInside)
        contentView.addSubview(volumeMuteButton)
        volumeMuteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            volumeMuteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 329),
            volumeMuteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 63),
            volumeMuteButton.widthAnchor.constraint(equalToConstant: 40), // Set width
            volumeMuteButton.heightAnchor.constraint(equalToConstant: 40) // Set height
        ])
    }

    @objc private func unmuteButtonTapped() {
        // Toggle the isSelected state of the button
        volumeMuteButton.isSelected = !volumeMuteButton.isSelected
        
        avPlayer?.isMuted = volumeMuteButton.isSelected

    }


    private func setupChevronButton(){
        let chevronLeftButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "chevronButton"), for: .normal)
           // button.addTarget(self, action: #selector(chevronButtonTapped), for: .touchUpInside)
            return button
        }()
        
        contentView.addSubview(chevronLeftButton)
        chevronLeftButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronLeftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            chevronLeftButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 63),
            chevronLeftButton.widthAnchor.constraint(equalToConstant: 40), // Set width
            chevronLeftButton.heightAnchor.constraint(equalToConstant: 40) // Set height
        ])
    }
    
    private func setupIconStackView() {
        let iconStackView = UIStackView(arrangedSubviews: [watchStackView, myListStackView, shareStackView])
        iconStackView.axis = .vertical
        iconStackView.alignment = .center
        iconStackView.spacing = 10
        
        contentView.addSubview(iconStackView)
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 318),
            iconStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 522)
        ])
    }
    
    private var watchStackView: UIStackView {
        let stackView = UIStackView(arrangedSubviews: [watchButton, watchLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }
    
    private var myListStackView: UIStackView {
        let stackView = UIStackView(arrangedSubviews: [myListButton, myListLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }
    
    private var shareStackView: UIStackView {
        let stackView = UIStackView(arrangedSubviews: [shareButton, shareLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }
    
    private var watchButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "watch"), for: .normal)
        button.setImage(UIImage(named: "onClickWatch"), for: .highlighted)
        button.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)
        return button
    }

    private var myListButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "playlist"), for: .normal)
        button.setImage(UIImage(named: "onClickPlaylist"), for: .highlighted)
        button.addTarget(self, action: #selector(myListButtonTapped), for: .allTouchEvents)
        return button
    }

    private var shareButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.setImage(UIImage(named: "onClickShare"), for: .highlighted)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }

    @objc private func watchButtonTapped() {
        //function to handle watch button
    }

    @objc private func myListButtonTapped() {
        //function body to handle playlistbutton tap
    }

    @objc private func shareButtonTapped() {
        //function body to handle sharebutton tap
    }
    
    private var watchLabel: UILabel {
        let label = UILabel()
        label.text = "Watch"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    private var myListLabel: UILabel {
        let label = UILabel()
        label.text = "My List"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    private var shareLabel: UILabel {
        let label = UILabel()
        label.text = "Share"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    public func configure(with model:Asset){
        movieDescriptionLabel.text = model.assetDetails.description
        titleLabel.text = model.assetDetails.title
        genreLabel.text = "Action"
        ratingLabel.text = "7.0"
        videoURL = model.assetDetails.videoUri.avcUri
        
        if let avAssetURL = URL(string: videoURL) {
            let asset = AVURLAsset(url: avAssetURL)
            let playerItem = AVPlayerItem(asset: asset)
            avPlayer?.replaceCurrentItem(with: playerItem)
            avPlayer?.play() // Play the new video
        }
        volumeMuteButton.isSelected = avPlayer?.isMuted ?? false
    }
}
//"assets": [
//      {
//        "assetDetails": {
//          "id": "0-0-1z5250002",
//          "title": "Vyavastha",
//          "description": "Hebah patel in Vyavastha",
//          "duration": 45,
//          "asset_type": 1,
//          "thumbnails": [
//            {
//              "mainThumbnail": "1920x480-jhgkjhl"
//            }
//          ],
//          "videoUri": {
//            "avcUri": "https://zshorts-dev.zee5.com/zshorts/file1/index.m3u8",
//            "hevcUri": "hevc.m3u8"
//          },
//          "parentAsset": {
//            "id": "0-1-6z581703"
//          },
//          "page": {
//            "cursor": "MTAxNTfxOTQ1tB"
//          }
//        }
//      },
//      ]
