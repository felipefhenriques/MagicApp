//
//  File.swift
//  MagicApp
//
//  Created by Gustavo Yamauchi on 23/02/21.
//

import Foundation

public struct Cards: Codable {
    init() {}
    public var cards: [Card]?
}

public struct Card: Codable {

    public var name: String?
    public var manaCost: String?
    public var type: String?
    public var rarity: String?
    public var set: String?
    public var setName: String?
    public var text: String?
    public var artist: String?
    public var imageUrl: String?
    public var id: String?
//    public var names: [String]?
//    public var cmc: Int?
//    public var colors: [String]?
//    public var colorIdentity: [String]?
//    public var supertypes: [String]?
//    public var types: [String]?
//    public var subtypes: [String]?
//    public var number: String?
//    public var power: String?
//    public var toughness: String?
//    public var layout: String?
//    public var multiverseid: Int?
//    public var rulings: [[String:String]]?
//    public var foreignNames: [[String:String]]?
//    public var printings: [String]?
//    public var originalText: String?
//    public var originalType: String?
//    public var flavor: String?
//    public var loyalty: Int?
//    public var gameFormat: String?
//    public var releaseDate: String?
//    public var legalities = [String: String]()

}
