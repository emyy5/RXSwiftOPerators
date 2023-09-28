//
//  ViewController.swift
//  RXSwiftLab2
//
//  Created by Eman Khaled on 28/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var myLabel: UILabel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOberver()
        
        // Function to simulate fetching the large array asynchronously
        func getLargeArray() -> Observable<[Int]> {
            return Observable.just(Array(1...1000))
                .delay(.seconds(1), scheduler: MainScheduler.instance) // Simulated delay
        }
        
        // Get the large array
        getLargeArray()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { array -> String in
                // Perform the required computations
                let firstElement = array.first ?? 0
                let count = array.count
                let sum = array.reduce(0, +)
                
                return "First Element: \(firstElement), Count: \(count), Sum: \(sum)"
            }
            .observe(on: MainScheduler.instance) // Switch to the main thread for UI updates
            .subscribe(onNext: { result in
                // Update your label with the combined result
                self.myLabel.text = result
                print(result)
            })
            .disposed(by: disposeBag)
    }
    
    
    
    
    // Create an Observable with values from 1 to 10
    func getOberver(){
        let obervable = Observable.from(1...10)
            .map { $0 * 5 } // Multiply all elements by 5
            .filter { $0 % 2 == 0 } // Choose the even numbers
            .skip(2) // Neglect the first 2 events
            .take(10) // Choose the first 10 elements after the neglection
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
        
    }
}


