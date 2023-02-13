//
//  ListenPresenter.swift
//  SanskritDemo
//
//  Created by John goodstadt on 13/02/2023.
//

import Foundation

protocol IListenPresenter {
	func presentDetails(response: ListenDisplay.LoadData.Response)
    func presentLoadingState(_ loading: Bool)
    func presentEmptyState()
    func present(_ error: Error)
	func presentPlayingState(_ isPaying:Bool)
	func presentPlayTime(_ currentTime:Float)
	func trackDuration(_ duration:Float)
	
}

class ListenPresenter {
    
    // MARK: - Properties
    //private
	//weak
	var viewController: IListenDisplay?
    
}

extension ListenPresenter: IListenPresenter {
	func trackDuration(_ duration:Float) {
		viewController?.trackDuration(duration)
	}
	
	func presentPlayTime(_ currentTime: Float) {
		viewController?.currentPlayingTime(currentTime)
	}
	
	func presentPlayingState(_ isPlaying: Bool) {
		viewController?.displayIsPlayingState(isPlaying)
	}
	
	func presentDetails(response: ListenDisplay.LoadData.Response){

		viewController?.updateAudioItem(response.item)
	}
	func presentLoadingState(_ loading: Bool) {
		viewController?.displayLoadingState(loading)
	}
	
	func presentEmptyState() {
		viewController?.displayEmptyState()
	}
	
	func present(_ error: Error) {
		viewController?.display(error)
	}
}
