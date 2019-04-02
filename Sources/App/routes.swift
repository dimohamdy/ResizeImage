import Vapor
import SwiftGD

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    router.get("resize") { req -> Future<Response> in
        
        let urlString = try req.query.get(String.self, at: "url")
        let fileName = URL(fileURLWithPath: urlString).lastPathComponent
        if isFound(fileName: fileName) {
            return req.future(req.redirect(to: fileName))
        }
        let client = try req.make(Client.self)
        let response = client.get(urlString)
        let data = response.map(to:  Data.self, { respo -> Data in
            return respo.http.body.data!
            
        }).map({ data -> Response in
            let destination = getImagePath(fileName: fileName)
            var image = try Image.init(data: data)
            image = image.resizedTo(width: 70, height: 70)!
            image.write(to: destination)
            return req.redirect(to: fileName)

        })
        return data
    }
    
}

func getImagePath(fileName:String) -> URL{
    
    let directory = DirectoryConfig.detect()
    let workingDirectory = directory.workDir
    let workingDirectoryPath = URL(fileURLWithPath:workingDirectory)
    let destination = workingDirectoryPath.appendingPathComponent("Public/\(fileName)")
    return destination
}
func isFound(fileName:String) -> Bool{
    let destination = getImagePath(fileName: fileName)
    return  FileManager().fileExists(atPath: destination.path)
}
