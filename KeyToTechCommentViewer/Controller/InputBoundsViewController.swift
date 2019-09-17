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
    @IBOutlet weak var showCommentsButton: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //starts with disabled showCommentsButton
        disableShowCommentsButton()
        
        
    }
    
    
    func disableShowCommentsButton(){
        showCommentsButton.isEnabled = true
        showCommentsButton.layer.opacity = 0.25
    }
    
    func enableShowCommentsButton(){
        showCommentsButton.isEnabled = true
        showCommentsButton.layer.opacity = 1
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

    
    @IBAction func editingEnd(_ sender: Any) {
        self.resignFirstResponder()
        if let loverBoundText = lowerBoundTextField.text, let upperBoundText = upperBoundTextField.text{
            if let loverBoundInt = Int(loverBoundText), let upperBoundInt = Int(upperBoundText){
                if  loverBoundInt >= upperBoundInt{
                    showErrorAlert(for: "Upper bound must be greater than lover!")
                    upperBoundTextField.text=""
                    disableShowCommentsButton()
                }else{
                    enableShowCommentsButton()
                }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "showCommentSegue" == segue.identifier {
            if let commentsTVC = segue.destination as? CommentsTableViewController{
                if let lowerBoundInt = Int(lowerBoundTextField.text ?? ""), let upperBoundInt = Int(upperBoundTextField.text ?? ""){
                    //init TVC with user input data
                    commentsTVC.startCommentId = lowerBoundInt
                    commentsTVC.totalLimit = upperBoundInt - lowerBoundInt
                }
            }
        }
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
