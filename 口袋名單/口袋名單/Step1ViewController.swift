import UIKit

class Step1ViewController: UIPageViewController, UIPageViewControllerDataSource {
    lazy var viewcontrollerList: [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let step1VC = storyBoard.instantiateViewController(withIdentifier: "step1")
        let step2VC = storyBoard.instantiateViewController(withIdentifier: "step2")
        let step3VC = storyBoard.instantiateViewController(withIdentifier: "step3")
        return [step1VC, step1VC, step1VC]
    }()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let firstVC = viewcontrollerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewcontrollerList.index(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewcontrollerList.count > previousIndex else { return nil }
        return viewcontrollerList[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewcontrollerList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewcontrollerList.count != nextIndex else { return nil }
        guard viewcontrollerList.count >  nextIndex else { return nil }
        return viewcontrollerList[nextIndex]
    }
}
