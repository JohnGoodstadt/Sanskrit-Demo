//
//  LearnUIKitViewController.swift
//  Udemy Chants
//
//  Created by John goodstadt on 10/11/2021.
//  Copyright © 2021 John Goodstadt. All rights reserved.
//

import UIKit
import AVFoundation

protocol IListenDisplay {
	func updateAudioItem(_ item: RecallItem)
	func displayLoadingState(_ loading: Bool)
	func displayEmptyState()
	func display(_ error: Error)
	func displayIsPlayingState(_ playing: Bool)
	func currentPlayingTime(_ currentTime: Float)
	func trackDuration(_ duration: Float)
}

extension ListenViewController: IListenDisplay {
	func trackDuration(_ duration: Float) {
		slider.maximumValue = duration
	}
	
	func currentPlayingTime(_ currentTime: Float) {
		slider.value = Float(currentTime)
	}
	
	func displayIsPlayingState(_ playing: Bool) {
		if playing {
			setPauseImage()
		}else {
			setPlayImage()
		}
	}
	
	func updateAudioItem(_ item: RecallItem) {
		UpdateUI(item) //success display of data
	}
	func displayEmptyState() {
		// display what you need to show the user in case of empty
	}
	
	func display(_ error: Error) {
		// display what you need to show the user in case of error
	}
	
	func displayLoadingState(_ loading: Bool) {
		// display what you need to show the user while the data is loaded
	}
}

class ListenViewController: UIViewController
{
	//MARK: VIP Properties
	var interactor: ListenInteractor?
	var router: ListenRouter?
	
	//MARK: - Properties
	var recallitem:RecallItem = RecallItem()//NOTE: this created before viewModel
	
	private let titleLabel: UILabel = {
		let v = UILabel()
		v.backgroundColor = .clear
		v.textColor = .systemGroupedBackground
		v.textAlignment = .center
		v.font = UIFont.systemFont(ofSize: 26)
		return v
	}()
	private let iconImage: UIImageView = {
		let iv = UIImageView()
		iv.image = UIImage(systemName: "bubble.right")
		iv.tintColor = .white
		iv.backgroundColor = .darkGray
		return iv
	}()
	
	let playButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
		button.tintColor = .systemBlue
		button.backgroundColor = .clear
		button.isEnabled = true
		
		
		return button
	}()
	let slider:UISlider = {
		let s = UISlider()
		
		return s
	}()
	
	// MARK: - Lifecycle
	convenience init(item: RecallItem ) {
		self.init()
		self.recallitem = item
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureView() //Link VIP objects
		
		configureUI()
		
		interactor?.loadData(item: self.recallitem)
	}
	override func viewDidDisappear(_ animated: Bool) {
		
		interactor?.endAudio()
		
		super.viewDidDisappear(animated)
	}
	// MARK: - Helpers
	func configureUI(){
		
		playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
		
		self.view.backgroundColor = .systemBackground //for Dark/Light mode
		
		view.addSubview(titleLabel)
		
		titleLabel.backgroundColor = .clear
		titleLabel.textColor = .label
		titleLabel.centerX(inView: view)
		titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
						  paddingTop: 8, paddingLeft: 32, paddingBottom:0, paddingRight: 32)
		titleLabel.setWidth(width: 180)
		titleLabel.setHeight(height: 60)
		
		
		
		view.addSubview(controlsContainerView)
		controlsContainerView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
									 paddingTop: 8, paddingLeft: 32, paddingRight: 32)
		controlsContainerView.setHeight(height: 100)
		controlsContainerView.backgroundColor = .clear
		
		
		view.addSubview(iconImage)
		iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor, multiplier: 1.0).isActive = true
		iconImage.anchor(top: controlsContainerView.bottomAnchor, paddingTop: 32)
		
		view.addEqualConstraintFromView(iconImage,
										attribute: .width,
										multiplier: 0.85,
										identifier: "image prop width")
		
		iconImage.centerX(inView: view)
	}
	func UpdateUI(_ audioItem:RecallItem) {
		titleLabel.text = recallitem.title
		
		if audioItem.prompt.isNotEmpty {
			iconImage.image = UIImage(data: recallitem.prompt)
		}else if audioItem.thumbnail.isNotEmpty {
			iconImage.image = UIImage(data: recallitem.thumbnail)
		}else{
			iconImage.image = UIImage(named: "sa\(Int.random(in: 1...3))")
		}
		
		if audioItem.audio.isNotEmpty {
			recallitem.hasAudio = true
			//can now set slider max
			interactor?.trackDuration(audio: recallitem.audio)
			//slider.maximumValue = mp3duration(recallitem.audio)
		}else{
			audioItem.hasAudio = false
			self.slider.maximumValue = 1.0
		}
		
		self.playButton.isEnabled = audioItem.hasAudio
		
		self.title = audioItem.subtitle
	}
	
	// MARK: - Selectors
	@objc func playButtonPressed() {
		
		interactor?.playOrPause(self.recallitem)
	}
	
	private func setPlayImage(){
		playButton.setImage(UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
	}
	private func setPauseImage(){
		playButton.setImage(UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), for: .normal)
	}
	private lazy var controlsContainerView: UIView = {
		let containerView = UIView()
		
		containerView.backgroundColor = .systemBackground
		
		containerView.addSubview(playButton)
		playButton.anchor(top: containerView.topAnchor,left:containerView.leftAnchor,paddingTop: 0, paddingLeft: 0)
		playButton.setDimensions(height: 100, width: 100)
		
		
		
		containerView.addSubview(slider)
		
		slider.anchor(top: playButton.topAnchor,left:playButton.rightAnchor,bottom:playButton.bottomAnchor,right: containerView.rightAnchor,paddingTop: 0)
		
		return containerView
	}()
}
