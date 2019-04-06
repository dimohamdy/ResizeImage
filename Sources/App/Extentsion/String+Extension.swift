//
//  String+Extension.swift
//  App
//
//  Created by BinaryBoy on 4/6/19.
//

import Foundation

extension String {
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
