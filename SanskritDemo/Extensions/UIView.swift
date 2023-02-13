//
//  UIView.swift
//  SanskritDemo
//
//  Created by John goodstadt on 12/02/2023.
//

import Foundation
import UIKit

extension UIView {
	func anchor(top: NSLayoutYAxisAnchor? = nil,
				left: NSLayoutXAxisAnchor? = nil,
				bottom: NSLayoutYAxisAnchor? = nil,
				right: NSLayoutXAxisAnchor? = nil,
				paddingTop: CGFloat = 0,
				paddingLeft: CGFloat = 0,
				paddingBottom: CGFloat = 0,
				paddingRight: CGFloat = 0,
				width: CGFloat? = nil,
				height: CGFloat? = nil) {
		
		translatesAutoresizingMaskIntoConstraints = false
		
		if let top = top {
			topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
		}
		
		if let left = left {
			leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
		}
		
		if let bottom = bottom {
			bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
		}
		
		if let right = right {
			rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
		}
		
		if let width = width {
			widthAnchor.constraint(equalToConstant: width).isActive = true
		}
		
		if let height = height {
			heightAnchor.constraint(equalToConstant: height).isActive = true
		}
	}
	
	func centerX(inView view: UIView) {
		translatesAutoresizingMaskIntoConstraints = false
		centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
				 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
		
		translatesAutoresizingMaskIntoConstraints = false
		centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
		
		if let left = leftAnchor {
			anchor(left: left, paddingLeft: paddingLeft)
		}
	}
	
	func setDimensions(height: CGFloat, width: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		heightAnchor.constraint(equalToConstant: height).isActive = true
		widthAnchor.constraint(equalToConstant: width).isActive = true
	}
	
	func setHeight(height: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		heightAnchor.constraint(equalToConstant: height).isActive = true
	}
	
	func setWidth(width: CGFloat) {
		translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(equalToConstant: width).isActive = true
	}
	
	public func centerInSuperview(size: CGSize = .zero) {
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewCenterXAnchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
		}
		
		if let superviewCenterYAnchor = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
		}
		
		if size.width != 0 {
			widthAnchor.constraint(equalToConstant: size.width).isActive = true
		}
		
		if size.height != 0 {
			heightAnchor.constraint(equalToConstant: size.height).isActive = true
		}
	}
	func addEqualConstraintFromView(_ subview: UIView?,
									attribute: NSLayoutConstraint.Attribute,
									multiplier: CGFloat,
									identifier: String) {
		if let subview = subview {
			let constraint = NSLayoutConstraint(item: subview,
												attribute: attribute,
												relatedBy: .equal,
												toItem: self,
												attribute: attribute,
												multiplier: multiplier,
												constant: 0)
			constraint.identifier = identifier
			self.addConstraint(constraint)
		}
	}
}
