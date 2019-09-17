//
//  CommentsTableViewCell.swift
//  KeyToTechCommentViewer
//
//  Created by Bogdan Lviv on 9/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
  
    @IBOutlet weak var postIdLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    var id: Int?
    
    var comment: Comment?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        if let commentIdInt = comment?.id{
            self.idLabel.text = String("id: \(commentIdInt)")
            makePrefixBold(self.idLabel)
        }
        if let postIdInt = comment?.postId{
            self.postIdLabel.text = String("PostId: \(postIdInt)")
            makePrefixBold(self.postIdLabel)
        }
        if let email = comment?.email{
            self.emailLabel.text = "Email: \(email)"
            makePrefixBold(self.emailLabel)
        }
        if let name = comment?.name{
            self.nameLabel.text = "Name: \(name)"
            makePrefixBold(self.nameLabel)
        }
        if let body = comment?.body{
            self.bodyLabel.text = "Body: \(body)"
            makePrefixBold(self.bodyLabel)
        }
    }
    
    private func makePrefixBold(_ label: UILabel?){
        if (nil != (label?.text)), let startIndex = label?.text?.startIndex, let indexOfSeparator =
            label?.text?.firstIndex(of: " "){
            let attrStr = NSMutableAttributedString(string: label!.text!)
            let firstWordRange = startIndex..<indexOfSeparator
            let nsrange = NSRange(firstWordRange, in:label!.text! )
            attrStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: label!.font.pointSize), range: nsrange)
            label!.attributedText = attrStr
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
