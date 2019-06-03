//
//  MessageListTableViewController.swift
//  BulletinBoard
//
//  Created by Dustin Koch on 6/3/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class MessageListTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var messageTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        MessageController.sharedInstance.fetchMessages { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let messageText = messageTextField.text else { return }
        MessageController.sharedInstance.createMessageWith(text: messageText, timeStamp: Date())
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MessageController.sharedInstance.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        let message = MessageController.sharedInstance.messages[indexPath.row]
        cell.textLabel?.text = message.text
        //This is memory intensive. Just using for demo
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: message.timeStamp, dateStyle: .medium, timeStyle: .short)

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let message = MessageController.sharedInstance.messages[indexPath.row]
            MessageController.sharedInstance.removeMessage(message: message) { (success) in
                if success {
                    DispatchQueue.main.async {
                       tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }

}//END OF TableViewController
