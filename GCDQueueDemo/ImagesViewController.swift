//
//  ViewController.swift
//  OfoDemo
//
//  Created by qwer on 2018/3/26.
//  Copyright © 2018年 qwer. All rights reserved.
//
import UIKit

let KW = UIScreen.main.bounds.size.width
let KH = UIScreen.main.bounds.size.height

class ImagesViewController: UIViewController {

    private let queue = OperationQueue()
    
    private lazy var scrollView:UIScrollView = {
       
        let scr = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: KW, height: KH))
        scr.showsVerticalScrollIndicator = false
        scr.showsHorizontalScrollIndicator = false
        scr.contentSize = CGSize.init(width: 0, height: scr.bounds.size.height * 10)
        self.view.addSubview(scr)
        return scr
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.addImage()
        
    }
    
    private func addImage(){
        let kw = UIScreen.main.bounds.size.width/5
        let col:Int = 5
        let row = (Int)(scrollView.contentSize.height/kw)
        
        let images:[String] = ["http://wx4.sinaimg.cn/orj360/8c0a0398gy1fhoe00rdo3j20sg0sg431.jpg","http://imgsrc.baidu.com/forum/w%3D580/sign=b9901833b21bb0518f24b320067bda77/4d3fd5cec3fdfc0382a2f7a9d53f8794a5c2260f.jpg"]
        
        var imageStr = "http://imgsrc.baidu.com/forum/w%3D580/sign=b9901833b21bb0518f24b320067bda77/4d3fd5cec3fdfc0382a2f7a9d53f8794a5c2260f.jpg"
        for kk in 0..<row * 5 {
            
            let rows:CGFloat = (CGFloat)(kk/col)  //所在的行
            let cols:CGFloat = (CGFloat)(kk%col)  //所在的列
            
            let imageV:UIImageView = UIImageView()
            
            imageV.frame = CGRect.init(x: cols*kw, y: rows*kw, width: kw, height: kw)
            self.scrollView.addSubview(imageV)
            imageV.backgroundColor = UIColor.red
            imageV.layer.cornerRadius = kw/2.0
            imageV.layer.masksToBounds = true
            
        }
        
        DispatchQueue.main.async {
            self.scrollView.subviews.forEach { (imageV) in
                
                if imageV.isKind(of: UIImageView.classForCoder()){
                    let imgV = imageV as! UIImageView
                    self.queue.addOperation({
                        // 11 = 3排第三个
                        imageStr = arc4random()%2 == 1 ? images[0]:images[1]
                        if let imageUrl = URL.init(string: imageStr) {
                            guard let imageData = try? Data.init(contentsOf: imageUrl) else{
                                return
                            }
                            //back to mainQueue reload Ui:
                            DispatchQueue.main.async {
                                imgV.image = UIImage.init(data: imageData)
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
