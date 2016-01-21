//
//  ViewController.swift
//  pokedex
//
//  Created by Ilya Shaisultanov on 1/16/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var background: UIImageView!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var audioPlayer: AVAudioPlayer!
    var inSearchMode = false
    var tapGesture: UITapGestureRecognizer!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        background.addGestureRecognizer(tapGesture)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done

        parsePokemonCSV()
        loadMusic()
    }

    func loadMusic () {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 0.01
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        } catch let e as NSError {
            print(e.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows

            for row in rows {
                let id = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: id)
                pokemon.append(poke)
            }
        } catch let e as NSError {
            print(e.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            let source = inSearchMode ? filteredPokemon : pokemon
            let poke = source[indexPath.row]
            
            cell.configureCell(poke)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.userInteractionEnabled = false
        collectionView.alpha = 0.5
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PokeCell
        activityIndicator = UIActivityIndicatorView(frame: cell.thumbImage.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.color = UIColor.blackColor()
        
        cell.thumbImage.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()

        let source = inSearchMode ? filteredPokemon : pokemon
        let poke = source[indexPath.row]
        
        poke.downloadPokemonDetails { () -> () in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            collectionView.userInteractionEnabled = true
            collectionView.alpha = 1
            self.performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemon.count : pokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    @IBAction func musicButtonPressed(sender: UIButton) {
        if audioPlayer.playing {
            audioPlayer.stop()
            sender.alpha = 0.5
        } else {
            audioPlayer.play()
            sender.alpha = 1
        }
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        player.stop()
    }
    
    // this needs to not play if previously muted
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        player.play()
    }
    
    func doneEditing (){
        view.endEditing(true)
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        doneEditing()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            doneEditing()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredPokemon = pokemon.filter { $0.name.containsString(lower) }
            collectionView.reloadData()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        doneEditing()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 20, 20, 20)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
            }
        }
    }
}

