//
//  ListenConfigurator.swift
//  SanskritDemo
//
//  Created by John goodstadt on 13/02/2023.
//

import Foundation

extension ListenViewController {
	
	func configureView() {
		let viewController = self
		let interactor = ListenInteractor()
		let presenter = ListenPresenter()
		let router = ListenRouter()
		let worker = ListenWorker()
		
		router.viewController = self
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		interactor.worker = worker
		presenter.viewController = viewController
	}
}
