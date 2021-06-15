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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.5, execute: {
            self.setUpAnimation()
        })
     
    }
    private func setUpAnimation(){
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
          self.performSegue(withIdentifier: "main", sender: self)
 
//            let vc = ShopViewController()
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc,animated: true)
        })
             
      
        
    }
    

}
