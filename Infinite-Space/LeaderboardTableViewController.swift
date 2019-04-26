//
//  LeaderboardTableViewController.swift
//  Infinite-Space
//
//  Created by Komlan Attiogbe on 4/16/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import UIKit
import FLAnimatedImage

class LeaderboardTableViewController: UITableViewController {
    
    //weak var backgroundGif: FLAnimatedImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = FLAnimatedImageView()
        let backgroundGif = tableView.backgroundView as! FLAnimatedImageView
        
        let path2 : String = Bundle.main.path(forResource: "spaceBackground", ofType: "gif")!
        let url2 = URL(fileURLWithPath: path2)
        do {
            let gifData2 = try Data(contentsOf: url2)
            let imageData2 = try? FLAnimatedImage(animatedGIFData: gifData2)
            backgroundGif.animatedImage = imageData2 as? FLAnimatedImage
        } catch {
            print(error)
        }
 
    }


    // MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath) as! HighScoreCellTableViewCell
        
        
        cell.userNameLabel.text = "Komlan"
        cell.highScoreLabel.text = "52"
        return cell
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

