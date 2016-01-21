//
//  ChatCell.swift
//  WhaleTalk
//
//  Created by Anar Enhsaihan on 1/20/16.
//  Copyright © 2016 nomad. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    let messageLabel: UILabel = UILabel()
    private let bubbleImageView = UIImageView()
    
    private var outgoingConstraint: NSLayoutConstraint!
    private var incomingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        messageLabel.centerXAnchor.constraintEqualToAnchor(bubbleImageView.centerXAnchor).active = true
        messageLabel.centerYAnchor.constraintEqualToAnchor(bubbleImageView.centerYAnchor).active = true
        
        bubbleImageView.widthAnchor.constraintEqualToAnchor(messageLabel.widthAnchor, constant: 50).active = true
        bubbleImageView.heightAnchor.constraintEqualToAnchor(messageLabel.heightAnchor).active = true
        
        bubbleImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true

        
        outgoingConstraint = bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor)
        incomingConstraint = bubbleImageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor)
        
        
        
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0
        
        let image = UIImage(named: "MessageBubble")?.imageWithRenderingMode(.AlwaysTemplate)
        bubbleImageView.tintColor = UIColor.blueColor()
        bubbleImageView.image = image
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     
     Activates either incoming/outgoing constraint on bubbleImageView
     
     Activate leading or trailing constraint on bubbleView depending on whether it is incoming/outgoing.
     Both constraints are pinned to the anchor of the contentView, which is the cell of the tableView
     
     - Parameter incoming: See if message is incoming/outgoing
     
    */
    func incoming(incoming: Bool) {
        
        if incoming {
            incomingConstraint.active = true
            outgoingConstraint.active = false
        } else {
            incomingConstraint.active = false
            outgoingConstraint.active = true
        }
    }
    
}
