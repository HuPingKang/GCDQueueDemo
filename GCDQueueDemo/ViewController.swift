//
//  ViewController.swift
//  GCDQueueDemo
//
//  Created by qwer on 2018/3/19.
//  Copyright © 2018年 qwer. All rights reserved.
//

/**
 *  Diff between SerialQueue and ConcurrentQueue
 *  1.SerialQueue:MainQueue and Create new SerialQueue
 *  2.ConcurrentQueue:GlobalQueue and Create new ConcurrentQueue
 *
 *  System provide a SerialQueue(MainQueue) and four ConcurrentQueue(DISPATCH_QUEUE_PRIORITY_HIGH/DEFAULT/LOW/BACKGROUND)
 *  diff:
 *      SerialQueue:
 *              1.only one task to be executed at a time;
 *              2.serial visit a shared resource
 *              3.serial executed tasks on syncQueue
 *      ConcurrentQueue:
 *              1.more than one task to be executed at a time
 *              2.visit a shared resource without serial
 *              3.task executed no serial
 ***
 *   OperationQueue: based on GCD,better than GCD;(NSBlockOperation/NSInvocationOperation)
 *          1.not serial on FIFO: by set priority level and relations between OperationQueues to control codes executed seriel;
 *      OperationQueues's cancel function:
 *              1.if your task finished,cancel function will be of no effect;
 *              2.if your task on executing,cancel function will not make your task cancelled,but set the property of cancel to be true
 *              3.if your task waiting for executing, your task will cancel;
 *      OperationQueues properties:isCancelled/isExecuting/isFinished/isReady;
 */


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainSyncBtn: UIButton!
    @IBOutlet weak var globalAsyncBtn: UIButton!
    
    @IBOutlet weak var serialASyncBtn: UIButton!
    @IBOutlet weak var concurrentAsyncBtn: UIButton!
    
    @IBOutlet weak var imgVOne: UIImageView!
    @IBOutlet weak var imgVTwo: UIImageView!
    @IBOutlet weak var imgVThr: UIImageView!
    @IBOutlet weak var imgVFor: UIImageView!
    
    //
    private var queue:OperationQueue? = OperationQueue()
    
    @IBOutlet weak var opAsyncBtn: UIButton!
    @IBOutlet weak var opSyncBtn: UIButton!
    
    
    private var imageVs:[UIImageView] {
        
        return  [self.imgVOne,self.imgVTwo,self.imgVThr,self.imgVFor]
    }
    
    private var images:[String]{
        let iges:[String] = ["http://pic1.win4000.com/wallpaper/8/599d1d6647c92.jpg","http://pic1.win4000.com/wallpaper/8/599d1d68dcc0f.jpg","http://pic1.win4000.com/wallpaper/8/599d1d6e8b589.jpg","http://pic1.win4000.com/wallpaper/8/599d1d6647c92.jpg"]
        
        return iges;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btns:[UIButton] = [self.mainSyncBtn,self.serialASyncBtn,self.globalAsyncBtn,self.concurrentAsyncBtn,self.opSyncBtn,self.opAsyncBtn
        ]
        
        btns.forEach { (bt) in
            bt.layer.cornerRadius = 5
            bt.layer.masksToBounds = true
            bt.isEnabled = false
        }
        
        //Create an original Request of GET
        let getUrl = URL.init(string: "http://api-pre.well-talent.com.cn/listening/courses?userAccountId=0&salt=0")
        let getRequest = NSMutableURLRequest.init(url: getUrl!)
        getRequest.httpMethod = "GET"
        let session:URLSession = URLSession.shared
        let downloadTask = session.dataTask(with: getUrl!) { (json, response, error) in
            print("GET请求结束")
        }
        //start task；
        downloadTask.resume()
        
        //Create an original Request of POST: username=520it&pwd=520it&type=JSON
        let postUrl = URL.init(string: "http://api-pre.well-talent.com.cn/listening/login/mobilepwd")
        let request = NSMutableURLRequest.init(url: postUrl!)
        request.httpMethod = "POST"
        request.httpBody = "mobile=fVBYI1AEYE9wB4667ad0NxDXuPXCDl7HX9HQ59mbJbuCylpupoH011B0HP+PWwIYlC0zTkU5drfSEmTl/YJpIo4ODcQOBHklSEzzZFp91mOlLW33fAd/dLyhi+b29azwB+o9QhKU971Nxcoi24oENY+OGI7odz2GX/PjuAvgUhw=&password=Pk5C31JJl3op/1ZzsFnf05T/QSY21TVzFWxQw/+4nt1BYFeHbCmLQMgJcwEl5HvFfub/Y6IO9QRTGMuKFb2b+bh4rOvHr0giaP2llTMuYk4+/2DuePTqFfPKeAALbt72LVyd1mNK4Ffv4nUwiKNk4iB4EkJqW0kAfkakkqLUsHw=".data(using: .utf8)
        let postData = session.dataTask(with: postUrl!) { (json, response, error) in
            print("POST请求结束")
            
            //the URLSession Executed on concurrentQueue not on MainQueue,so all Ui reload tasks must back to mainQueue:
            DispatchQueue.main.async {
                btns.forEach({ (bt) in
                    bt.isEnabled = true
                })
            }

        }
        postData.resume()
        
    }

    @IBAction func mainSync(_ sender: Any) {
        
        //On MainQueue loading Images From Internet:
        for kk in 0..<self.images.count {
            
            let imageStr = self.images[kk]
            if let imageUrl = URL.init(string: imageStr) {
                
                let imageData = try? Data.init(contentsOf: imageUrl)
                imageVs[kk].image = UIImage.init(data: imageData!)
                print(kk)
            }
            
        }
        
        print("all task on mainQueue execute finished")
        
    }
    
    @IBAction func globalAsync(_ sender: Any) {
        
        //On GlobalQueue loading images from internet:
        for kk in 0..<self.images.count {
            
            DispatchQueue.global().async {
                let imageStr = self.images[kk]
                if let imageUrl = URL.init(string: imageStr) {
                    
                    let imageData = try? Data.init(contentsOf: imageUrl)
                    //back to mainQueue reload Ui:
                    DispatchQueue.main.async {
                        self.imageVs[kk].image = UIImage.init(data: imageData!)
                        print(kk)
                    }
                    
                }
                
            }
        }
        
        print("all task on globalQueue execute finished")
        
    }
    
    //
    @IBAction func serialAsync(_ sender: Any) {
        
        //create a serial queue and serial executed tasks:
        let serialQueue = DispatchQueue(label: "com.apple.imagesQueue")
        
        for kk in 0..<self.images.count {
            serialQueue.async {
                let imageStr = self.images[kk]
                if let imageUrl = URL.init(string: imageStr) {
                    
                    let imageData = try? Data.init(contentsOf: imageUrl)
                    //back to mainQueue reload Ui:
                    DispatchQueue.main.async {
                        self.imageVs[kk].image = UIImage.init(data: imageData!)
                        print(kk)
                    }
                }
            }
        }
    }
    
    @IBAction func concurrentAsync(_ sender: Any) {
        
        //create a concurrent queue and concurrent executed tasks:
        //six priority level of GCD: background,utility,userInitiated,unspecified,default,userInteractive (low->high)
        //create a concurrentQueue:
       let concurrentQueue = DispatchQueue.init(label: "com.apple.images", qos: .background, attributes: .concurrent)
        for kk in 0..<self.images.count {
            concurrentQueue.async {
                let imageStr = self.images[kk]
                if let imageUrl = URL.init(string: imageStr) {
                    let imageData = try? Data.init(contentsOf: imageUrl)
                    //back to mainQueue reload Ui:
                    DispatchQueue.main.async {
                        self.imageVs[kk].image = UIImage.init(data: imageData!)
                        print(kk)
                    }
                }
            }
        }
    }
    
    @IBAction func opQueue(_ sender: Any) {
        
        //add operation on main thread
//        OperationQueue.main.addOperation {
//            print(Thread.current == Thread.main) //true
//        }
//        OperationQueue.current?.addOperation({
//            print(Thread.current == Thread.main) //true
//        })
//        return
        
        for kk in 0..<self.images.count {
     
            queue?.addOperation({
                let imageStr = self.images[kk]
                if let imageUrl = URL.init(string: imageStr) {
                    let imageData = try? Data.init(contentsOf: imageUrl)
                    //back to mainQueue reload Ui:
                    DispatchQueue.main.async {
                        self.imageVs[kk].image = UIImage.init(data: imageData!)
                        print(kk)
                    }
                }
            })
        }
    }
    
    @IBAction func blockASync(_ sender: Any) {

        //Create two blockQueue:
//        let blockQueue1 = BlockOperation.init {
//        }
//        let blockQueue2 = BlockOperation.init {
//        }
        
//    *** set priority of queue: high level,first executed;
//        blockQueue2.queuePriority = .veryHigh
//        blockQueue1.queuePriority = .veryLow

//        set dependency will more effective than set queuePriority;
//        set dependency: blockQueue2 will executed before blockQueue1;
//        blockQueue1.addDependency(blockQueue2)
       // FIFO:
       // blockQueue add to queue,blockQueue task will be executed;
//         if blockQueue not add to queue,blockQueue's task will be executed on main thread;
//        addOperation() and start() functions cannot used at the sametime;

        //addOperation():blockQueue's task will be executed on Sub thred;
//        self.queue?.addOperation(blockQueue1)
//        self.queue?.addOperation(blockQueue2)
//
//        blockQueue2.completionBlock = {
//            print("blockQueue2 executed completed \(Thread.current) \(Thread.main)")
//        }
//        blockQueue1.completionBlock = {
//            print("blockQueue1 executed completed \(Thread.current) \(Thread.main)")
//        }
//
//        blockQueue2.addExecutionBlock {
//            print("blockQueue2 add other tasks")
//        }
        
        //executed start() function, blockQueue task executed will block main Thread;
//        blockQueue2.start()
//        blockQueue1.start()
        
//        return;
        
        for kk in 0..<self.images.count {
        
            let operation = BlockOperation.init(block: {
                let imageStr = self.images[kk]
                if let imageUrl = URL.init(string: imageStr) {
                    let imageData = try? Data.init(contentsOf: imageUrl)
                    //back to mainQueue reload Ui:
                    DispatchQueue.main.async {
                        self.imageVs[kk].image = UIImage.init(data: imageData!)
                        print(kk)
                    }
                }
            })
            
            queue?.addOperation(operation)
            //if the task not executed, the completionBlock will also be executed;
            operation.completionBlock = {
                print("operation finished")
            }
            
            //cancel waiting tasks:
            //self.queue?.operations.last?.cancel()
            
        }
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

