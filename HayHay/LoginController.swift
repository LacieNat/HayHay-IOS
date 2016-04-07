//
//  LoginController.swift
//  HayHay
//
//  Created by Lacie on 3/25/16.
//  Copyright © 2016 Lacie. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinTap(sender: UIButton) {
        let un:NSString! = email.text;
        let pw:NSString! = password.text;
       
        //if username or password is empty throw error
        if(un.isEqualToString("") || pw.isEqualToString("")) {
            
            if #available (iOS 8.0, *) {
                let alert = UIAlertController(title: "Sign In Failed", message:"Please enter both username and password", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}
            } else {
                let alert = UIAlertView();
                alert.title = "Sign In Failed"
                alert.message = "Please enter both username and password"
                alert.addButtonWithTitle("OK")
                alert.show();
            }
        }
        
        //else process post request
        else {
            let nonce = ""
            let datahash = (un as String) + (pw as String)
            let hash = ((nonce as String) + datahash.sha1()).sha1()
            
            let params = ["email":un as String, "hhash": hash as String, "nonce": nonce as String] as Dictionary<String, String>
            let request = NSMutableURLRequest(URL: NSURL(string: "https://hayhaytheapp.com:443/user/login")!)
            let session = NSURLSession.sharedSession()
            
            request.HTTPMethod = "POST"
            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var ch:(NSData?, NSURLResponse?, NSError?)->Void = {(data, response, error) in
                let vc = (self.storyboard?.instantiateViewControllerWithIdentifier("LoginController"))! as UIViewController
                
                if(error != nil) {
                    if #available(iOS 8.0, *) {
                        let alert = UIAlertController(title: "Sign In Failed", message:"Connection Error", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                        self.presentViewController(alert, animated: true){}
                        print(error!.localizedDescription)
                    } else {
                        let alert = UIAlertView();
                        alert.title = "Sign In Failed"
                        alert.message = "Connection Error"
                        alert.addButtonWithTitle("OK")
                        alert.show()
                    }
                    
                    return
                }
                var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(strData)
                var json = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                
                if(json != nil) {
                    // The JSONObjectWithData constructor didn't return an error. But, we should still
                    // check and make sure that json has a value using optional binding.
                    if let parseJSON = json {
                        
                        var hasErrors = parseJSON!["err"] as? String
                        
                        if (hasErrors != nil) {
                            dispatch_async(dispatch_get_main_queue()) {
                                if #available (iOS 8, *) {
                                    let alert = UIAlertController(title: "Sign In Failed", message:"Wrong username or password", preferredStyle: .Alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                                    //                            vc.presentViewController(alert, animated: true){}
                                    self.showViewController(alert, sender: self.signIn)
                                } else {
                                    let alert = UIAlertView()
                                    alert.title = "Sign In Failed"
                                    alert.message = "Wrong username or password"
                                    alert.addButtonWithTitle("OK")
                                    alert.show()
                                }
                                
                            }
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController")
                            self.presentViewController(vc!, animated: true, completion:nil)
                            }
                        }
                    }
                        
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                }

            }

            var task = session.dataTaskWithRequest(request, completionHandler: ch)
            
            task.resume();
            
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joinWithSeparator("")
    }
}

extension NSMutableURLRequest {
    func setBodyContent(contentMap: Dictionary<String, String>) {
        var firstOneAdded = false
        var contentBodyAsString = String()
        let contentKeys:Array<String> = Array(contentMap.keys)
        for contentKey in contentKeys {
            if(!firstOneAdded) {
                
                contentBodyAsString = contentBodyAsString + contentKey + "=" + contentMap[contentKey]!
                firstOneAdded = true
            }
            else {
                contentBodyAsString = contentBodyAsString + "&" + contentKey + "=" + contentMap[contentKey]!
            }
        }
        contentBodyAsString = contentBodyAsString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        self.HTTPBody = contentBodyAsString.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
