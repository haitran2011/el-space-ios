//
//  Created by Bartlomiej Guminiak on 08/06/2017.
//  Copyright © 2017 El Passion. All rights reserved.
//

protocol ScreenFactoring {

    func loginViewController() -> LoginViewController
    func selectionViewController() -> SelectionViewController

    func messageAlertController(message: String) -> UIAlertController
}

class ScreenFactory: ScreenFactoring {

    func loginViewController() -> LoginViewController {
        return LoginViewController()
    }

    func selectionViewController() -> SelectionViewController {
        return SelectionViewController()
    }

    func messageAlertController(message: String) -> UIAlertController {
        return UIAlertController.messageAlertViewController(with: message)
    }

}
