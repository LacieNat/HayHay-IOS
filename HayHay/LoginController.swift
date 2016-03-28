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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinTap(sender: UIButton) {
        var un:NSString! = email.text;
        var pw:NSString! = password.text;
       
        //if username or password is empty throw error
        if(un.isEqualToString("") || pw.isEqualToString("")) {
            let alert = UIAlertController(title: "Sign In Failed", message:"Please enter both username and password", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
        
        //else process post request
        else {
            let nonce = ""
            let datahash = (un as String) + (pw as String)
            let hash = ((nonce as String) + datahash.sha1()).sha1()
            
            var params = ["email":un as String, "hhash": hash as String, "nonce": nonce as String] as Dictionary<String, String>
            var request = NSMutableURLRequest(URL: NSURL(string: "https://hayhaytheapp.com:443/user/login")!)
            var session = NSURLSession.sharedSession()
            
            request.HTTPMethod = "POST"
            //request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setBodyContent(params)
            

            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                print("Response: \(response)")
                
                if(error != nil) {
                    print(error!.localizedDescription)
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: '\(jsonStr)'")
                    return
                }
                
                var json = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                if(json != nil) {
                    // The JSONObjectWithData constructor didn't return an error. But, we should still
                    // check and make sure that json has a value using optional binding.
                    if let parseJSON = json {
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        var success = parseJSON!["success"] as? Int
                        print("Succes: \(success)")
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                }
            })
            
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
