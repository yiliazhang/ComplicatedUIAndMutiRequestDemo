//
//  DemoViewController.swift
//  Demo
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class DemoViewController: YILListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configData()
    }

    func configData() {
        listManager.removeAll()
        let gridOne = CollectionManager("gridOne", request: Home.gridItem)
        let textOne = CollectionManager("textOne", request: Home.text)
        let imageOne = CollectionManager("imageOne", request: .image)
        let centerTextOne = CollectionManager("centerTextOne", request: .centerText)

        listManager.register([gridOne, textOne, centerTextOne, imageOne])
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
