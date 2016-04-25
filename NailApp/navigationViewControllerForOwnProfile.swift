import UIKit

class navigationViewControllerForOwnProfile: UINavigationController, TabBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didSelectTab(tabBarController: TabBarController) {
        print("navigationViewControllerForOwnProfile!")
        return
    }
}