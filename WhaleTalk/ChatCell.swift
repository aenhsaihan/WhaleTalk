//
//  ChatCell.swift
//  WhaleTalk
//
//  Created by Anar Enhsaihan on 1/20/16.
//  Copyright © 2016 nomad. All rights reserved.
//

import UIKit

struct BubbleConstants {
    
    struct Insets {
        
        static let topInset : CGFloat              = 17.0
        static let bottomInset : CGFloat           = 17.5
        
        static let incomingLeftInset : CGFloat     = 26.5
        static let outgoingLeftInset : CGFloat     = 21
        
        static let incomingRightInset : CGFloat    = 21
        static let outgoingRightInset : CGFloat    = 26.5
        
    }
    
    struct RGBAlpha {
        
        static let incomingRed : CGFloat            = 229/255
        static let incomingBlue : CGFloat           = 229/255
        static let incomingGreen : CGFloat          = 229/255
        static let incomingAlpha : CGFloat          = 1
        
        static let outgoingRed : CGFloat            = 0/255
        static let outgoingBlue : CGFloat           = 122/255
        static let outgoingGreen : CGFloat          = 255/255
        static let outgoingAlpha : CGFloat          = 1
    }
    
}

class ChatCell: UITableViewCell {

    let messageLabel: UILabel = UILabel()
    private let bubbleImageView = UIImageView()
    
    private var outgoingConstraints: [NSLayoutConstraint]!
    private var incomingConstraints: [NSLayoutConstraint]!
    
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
        
        outgoingConstraints = [
            bubbleImageView.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor),
            bubbleImageView.leadingAnchor.constraintGreaterThanOrEqualToAnchor(contentView.centerXAnchor),
        ]
        
        incomingConstraints = [
            bubbleImageView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor),
            bubbleImageView.trailingAnchor.constraintLessThanOrEqualToAnchor(contentView.centerXAnchor)
        ]
        
        bubbleImageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 10).active = true
        bubbleImageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -10).active = true
        
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     
     Configure cell based on incoming status of message
     
     Activate leading or trailing constraint on bubbleView depending on whether it is incoming/outgoing.
     Both constraints are pinned to the anchor of the contentView, which is the cell of the tableView
     
     Set the appropriate image on the cell for incoming/outgoing message
     
     - Parameter incoming: See if message is incoming/outgoing
     
    */
    func incoming(incoming: Bool) {
        
        if incoming {
            NSLayoutConstraint.deactivateConstraints(outgoingConstraints)
            NSLayoutConstraint.activateConstraints(incomingConstraints)
            bubbleImageView.image = bubble.incoming
        } else {
            NSLayoutConstraint.deactivateConstraints(incomingConstraints)
            NSLayoutConstraint.activateConstraints(outgoingConstraints)
            bubbleImageView.image = bubble.outgoing
        }
    }
    
}

let bubble = makeBubble()

func makeBubble() -> (incoming: UIImage, outgoing: UIImage) {
    let image = UIImage(named: "MessageBubble")!
    
    let insetsIncoming = UIEdgeInsets(top: BubbleConstants.Insets.topInset, left: BubbleConstants.Insets.incomingLeftInset, bottom: BubbleConstants.Insets.bottomInset, right: BubbleConstants.Insets.incomingRightInset)
    let insetsOutgoing = UIEdgeInsets(top: BubbleConstants.Insets.topInset, left: BubbleConstants.Insets.outgoingLeftInset, bottom: BubbleConstants.Insets.bottomInset, right: BubbleConstants.Insets.outgoingRightInset)
    
    let outgoing = coloredImage(image, red: BubbleConstants.RGBAlpha.outgoingRed, green: BubbleConstants.RGBAlpha.outgoingGreen, blue: BubbleConstants.RGBAlpha.outgoingBlue, alpha: BubbleConstants.RGBAlpha.outgoingAlpha).resizableImageWithCapInsets(insetsOutgoing)
    let flippedImage = UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.UpMirrored)
    
    let incoming = coloredImage(flippedImage, red: BubbleConstants.RGBAlpha.incomingRed, green: BubbleConstants.RGBAlpha.incomingGreen, blue: BubbleConstants.RGBAlpha.incomingBlue, alpha: BubbleConstants.RGBAlpha.incomingAlpha).resizableImageWithCapInsets(insetsIncoming)
    
    return (incoming, outgoing)
}

func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {
    
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, CGBlendMode.SourceAtop)
    CGContextFillRect(context, rect)
    
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return result
    
}








