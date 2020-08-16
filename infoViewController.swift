import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import MessageUI

class infoViewController: UIViewController, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var textView: UITextView!
    var documents : [QueryDocumentSnapshot] = []
    var tit = ""
    var tit2 = ""
    @IBOutlet weak var claimButton: UIButton!
    var correctDocument: QueryDocumentSnapshot? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        for data in documents {
            if data.get("Restaurant") as AnyObject? === self.tit as AnyObject && data.get("Meal") as AnyObject? === self.tit2 as AnyObject {
                correctDocument = data
                break
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       if Auth.auth().currentUser == nil {
           self.navigationItem.rightBarButtonItem = nil
       }
       else {
           self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutTapped))
       }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        claimButton.layer.cornerRadius = 15
        updateText()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        claimButton.backgroundColor = .green
        claimButton.setTitle("CLAIMED!", for: .normal)
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard!.instantiateViewController(identifier: "explore")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            self.correctDocument?.reference.updateData(["Units": self.correctDocument!.get("Units") as! Int - 1])
        }
        
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "keshav.cricket.8@gmail.com"
        smtpSession.password = "fakepassword1234"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "User", mailbox: Auth.auth().currentUser?.email)]
        builder.header.from = MCOAddress(displayName: "Sender", mailbox: "keshav.cricket.8@gmail.com")
        builder.header.subject = "Confirmation Email"
        var restaurant = correctDocument?.get("Restaurant") as! String
        var meal = correctDocument?.get("Meal") as! String
        var address = correctDocument?.get("Address") as! String
        builder.htmlBody="<p>Thank you for your order of " + meal + " from " +
             restaurant + ". Your code is: " + String(Int.random(in: 10000..<100000)) + ". Please use this code to claim your food at " + address + ". <br></br>Thank you for using Gratisfaction! </p>"
        
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(error)")
                
                
            } else {
                NSLog("Successfully sent email!")
                
                
            }
        }

    }
    
    func updateText() {
        textView.text = ""
        
        var meal = correctDocument!.get("Meal") as! String
        var restaurant = correctDocument!.get("Restaurant") as! String
        let address = correctDocument!.get("Address") as! String
        var units = correctDocument!.get("Units") as! Int
        var expiration = correctDocument!.get("Expiration") as! Int
        
        textView.text += "Meal: " + meal + "\n"
        textView.text += "\nRestaurant: "
        textView.text += restaurant + "\n"
        textView.text += "\nAddress: "
        textView.text += address + "\n"
        textView.text += "\nUnits: " + String(units) + "\n"
        textView.text += "\nExpiration: " + String(expiration) + "\n"
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.showsHorizontalScrollIndicator = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.storyboard!.instantiateViewController(identifier: "explore")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @IBAction func signOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          self.navigationItem.rightBarButtonItem = nil
        } catch let signOutError as NSError {
          let alertController = UIAlertController(title: "Error", message:
          "Hello", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
          self.present(alertController, animated: true, completion: nil)
        }
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

