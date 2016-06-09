//
//  ViewController.swift
//  SocketDemo
//
//  Created by IOS Developer on 30/05/2016.
//  Copyright © 2016 Slash Global. All rights reserved.
//

import UIKit
import SocketIOClientSwift
import Fabric
import Crashlytics



class ViewController: UIViewController {
    
    @IBOutlet weak var lblDiscnt: UILabel!
    @IBOutlet weak var btnreconnect: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnLogin: UIButton!

    
    
    var socketConnect  = SocketIOClient(socketURL: NSURL(string: "http://localhost:3000/")!, options: ["ReconnectWait": 5])
    
    var list = ["User1","User2","User3","User4","User5"]
    
   
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.notification()
        
        Fabric.with([Crashlytics.self])
        
      
        
        // TODO: Track the user action that is important for you.
        
        Answers.logContentViewWithName("Tweet", contentType: "Video", contentId: "1234", customAttributes: ["Favorites Count":20, "Screen Orientation":"Landscape"])
        socketConnect.connect()

        socketConnect.on("connect") { data in
            
          self.lblDiscnt.backgroundColor = UIColor.greenColor()
            self.lblDiscnt.text = "Socket Connect"
            
        }
        
       socketConnect.on("reconnect") { data in
        
        self.lblDiscnt.text = "Socket Reconnect"
        print("reconnect")
        
        }
        
        socketConnect.on("error") { data in
            self.lblDiscnt.backgroundColor = UIColor.redColor()
            self.lblDiscnt.text = "Socket Disconnect"
            print("error")
            
        }

        socketConnect.on("reconnectAttempt") { data in
            
            self.lblDiscnt.text = "reconnectAttempt"
            print("reconnectAttempt")
        }

        self.socketConnect.on("haris") { data,ack in
            print(data[0])
        }
    socketConnect.onAny { socketAnyEvent in
         print("socketAnyEvent")
        }
        
        

 NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(self.printNotification()), name:"notification1", object: nil)
       let b = NSNotificationQueue.defaultQueue()
        print(b)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnLogin(sender: AnyObject) {
        
        self.socketConnect.emit("print",self.list)
 
    }
    
    @IBAction func btnLogout(sender: AnyObject) {
        
        let myname = "Haris"
        
        socketConnect.emit("log",myname)
        
        socketConnect.once("callOne") { data, ack in
            print(data)
            print(ack)
            
            print("callOne")
            
            
        }
        
    }
    
    
    
    @IBAction func btnReconnect(sender: AnyObject) {
        
        socketConnect.on("log1") { data, ack in
            print(data)
        }
        

           }
    
    
    func notification(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("notification1", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("notification2", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("notification3", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("notification4", object: nil)
        
    }
    
    func printNotification(){
        
        print("notification1")
        
    }
    
    
}

