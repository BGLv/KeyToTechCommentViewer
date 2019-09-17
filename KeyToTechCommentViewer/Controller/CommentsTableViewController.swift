//
//  CommentsTableViewController.swift
//  KeyToTechCommentViewer
//
//  Created by Bogdan Lviv on 9/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    //tableView content variable
    var commentsInsideTable: [Comment]?
    var totalNumberOfComments: Int?
    
    //flag for triger fatching only once per load
    var fetchingMore = false
    var scrollAnimationEnded = true
    
    //start and limit variables created for pagination
    var displayDistanse: Int? = 10
    var startCommentId: Int? = 0
    var totalLimit: Int?
    
    private static let idOffset = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if 0 == section {
            return commentsInsideTable?.count ?? 0
        } else if 1 == section && fetchingMore {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0 == indexPath.section{
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentsTableViewCell", for: indexPath) as! CommentsTableViewCell
            
            cell.comment = self.commentsInsideTable?[indexPath.row]
            cell.id = indexPath.row + CommentsTableViewController.idOffset
           
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
            return cell
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollAnimationEnded = true
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height){
            let lastVisibleCell = self.tableView.visibleCells.last as? CommentsTableViewCell
            let allVisibleRows = lastVisibleCell?.id ?? 0
            let allAvaliableComments = self.commentsInsideTable?.count ?? 0
            if !fetchingMore && allVisibleRows == allAvaliableComments {
                fetchingMore = true
                scrollAnimationEnded = false
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch(){
        
        if ((totalLimit ?? 0) > 0) && (startCommentId ?? 0) <= (totalNumberOfComments ?? (startCommentId ?? 0)+1) {
        let commentsInsideTableSize = commentsInsideTable?.count
            if commentsInsideTableSize ?? 0 < totalNumberOfComments ?? 1{
                let jsonPlaceholderService = JSONPlaceholderService()
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
                var minPageSize = displayDistanse
                if let displayDistanse = displayDistanse, let totalLimit = totalLimit{
                    minPageSize = min(displayDistanse,totalLimit)
                }
                jsonPlaceholderService.getCommentsStarted(with: startCommentId, limitedBy: minPageSize) { [weak self](arrOfComments, totalNumberOfComments) in
                    
                    if nil == self?.commentsInsideTable{
                        self?.commentsInsideTable = arrOfComments
                    }else{
                        self?.commentsInsideTable?.append(contentsOf: arrOfComments ?? [])
                    }
                    
                    self?.totalNumberOfComments = totalNumberOfComments
                    DispatchQueue.main.async {
                        if let startId = self?.startCommentId, let displayDistanse=self?.displayDistanse, let totalLimit=self?.totalLimit{
                            
                            self?.startCommentId=startId+(minPageSize ?? displayDistanse)
                            self?.totalLimit = totalLimit - ((minPageSize ?? displayDistanse))
                            self?.fetchingMore = false
                            self?.tableView.reloadData()
                            //self?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                            /*Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self](Timer) in
                                DispatchQueue.main.async {
                                    self?.fetchingMore = false
                                    self?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                                }
                            })*/
                            
                        }
                    }
                }
                
            }
            
    }
        
    }
}
