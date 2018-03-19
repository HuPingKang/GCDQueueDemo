//
//  ViewController.swift
//  GCDQueueDemo
//
//  Created by qwer on 2018/3/19.
//  Copyright © 2018年 qwer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainSyncBtn: UIButton!
    @IBOutlet weak var globalAsyncBtn: UIButton!
    @IBOutlet weak var imgVOne: UIImageView!
    @IBOutlet weak var imgVTwo: UIImageView!
    @IBOutlet weak var imgVThr: UIImageView!
    @IBOutlet weak var imgVFor: UIImageView!
    
    private var images:[String]{
        let iges:[String] = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521446901598&di=e655ad1a74a7bd149832481865ff8a5e&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F018d4e554967920000019ae9df1533.jpg%40900w_1l_2o_100sh.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521446961362&di=b60930a4167ec65218c54e391bc2d098&imgtype=0&src=http%3A%2F%2Fpic48.nipic.com%2Ffile%2F20140825%2F11624852_152638235000_2.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521446961361&di=0873449e0d459cbea10ec5690a8d4293&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01690955496f930000019ae92f3a4e.jpg%402o.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521446961361&di=d5a96db0939b34e1d797f6a886c686d0&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01d881579dc3620000018c1b430c4b.JPG%403000w_1l_2o_100sh.jpg"]
        
        return iges;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainSyncBtn.layer.cornerRadius = 5
        self.mainSyncBtn.layer.masksToBounds = true
        self.globalAsyncBtn.layer.cornerRadius = 5
        self.globalAsyncBtn.layer.masksToBounds = true
        
    }

    @IBAction func mainSync(_ sender: Any) {
        
        let imageVs:[UIImageView] = [self.imgVOne,self.imgVTwo,self.imgVThr,self.imgVFor];
        //On MainQueue loading Images From Internet:
        for kk in 0..<self.images.count {
            
            let imageStr = self.images[kk]
            if let imageUrl = URL.init(string: imageStr) {
                
                let imageData = try? Data.init(contentsOf: imageUrl)
                imageVs[kk].image = UIImage.init(data: imageData!)
                
            }
            
        }
        
        print("all task on mainQueue execute finished")
        
    }
    
    @IBAction func globalAsync(_ sender: Any) {
        
        let imageVs:[UIImageView] = [self.imgVOne,self.imgVTwo,self.imgVThr,self.imgVFor];
        
        //On GlobalQueue loading images from internet:
        DispatchQueue.global().async {
            for kk in 0..<self.images.count {
                
                let imageStr = self.images[kk]
                if let imageUrl = URL.init(string: imageStr) {
                    
                    let imageData = try? Data.init(contentsOf: imageUrl)
                    //back to mainQueue reload Ui:
                    DispatchQueue.main.async {
                        imageVs[kk].image = UIImage.init(data: imageData!)
                    }
                    
                }
                
            }
        }
        
        print("all task on globalQueue execute finished")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

