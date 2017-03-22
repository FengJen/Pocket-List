//
//  Step2ViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/22.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit

class Step2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func toPage3Button(_ sender: UIButton) {
        sender.addTarget(self, action: #selector(presentStep2), for: .touchUpInside)
    }
    
    func presentStep2() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "step3")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
