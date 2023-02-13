//
//  ZipHelper.swift
//  SanskritDemo
//
//  Created by John goodstadt on 13/02/2023.
//

import Foundation
import ZIPFoundation

public func fileExists(_ filename:String) -> Bool {
	
	let fileManager = FileManager()
	var destinationURL = getDocumentsDirectoryString().appending("/\(filename)")
	
	return FileManager.default.fileExists(atPath: destinationURL)
}
public func UNZIP(from sourceURL: URL,filename:String) -> URL{
	
	let fileManager = FileManager()
	var destinationURL = URL(fileURLWithPath: getDocumentsDirectoryString())
	
	destinationURL.appendPathComponent(filename)
	do {
		try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
		try fileManager.unzipItem(at: sourceURL, to: destinationURL)
		
		try? FileManager.default.removeItem(at:  sourceURL) //dont need this anymore
		
	} catch {
		print("Extraction of ZIP archive failed with error:\(error)")
	}

	return destinationURL
}

 public func copyFileURLToDocuments(_ sourceURL:String,_ filename:String) -> String {
	
	 let sourcePath = URL(fileURLWithPath: sourceURL).path
	 let destPath = getDocumentsDirectoryString().appending("/\(filename)")
	
	do{
		if FileManager.default.fileExists(atPath: destPath){
			return destPath
		}
		try FileManager.default.copyItem(atPath: sourcePath, toPath: destPath)
	}catch{
		print(error)
	}
	
	return destPath
	
}
