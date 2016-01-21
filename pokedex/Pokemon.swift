//
//  Pokemon.swift
//  pokedex
//
//  Created by Ilya Shaisultanov on 1/16/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String! = ""
    private var _type: String! = ""
    private var _defense: String! = ""
    private var _attack: String! = ""
    private var _height: String! = ""
    private var _weight: String! = ""
    private var _nextEvoName: String! = ""
    private var _nextEvoId: String! = ""
    private var _nextEvoLevel: String! = ""
    private var _pokemonUrl: String! = ""
    private var _moves: [[String: AnyObject]]!
    
    var name: String {
        return _name.capitalizedString
    }
    
    var pokedexId: Int {
        return _pokedexId
    }

    var description: String {
        return _description
    }
    
    var type: String {
        return _type
    }
    
    var defense: String {
        return _defense
    }
    
    var attack: String {
        return _attack
    }
    
    var weight: String {
        return _weight
    }
    
    var height: String {
        return _height
    }
    
    
    var nextEvolutionId: String {
        return _nextEvoId
    }
    
    var nextEvolutionLevel: String {
        return _nextEvoLevel
    }
    
    var nextEvolutionName: String {
        return _nextEvoName
    }
    
    var moves: [[String: AnyObject]] {
        return _moves
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    // gonna use inline instead
//    func downloadPokemonDetails (completed: DownloadComplete) {
//        
//    }
    
    func downloadPokemonDetails (cb: () -> ()) {
        // can also pass NSURL instead of that string
        Alamofire.request(.GET, self._pokemonUrl).responseJSON { res in
            if let json = res.result.value {
                if let weight = json["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = json["height"] as? String {
                    self._height = height
                }
                
                if let defense = json["defense"] as? Int {
                    self._defense = String(defense)
                }
                
                if let attack = json["attack"] as? Int {
                    self._attack = String(attack)
                }
                
                if let types = json["types"] as? [ [String: String] ] where types.count > 0 {
                    let t = types.map({ (type: [String : String]) -> String in
                        return type["name"]!.capitalizedString
                    })
                    
                    self._type = t.sort().joinWithSeparator("/")
                }
                
                if let evs_array = json["evolutions"] as? [ [String: AnyObject] ] where evs_array.count > 0 {
                    if let to = evs_array[0]["to"] as? String where !to.lowercaseString.containsString("mega") {
                        if let uri = evs_array[0]["resource_uri"] as? String {
                            let next_id = uri
                                .stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                .stringByReplacingOccurrencesOfString("/", withString: "")
                            
                            self._nextEvoId = next_id
                            self._nextEvoName = to
                            
                            if let level = evs_array[0]["level"] as? Int {
                                self._nextEvoLevel = String(level)
                            }
                        }
                    }
                }
                
                var moves_refs = [String]()
                
                if let m = json["moves"] as? [ [String: AnyObject] ] {
                    moves_refs = m.map({ (move: [String : AnyObject]) -> String in
                        return move["resource_uri"] as! String
                    })
                }
                
                var movesList = [[String: AnyObject]]()
                
                self.downloadMoves(moves_refs, acc: &movesList, cb: { (results: [[String : AnyObject]]) -> () in
                    self._moves = results
                    self.downloadDescription(json as! [String : AnyObject], cb: { (desc) -> () in
                        if let d = desc {
                            self._description = d
                        }
                        
                        cb()
                    })
                })
            } else {
                cb()
            }
        }
    }
    
    func downloadDescription (json: [String: AnyObject], cb: (String?) -> ()) {
        if let desc = json["descriptions"] as? [[String: String]] where desc.count > 0 {
            if let res = desc[0]["resource_uri"] {
                let url = "\(URL_BASE)\(res)"
                Alamofire.request(.GET, url).responseJSON { res in
                    var desc: String?
                    
                    if let descJson = res.result.value as? [String: AnyObject] {
                        desc = descJson["description"] as? String
                    }
                    
                    cb(desc)
                }
            } else {
                cb(nil)
            }
        } else {
            cb(nil)
        }
    }
    
    func downloadMoves (var moves: [String], inout acc: [[String: AnyObject]], cb: ([ [String: AnyObject] ])->() ) {
        Alamofire.request(Alamofire.Method.GET, "\(URL_BASE)\(moves.popLast()!)").responseJSON { res in
            if let movesJson = res.result.value as? [String: AnyObject] {
                acc.append(movesJson)
            }
            
            if moves.isEmpty {
                cb(acc)
            } else {
                self.downloadMoves(moves, acc: &acc, cb: cb)
            }
        }
    }
}