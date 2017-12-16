import Vapor

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        post("character"){ (request: Request)  in
            guard let name = request.data["name"]?.string, let description = request.data["description"]?.string, let image = request.data["image"]?.string else {
                throw Abort.badRequest
            }

            let cahracter = Character(name: name, description: description, image: image)
            try cahracter.save()
            return "Character Added"
        }

        get("characters") { req in
            return try Character.all().makeResponse()
        }
        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }

    func build(_ builder: RouteBuilder) throws {


        builder.post("character", "new") { (request) -> ResponseRepresentable in
            guard let name = request.data["name"]?.string,
                let image = request.data["image"]?.string,
                let description = request.data["description"]?.string else {
                    throw Abort.badRequest
            }

            let character = Character(name: name, description: description, image: image)
            try character.save()

            return "Success!\n\nUser Info:\nName: \(character.name)\nImage: \(character.image)\nDescription: \(character.description)\nID: \(String(describing: character.id?.wrapped))"
        }
    }
}
