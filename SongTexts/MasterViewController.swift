//
//  MasterViewController.swift
//  SongTexts
//
//  Created by Edwin Wiersma on 03/05/2017.
//  Copyright © 2017 Apps4mobile. All rights reserved.
//

import UIKit
import Firebase

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var songs: [Song] = []
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        let songsRef = ref.child("Songs")
        songsRef.observe(.value, with: { snapshot in
            if !snapshot.exists() { return }
            
            var newSongs: [Song] = []
            
            for song in snapshot.children {
                let newSong = Song(snapshot: song as! FIRDataSnapshot)
                newSongs.append(newSong)
            }
            self.songs.removeAll()
            self.songs = newSongs
            self.tableView.reloadData()
            
        })
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if Display.typeIsLike != .iphone6plus {
                    self.splitViewController?.toggleMasterView()
                }
                let song = songs[indexPath.row]
                let songTitle = song.title
                let songText = song.text
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = songText
                controller.vcTitle = songTitle
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let song = songs[indexPath.row]
        cell.textLabel!.text = song.title
        return cell
    }
}

extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = self.displayModeButtonItem
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
    }
}
