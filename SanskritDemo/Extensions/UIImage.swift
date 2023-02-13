//
//  UIImage.swift
//  SanskritDemo
//
//  Created by John goodstadt on 11/02/2023.
//

import UIKit

extension UIImage {
	
	//https://gist.github.com/tomasbasham/10533743
	func scale(with targetWidth: CGFloat) -> UIImage? {
		
		if self.size.width != targetWidth {
			
			var aspectRatio = self.size.width / self.size.height
			if self.size.width  < self.size.height { // landscape
				aspectRatio =  self.size.height /  self.size.width
			}
			
			let _ = targetWidth * aspectRatio
			let newHeight = targetWidth / aspectRatio
			
			let size = CGSize(width: targetWidth, height: newHeight)
			
			var scaledImageRect = CGRect.zero
			
			let aspectWidth:CGFloat = size.width / self.size.width
			let aspectHeight:CGFloat = size.height / self.size.height
			let finalAspectRatio:CGFloat = min(aspectWidth, aspectHeight)
			
			scaledImageRect.size.width = self.size.width * finalAspectRatio
			scaledImageRect.size.height = self.size.height * finalAspectRatio
			scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
			scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
			
			UIGraphicsBeginImageContextWithOptions(size, false, 0)
			
			self.draw(in: scaledImageRect)
			
			let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return scaledImage
		}
		
		return self
		
		
	}
	
}
