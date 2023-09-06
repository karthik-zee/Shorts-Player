//
//  CollectionViewCell.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 16/08/23.
//

import UIKit
import AVFoundation
import CoreData

protocol muteUnmuteDelegate:AnyObject {
    func didToggleMuteState(for cell: CollectionViewCell)
}

protocol myListButtonTapped: AnyObject {
    func didToggleMyListButton(id: String,completion: @escaping (Bool) -> Void)
    func checkItemInWatchlist(id: String,completion: @escaping (Bool) -> Void)
}

class CollectionViewCell: UICollectionViewCell {
    weak var delegate: muteUnmuteDelegate?
    weak var myListDelegate: myListButtonTapped?
    var model: Asset?
    
    var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                avPlayer?.play()
            } else {
                avPlayer?.pause()
            }
        }
    }
    
    static let identifier = "CollectionViewCell"
    
    public var videoURL:String = "https://zshorts-dev.zee5.com/zshorts/file2/index.m3u8"
    
    private var progressIndicatorWidthConstraint: NSLayoutConstraint?
    private var avPlayer: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer?
    private let volumeMute = "volumeMute"
    private let volumeIcon = "volumeIcon"
    private let playButton = "playButton"
    private let chevronButton = "chevronButton"
    private let watch = "watch"
    private let onClickWatch = "onClickWatch"
    private let playlist = "playlist"
    private let onClickPlaylist = "onClickPlaylist"
    private let share = "share"
    private let onClickShare = "onClickShare"
    private let addedToWatchlist = "addedToWatchlist"
    
    lazy var watchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [watchButton, watchLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    lazy var myListStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [myListButton, myListLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    lazy var shareStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shareButton, shareLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    lazy var watchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: watch), for: .normal)
        button.setImage(UIImage(named: onClickWatch), for: .highlighted)
        button.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var myListButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: playlist), for: .normal)
        button.setImage(UIImage(named: addedToWatchlist), for: .selected)
        button.addTarget(self, action: #selector(myListButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: share), for: .normal)
        button.setImage(UIImage(named: onClickShare), for: .highlighted)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var watchLabel: UILabel = {
        let label = UILabel()
        label.text = "Watch"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var myListLabel: UILabel = {
        let label = UILabel()
        label.text = "My List"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var shareLabel: UILabel = {
        let label = UILabel()
        label.text = "Share"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var playButtonOverlay: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: playButton))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var progressIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.655, green: 0.522, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        var videoURL:String
        return view
    }()
    
    lazy var volumeMuteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: volumeMute), for: .selected)
        button.setImage(UIImage(named: volumeIcon), for: .normal)
        return button
    }()
    
    lazy var movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.notoFont(size: 14, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.notoFont(size: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.notoFont(size: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.notoFont(size: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var dotLabel1: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "•"
        return label
    }()
    
    lazy var dotLabel2: UILabel = {
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
        setupProgressIndicator()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avPlayer?.pause()
        playButtonOverlay.isHidden = true
        avPlayer?.seek(to: .zero)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        // Check if the tap is outside of existing buttons and stack views
        if touches.first?.view == contentView {
            togglePlayButtonOverlay()
            togglePlayPauseVideo()
        }
    }
    
    func stopVideoPlayback(with isMuted: Bool) {
        if isMuted {
            avPlayer?.isMuted = true
            volumeMuteButton.setImage(UIImage(named: "volumeMute"), for: .normal)
        } else {
            volumeMuteButton.setImage(UIImage(named: "volumeIcon"), for: .normal)
        }
        avPlayer?.pause()
    }
    
    func startVideoPlayback(with isMuted: Bool) {
        DispatchQueue.main.async {
            if isMuted {
                self.avPlayer?.isMuted = true
                self.volumeMuteButton.setImage(UIImage(named: "volumeMute"), for: .normal)
            } else {
                self.avPlayer?.isMuted = false
                self.volumeMuteButton.setImage(UIImage(named: "volumeIcon"), for: .normal)
            }
        }
        playButtonOverlay.isHidden = true
        // seek to zero if the cell has to be played from start again from will display method
        avPlayer?.seek(to: .zero)
        avPlayer?.play()
    }
    
    private func togglePlayButtonOverlay() {
        playButtonOverlay.isHidden.toggle()
    }
    
    private func togglePlayPauseVideo() {
        if let avPlayer = avPlayer {
            if avPlayer.rate == 0 { // Video is paused
                avPlayer.play()
            } else { // Video is playing
                avPlayer.pause()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProgressIndicator(){
        contentView.addSubview(progressIndicator)
        
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            progressIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progressIndicator.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        progressIndicatorWidthConstraint = progressIndicator.widthAnchor.constraint(equalToConstant: 0)
        progressIndicatorWidthConstraint?.isActive = true
        
        // Add observer for AVPlayer's currentTime
        avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let duration = self?.avPlayer?.currentItem?.duration.seconds, duration > 0 else {
                return
            }
            let currentTime = time.seconds
            let progress = currentTime / duration
            DispatchQueue.main.async {
                self?.updateProgressIndicator(progress: progress)
            }
        }
    }
    
    private func updateProgressIndicator(progress: Double) {
        let maxWidth = contentView.bounds.width
        let newWidth = maxWidth * CGFloat(progress)
        self.progressIndicatorWidthConstraint?.constant = newWidth
    }
    
    private func setupVideoView(){
        contentView.addSubview(videoView)
        contentView.addSubview(playButtonOverlay)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped))
        videoView.addGestureRecognizer(tapGesture)
        
        videoURL = "https://zshorts-dev.zee5.com/zshorts/file2/index.m3u8"
        if let avAssetURL = URL(string: videoURL) {
            let asset = AVURLAsset(url: avAssetURL)
            let playerItem = AVPlayerItem(asset: asset)
            avPlayer = AVPlayer(playerItem: playerItem)
        }
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.frame = contentView.bounds
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
        
        playButtonOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Constraints to center the play button overlay
            playButtonOverlay.centerXAnchor.constraint(equalTo: videoView.centerXAnchor),
            playButtonOverlay.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            playButtonOverlay.widthAnchor.constraint(equalToConstant: 60), // Set width
            playButtonOverlay.heightAnchor.constraint(equalToConstant: 60) // Set height
        ])
    }
    
    private func setupSubviews() {
        contentView.addSubview(movieDescriptionLabel)
    }
    
    private func setupIconViews() {
        let horizontalStackView = UIStackView(arrangedSubviews: [
            titleLabel, dotLabel1, genreLabel, dotLabel2, ratingLabel
        ])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .leading
        horizontalStackView.distribution = .equalCentering
        horizontalStackView.spacing = 0 // No spacing between items
        
        contentView.addSubview(horizontalStackView) // Only horizontalStackView is needed
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor, constant: 15), // Adjust the spacing as needed
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -89),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -104)
        ])
        
        
        let verticalStackView = UIStackView(arrangedSubviews: [
            movieDescriptionLabel, horizontalStackView
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 0 // Adjust the spacing between cells
        verticalStackView.distribution = .fillEqually
        
        contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -89),
        ])
    }
    
    private func setupVolumeMuteButton() {
        volumeMuteButton.isSelected = avPlayer?.isMuted ?? false
        volumeMuteButton.addTarget(self, action: #selector(unmuteButtonTapped), for: .touchUpInside)
        contentView.addSubview(volumeMuteButton)
        volumeMuteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            volumeMuteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            volumeMuteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            volumeMuteButton.widthAnchor.constraint(equalToConstant: 40), // Set width
            volumeMuteButton.heightAnchor.constraint(equalToConstant: 40) // Set height
        ])
    }
    
    private func setupChevronButton(){
        let chevronLeftButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: chevronButton), for: .normal)
            button.addTarget(self, action: #selector(chevronButtonTapped), for: .touchUpInside)
            return button
        }()
        
        contentView.addSubview(chevronLeftButton)
        chevronLeftButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronLeftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            chevronLeftButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
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
            iconStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            iconStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28)
        ])
    }
    
    @objc private func watchButtonTapped() {
        //function to handle watch button
    }
    
    @objc private func myListButtonTapped() {
        print("inside mylist button tapped  @objc func")
        if let model = self.model{
            print("model",model)
            myListDelegate?.didToggleMyListButton(id: model.assetDetails.id) { success in
                if success {
                    self.myListButton.isSelected = true
                }
                else {
                    self.myListButton.isSelected = false
                }
            }
        }
    }
    
    @objc private func shareButtonTapped() {
        guard let parentViewController = findParentViewController() else {
            return
        }
        guard let image = UIImage(systemName: "bell") , let url = URL(string: "https://www.google.com") else {return }
        let shareSheetVC = UIActivityViewController(
            activityItems: [
                image,
                url,
                //whatsAppUrl
            ],
            applicationActivities: nil
        )
        parentViewController.present(shareSheetVC, animated: true)
    }
    
    private func findParentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            parentResponder = responder.next
        }
        return nil
    }
    
    @objc private func unmuteButtonTapped() {
        if volumeMuteButton.currentImage == UIImage(named: volumeIcon) {
            avPlayer?.isMuted = true
            DispatchQueue.main.async {
                self.volumeMuteButton.setImage(UIImage(named: self.volumeMute), for: .normal)
            }
            delegate?.didToggleMuteState(for: self)
        }
        else{
            avPlayer?.isMuted = false
            DispatchQueue.main.async {
                self.volumeMuteButton.setImage(UIImage(named: self.volumeIcon), for: .normal)
            }
            delegate?.didToggleMuteState(for: self)
        }
    }
    
    @objc private func videoViewTapped() {
        togglePlayButtonOverlay()
        togglePlayPauseVideo()
    }
    
    @objc private func chevronButtonTapped(){
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
    
    func isAddedToWatchlist() {
        if let model = self.model{
            myListDelegate?.checkItemInWatchlist(id: model.assetDetails.id) { success in
                if success {
                    self.myListButton.isSelected = true
                }
                else {
                    self.myListButton.isSelected = false
                }
            }
        }
    }
    
    public func configure(with model:Asset){
        movieDescriptionLabel.text = model.assetDetails.description
        titleLabel.text = model.assetDetails.title
        genreLabel.text = "Action"
        ratingLabel.text = "7.0"
        videoURL = model.assetDetails.videoUri.avcUri
        playButtonOverlay.isHidden = true
        self.model = model
        if let avAssetURL = URL(string: videoURL) {
            let asset = AVURLAsset(url: avAssetURL)
            let playerItem = AVPlayerItem(asset: asset)
            avPlayer?.replaceCurrentItem(with: playerItem)
            avPlayer?.play() // Play the new video
            if avPlayer?.isMuted == true {
                volumeMuteButton.setImage(UIImage(named: volumeMute), for: .normal)
            } else {
                volumeMuteButton.setImage(UIImage(named: volumeIcon), for: .normal)
            }
        }
    }
}

