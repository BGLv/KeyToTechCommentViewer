//
//  InputBoundsViewController.swift
//  KeyToTechCommentViewer
//
//  Created by Bogdan Lviv on 9/16/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import UIKit

class InputBoundsViewController: UIViewController {
    
    //IBOutlets that holds user input of lower and upper bounds for id of the comments to display
    @IBOutlet weak var lowerBoundTextField: UITextField!
    @IBOutlet weak var upperBoundTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //validate user imput for bounds when user change value of text field
    @IBAction func validateUserEnterInTextFields(_ sender: Any){
        if let boundTextField = sender as? UITextField{
            do{
                boundTextField.text = try boundTextField.validateText(validationType: ValidatorType.commentIdBound)
            } catch (let error){
                showErrorAlert(for: (error as! ValidationError).message)
                boundTextField.text = ""
            }
        }
    }
    
    //show alert when some error happens
    func showErrorAlert(for message: String){
        let alertC = UIAlertController(title: "Error !", message: message, preferredStyle: .alert)
        let closeAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertC.addAction(closeAlertAction)
        self.present(alertC, animated: true, completion: nil)
    }
    
    // perform segue to comments table view
    @IBAction func showCommentsButtonPressed(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UITextField {
    func validateText(validationType: ValidatorType) throws -> String {
        let validator = ValidatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}
