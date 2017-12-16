//
//  Character.swift
//  GOT-BackendPackageDescription
//
//  Created by Conrado Mateu Gisbert on 15/12/2017.
//

import Foundation
import Vapor
import PostgreSQLProvider

final class Character: Model {
    var storage: Storage = Storage()
    var name: String?
    var description: String?
    var image: String?
    var formalDescription: String {
        get {
            return "\(name) - \(description ?? "No description provided.")"
        }
    }

    init( name: String, description: String, image: String) {
        self.name = name
        self.description = description
        self.image = image
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("description", description)
        try row.set("image", image)
        try row.set("formalDescription", formalDescription)
        return row
    }

    init(row: Row) throws {
        self.id = try row.get("id")
        self.name = try row.get("name")
        self.image = try row.get("image")
        self.description = try row.get("description")
    }

}

// MARK: Database Preparations
extension Character: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
            builder.string("description", optional: true)
            builder.string("image", optional: true)
            builder.string("formalDescription")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Character: NodeRepresentable{


         func makeNode(in context: Context?) throws -> Node {
            return try Node(node: ["name": self.name,
                                   "description": self.description,
                                   "image": self.image])
        }

}


extension Character{
    func merge(updates: Character) {
        id = updates.id ?? id
        name = updates.name ?? name
        image = updates.image ?? image
        description = updates.description ?? description
    }
}
