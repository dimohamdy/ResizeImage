//
//  FilesHelper.swift
//  App
//
//  Created by BinaryBoy on 4/6/19.
//

import Vapor

struct FilesHelper {
    
    //get image path in Public folder
    static func getImagePath(fileName:String) -> URL{
        
        let directory = DirectoryConfig.detect()
        let workingDirectory = directory.workDir
        let workingDirectoryPath = URL(fileURLWithPath:workingDirectory)
        let destination = workingDirectoryPath.appendingPathComponent("Public/\(fileName)")
        return destination
    }
    //check if the image resized before or not
    static func isFound(fileName:String) -> Bool{
        let destination = getImagePath(fileName: fileName)
        return  FileManager().fileExists(atPath: destination.path)
    }
    
    static func geNewFileName(urlString:String,width:Int,height:Int) -> String{
        //add width and height in image name to enable the image to be resized with different size
        let fileNameWithoutExtension = urlString.fileName()
        let fileExtension = urlString.fileExtension()
        
        return  "\(fileNameWithoutExtension)_\(width)x\(height).\(fileExtension)"
        
    }
}
