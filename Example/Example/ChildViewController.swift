//
//  ChildViewController.swift
//  Example
//
//  Created by moon.kwon on 2022/06/03.
//

import UIKit
import HeadPageKit

class ChildViewController: UIViewController, HeadPageChildViewController {
    @IBOutlet private weak var tableView: UITableView!
    var childScrollView: UIScrollView { tableView }
    
    static func createInstance(bg: UIColor) -> ChildViewController {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let vc = sb.instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        vc.view.backgroundColor = bg
        return vc
    }
}
