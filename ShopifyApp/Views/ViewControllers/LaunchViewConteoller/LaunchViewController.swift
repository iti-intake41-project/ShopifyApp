//
//  LaunchViewController.swift
//  ShopifyApp
//
//  Created by Donia Ashraf on 6/15/21.
//

import UIKit
import Lottie
class LaunchViewController: UIViewController {
   let animatedView = AnimationView()
    private let imgView :UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imgView.image = UIImage(named: "clothes")
        return imgView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imgView)

//        // Do any additional setup after loading the view.
//        DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.5, execute: {
//            self.setUpAnimation()
//        })
     
    }
    override func viewDidLayoutSubviews() {

        imgView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animation()
        })
    }
    private func animation(){
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imgView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)

        })
        
        UIView.animate(withDuration: 1.5, animations: {
            self.imgView.alpha = 0
        },completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.performSegue(withIdentifier: "Main", sender: self)
//                    let vc = ShopViewController()
//                                vc.modalPresentationStyle = .fullScreen
//                                self.present(vc,animated: true)
                })
            }
            
        })
    }
    private func setUpAnimation(){
        //GIF
        animatedView.animation = Animation.named("animation")
        animatedView.frame = view.bounds
        animatedView.backgroundColor = .white
        animatedView.contentMode = .scaleAspectFit
        animatedView.loopMode = .loop
        animatedView.play()
        view.addSubview(animatedView)
        
//        UIView.animate(withDuration: 1.5, animations: {
//            self.animatedView.alpha = 0
//
//        })
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
      //    self.performSegue(withIdentifier: "main", sender: self)
 
//            let vc = ShopViewController()
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc,animated: true)
        })
             
      
        
    }
    

}
