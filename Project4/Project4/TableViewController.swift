//
//  TableViewController.swift
//  Project4
//
//  Created by MTMAC51 on 19/10/22.
//

import UIKit

class TableViewController: UITableViewController {
    
    static let websites = ["apple.com", "satriawarn.github.io"]
    
    private let cellIdentifier = "page"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pages list"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewController.websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = TableViewController.websites[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: WebViewController.viewIdentifier) as? WebViewController {
            vc.website = TableViewController.websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
