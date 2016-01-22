//
//  ViewController.swift
//  WhaleTalk
//
//  Created by Anar Enhsaihan on 1/20/16.
//  Copyright © 2016 nomad. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    // UI
    private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
    private let newMessageArea = UIView()
    private let newMessageField = UITextView()

    // Model
    private var sections = [NSDate: [Message]]()
    private var dates = [NSDate]()
    
    // Constraints
    private var bottomConstraint : NSLayoutConstraint!
    
    // Constants
    private let cellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var localIncoming = true
        var date = NSDate(timeIntervalSince1970: 1100000000)
        
        for i in 0...10 {
            let m = Message()
            m.text = "This is a longer message, what happens if I do this? And then if I do this?"
            m.timeStamp = date
            m.incoming = localIncoming
            localIncoming = !localIncoming
            
            
            addMessage(m)
            
            if i % 2 == 0 {
                date = NSDate(timeInterval: 60 * 60 * 24, sinceDate: date)
            }
            
        }
        
        self.layoutMessageArea()
        
        self.configureTableView()
        
        self.addKeyboardObservers()
        
        self.addTapRecognizerToDismissKeyboard()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.scrollToBottom()
    }
    
    // MARK: View configuration and layout
    
    func layoutMessageArea() {
        
        newMessageArea.backgroundColor = UIColor.lightGrayColor()
        newMessageArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newMessageArea)
        
        newMessageField.translatesAutoresizingMaskIntoConstraints = false
        newMessageField.scrollEnabled = false
        newMessageArea.addSubview(newMessageField)
        
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.addTarget(self, action: Selector("pressedSend:"), forControlEvents: .TouchUpInside)
        newMessageArea.addSubview(sendButton)
        
        sendButton.setContentHuggingPriority(251, forAxis: .Horizontal)
        sendButton.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
        
        bottomConstraint = newMessageArea.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        bottomConstraint.active = true
        
        let messageAreaConstraints : [NSLayoutConstraint] = [
            
            newMessageArea.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            newMessageArea.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            newMessageArea.heightAnchor.constraintEqualToAnchor(newMessageField.heightAnchor, constant: 20),
            
            newMessageField.leadingAnchor.constraintEqualToAnchor(newMessageArea.leadingAnchor, constant: 10),
            newMessageField.centerYAnchor.constraintEqualToAnchor(newMessageArea.centerYAnchor),
            
            sendButton.trailingAnchor.constraintEqualToAnchor(newMessageArea.trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraintEqualToAnchor(newMessageField.centerYAnchor),
            
            newMessageField.trailingAnchor.constraintEqualToAnchor(sendButton.leadingAnchor, constant: -10)
            
        ]
        
        NSLayoutConstraint.activateConstraints(messageAreaConstraints)
    }
    
    func configureTableView() {
        
        tableView.registerClass(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            
            tableView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(newMessageArea.topAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
    }
    
    //MARK: Gesture Recognizer

    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addTapRecognizerToDismissKeyboard() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
    }
    
    //MARK: Constraint logic
    
    func updateBottomConstraint(notification: NSNotification) {
        if let
            userInfo = notification.userInfo,
            frame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue,
            animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                
                let newFrame = view.convertRect(frame, fromView: (UIApplication.sharedApplication().delegate?.window!))
                bottomConstraint.constant = newFrame.origin.y - CGRectGetHeight(view.frame)
                UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
                
                // scroll to bottom so appearance of keyboard won't obscure messages
                tableView.scrollToBottom()
        }
    }
    
    //MARK: Keyboard notifications
    
    func keyboardWillShow(notification: NSNotification) {
        self.updateBottomConstraint(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.updateBottomConstraint(notification)
    }
    
    func addKeyboardObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Message functionality
    
    func pressedSend(button: UIButton) {
        guard let text = newMessageField.text where text.characters.count > 0 else {return}
        let message = Message()
        message.text = text
        message.incoming = false
        message.timeStamp = NSDate()
        addMessage(message)
        newMessageField.text = nil
        tableView.reloadData()
        tableView.scrollToBottom()
        view.endEditing(true)
    }
    
    func addMessage(message: Message) {
        guard let date = message.timeStamp else {return}
        let calendar = NSCalendar.currentCalendar()
        let startDay = calendar.startOfDayForDate(date)
        
        var messages = sections[startDay]
        
        // if there are no messages for the day
        if messages == nil {
            dates.append(startDay)
            messages = [Message]()
        }
        messages!.append(message)
        sections[startDay] = messages
    }
}

extension ChatViewController : UITableViewDataSource {
    
    func getMessages(section: Int) -> [Message] {
        let date = dates[section]
        return sections[date]!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dates.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMessages(section).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell
        cell.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.size.width, 0, 0)
        
        let messages = getMessages(indexPath.section)
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        
        cell.incoming(message.incoming)
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
}











