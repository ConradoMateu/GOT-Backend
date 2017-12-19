//
//  CharacterController.swift
//  GOT-BackendPackageDescription
//
//  Created by Conrado Mateu Gisbert on 16/12/2017.
//

import PostgreSQLProvider
import Vapor

final class CharacterController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {

        return try Character.all().makeJSON()
    }
    final func all(request: Request) throws -> ResponseRepresentable{
        let allCharacters = try Character.all()
        return try allCharacters.makeJSON()
    }
    func create(request: Request) throws -> ResponseRepresentable {
        var character = try request.character()
        try character.save()
        return try character.makeJSON()
    }

    func show(request: Request, character: Character) throws -> ResponseRepresentable {
        return try character.makeJSON()
    }

    func delete(request: Request, character: Character) throws -> ResponseRepresentable {
        try character.delete()
        return JSON([:])
    }
    
    func update(request: Request, character: Character) throws -> ResponseRepresentable {
        let new = try request.character()
        var character = character
        character.merge(updates: new)
        try character.save()
        return try character.makeJSON()
    }

    func replace(request: Request, character: Character) throws -> ResponseRepresentable {
        try character.delete()
        return try create(request: request)
    }

    func clear(request: Request) throws -> ResponseRepresentable{
        try Character.all().forEach{
            try $0.delete()
        }
        return JSON([])
    }

    func makeResource() -> Resource<Character> {
        return Resource(
            index: index,
            store: create,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func character() throws -> Character {
        guard let json = json else { throw Abort.badRequest }
        return try Character(json: json)
    }
}

