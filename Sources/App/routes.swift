import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let imageResizeController = ImageResizeController()
    try router.register(collection: imageResizeController)
}

