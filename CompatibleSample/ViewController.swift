//
//  ViewController.swift
//  CompatibleSample
//
//  Created by tramp on 2021/4/1.
//

import UIKit
import Compatible

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        //        let queue: DispatchQueue = .init(label: "", qos: .default)
        //        let lock = NSLock.init()
        //        for item in 0 ..< 10 {
        //            queue.async {
        //                lock.lock()
        //                print("\(item)")
        //                print(Thread.current)
        //                lock.unlock()
        //            }
        //        }
        
        //        print(NSHomeDirectory())
        //        UserDefaults.init(suiteName: "0001")
        //        UserDefaults.init(suiteName: "0001")?.setValue("fasdfas", forKey: "fdafs")
        //        UserDefaults.init(suiteName: "0001")?.synchronize()
        //        UserDefaults.init(suiteName: "0002")
        //        UserDefaults.init(suiteName: "0002")?.setValue("fasdfas", forKey: "fdafs")
        //        UserDefaults.init(suiteName: "0002")?.synchronize()
        //        UserDefaults.init(suiteName: "0003")
        //        UserDefaults.init(suiteName: "0003")?.setValue("fasdfas", forKey: "fdafs")
        //        UserDefaults.init(suiteName: "0003")?.synchronize()
        //        UserDefaults.standard.setValue("fasdfas", forKey: "fdafs")
        //        UserDefaults.standard.synchronize()
        

        
        //        UserDefaults.shared(of: "A").hub.set("fsdfasdf", forKey: .name)
        //        let value = UserDefaults.shared(of: "A").hub.string(forKey: .name)
        //        print(value)
        //        UserDefaults.shared(of: "A").hub.set(Date.init(), forKey: .name)
        //        let value = UserDefaults.shared(of: "A").hub.date(forKey: .name)
        //        print(value)
    }
    
    
}

extension UserDefaults.Key {
    
    internal static let name: UserDefaults.Key  = .init(rawValue: "name")
}
