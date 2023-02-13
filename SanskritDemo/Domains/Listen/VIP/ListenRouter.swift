//
//  ListenRouter.swift
//  SanskritDemo
//
//  Created by John goodstadt on 13/02/2023.
//

import UIKit

protocol IListenRouter {
    // write you fetch function here
	func showNextScene()
}

final class ListenRouter {
	weak var viewController: UIViewController?
}

extension ListenRouter:  IListenRouter {
	func showNextScene() {}
}
