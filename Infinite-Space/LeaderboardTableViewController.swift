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
        //tableView.backgroundView = UIImageView(image: UIImage(named: "spaceNebula.png"))

    // MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

