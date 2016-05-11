//
//  ViewController.swift
//  rsuv3RepeaterController
//
//  Created by Marty on 1/31/16.
//  Copyright © 2016 Marty. All rights reserved.
//
//  The receiving data from Bluetooth was developed with much help from Jari Isohanni
//           func dataReceived(notification: NSNotification)
//           func processReceivedData()
//
// * UV-RS3 Repeater Controller
// * We invest time and resources providing this open source code,
//   please support them and open-source hardware by purchasing
//   products from HobbyPCB!
//
//    Version 1.6 fix receiving elements that are blank after a key
//                Add process to receive VOX Sensitivity and Level


import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate {
    
    @IBOutlet weak var lineZeroImageView: UILabel!
    @IBOutlet weak var lineOneImageView: UILabel!
    @IBOutlet weak var lineTwoImageView: UILabel!
    @IBOutlet weak var lineThreeImageView: UILabel!
    @IBOutlet weak var imgBluetoothStatus: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var callsignTextField: UITextField!
    @IBOutlet weak var textFieldBottonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    @IBOutlet weak var buttonOneConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonFourConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonSevenConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonAstericsConstraint: NSLayoutConstraint!
    
/************************************************************
*                  menus
************************************************************/
    
    let functionMenus:[String] = ["Set Rx Freq", "Set Tx Freq", "Set Sqlch Level","Tone Sqlch Mode", "Set CTCSS",
        "Repeater ON/OFF", "BEEP ON/OFF", "Fan ON/OFF","Set Clock","Set Volume",
        "Display System Info", "Reset RS-UV3", "Set Call Sign", "Transmit Call Sign ","Set Hang Timer",
        "Set ID Timer", "Set Time Out Timer ", "Toggle Transmitter ","Toggle DTMF Detect ", "Set Code Speed"]
    
/**********************************************************
     CTCSS Array
**********************************************************/
    
    let CTCSStableF:[Float] = [ 67.0 , 69.3 , 71.9 , 74.4 , 77.0 , 79.7 , 82.5 , 85.4 ,
        88.5 , 91.5 , 94.8 , 97.4 , 100.0, 103.5, 107.2, 110.9,
        114.8, 118.8, 123.0, 127.3, 131.8, 136.5, 141.3, 146.2,
        151.4, 156.7, 159.8, 162.2, 165.5, 167.9, 171.3, 173.8,
        177.8, 179.9, 183.5, 186.2, 189.9, 192.8, 196.6, 199.5,
        203.5, 206.5, 210.7, 218.1, 225.7, 229.1, 233.6, 241.8,
        250.3, 254.1]
    
/***********************************************************
                  Constants
***********************************************************/

    let dataUpdateMsg:String = "Request sent to repeater"
    let menuFunctionSelectionLabel:String = "Function Selection"
    let menuLineTwoSquelchTxt:String = "Squelch = "
    let menuLineThreeAorBtxt:String = "Press A or B"
    let menuLineThreeAorBorCorDtxt:String = "Press A B C+50 D-50"
    let menuZeroTextField:String = "RS-UV3 Controller"
    let menuZeroTextFieldUnitA:String = "RS-UV3 Controller          A"
    let menuZeroTextFieldUnitB:String = "RS-UV3 Controller          B"
    let txtBeepSwitchEqual:String = "Beep = "
    let txtCTCSS:String = "CTCSS = "
    let txtDTMFequal:String = "DTMF = "
    let txtFanSwitchEqual:String = "Fan = "
    let txtITcmd:String = "IT "
    let txtOff:String = "OFF"
    let txtOn:String = "ON"
    let txtPressAtoToggle:String = "Press A to toggle"
    let txtPressStar:String = "Press * to send the time"
    let txtRepeaterSwitchEqual:String = "Repeater = "
    let txtSaveSquelch:String = "SquelchSave: "
    let txtSpace16:String = "                "
    let txtSpacce11:String = "          "
    let txtSpaceOne:String = " "
    let txtSquelch:String = "Squelch"
    let txtToneSquelchMode:String = "Mode = "
    let txtFreqBad:String = "Frequency out of band"
    let txtVolume:String = "Volume = "
    let txtWarning:String = "WARNING Reset Board"
    let txtPressStarReset:String = "Press * to confirm"
    let txtPressHashtag:String = "Press # to cancel"
    let unitATextField:String = "A"
    let unitBTextField:String = "B"
    let unitCTextField:String = "C"
    let unitDTextField:String = "D"
    let txtXmitterState:String = "xmitterState = "
    let txtCodeSpeed:String = "Codes speed = "
   
    // UV3 Set Value Commands
    let beepCmd:String = "Beep: "
    let callSignCmd:String = "CL "
    let fanCmd:String = "Fan: "
    let menuMax:Int = 20
    let menuMin:Int = 1
    let repeaterCmd:String = "Repeater: "
    let squelchCmd:String = "SQ "
    let tfCmd:String = "TF "
    let timeCmd:String = "T:"
    let toneSquelchModeCmd:String = "TM "
    let unitAcmd:String = "unitA "
    let unitBcmd:String = "unitB "
    let volumeCmd:String = "VU"
    

    
 /**********************************************************
                 Global variables
 **********************************************************/
    
    var squelchValue:Int = 9
    var toneSquelchModeValue:Int = 0
    var ctcssValue:String = "000.0"
    var ctcssIndex:Int = 0
    var volumeValue:String = "01"
    var lastKeyPressed:String = ""
    var codeSpeed:Int = 21
    
    // Global variables
    
    var rxTextField:String = "RX: "
    var txTextField:String = "TX: "
    var boardAtempText:String = " "
    var boardBtempText:String = " "
    var txtCallSign:String = " "
    
    var arduinoDate:String = ""
    var arduinoTime:String = ""
    var clockTimeZone:String = ""
    var hangTime:Int = 0
    var idTime:Int = 0
    var idTimeCmd:String = ""
    var inputBuffer:String = ""
    var inputCharCtr:Int = 0
    var lineBuffer:String = ""
    var menuIndex:Int = 0
    var receivedDataString:String = ""
    var subMenuIndex = 0
    var subMenuIndexTwo:Int = 0
    var timeOutTimer:Int = 0
    var timeOutTimerCmd:String = ""
    var toggleValue:Int = 0
    
    //   Boleans
    var beepSwitch:Bool = true
    var disableAlphaKeys:Bool = false
    var disableAkey:Bool = false
    var disableBkey:Bool = false
    var disableCkey:Bool = false
    var disableDkey:Bool = false
    var DTMFstate:Bool = false
    var fanSwitch:Bool = true
    var repeaterSwitch:Bool = true
    var saveData:Bool = false
    var unitSwitch:Bool = true
    var sendHello:Bool = true

/******************************************************
              Data Array 
******************************************************/
     
    var dataArray:[String] = []
    var dataArrayIndex:Int = 0
    var dataArrayMaxEntries:Int = 36
    
/*************************************************************
           VIEW DID LOAD
*************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        
        enum UIUserInterfaceIdiom : Int
        {
            case Unspecified
            case Phone
            case Pad
        }
        
        struct ScreenSize
        {
            static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
            static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
            static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
            static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        }
        
        struct DeviceType
        {
            static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
            static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
            static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
            static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
            static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        }
        if DeviceType.IS_IPHONE_6 {
            self.buttonOneConstraint.constant = 100
            self.buttonFourConstraint.constant = 100
            self.buttonSevenConstraint.constant = 100
            self.buttonAstericsConstraint.constant = 100
//          print("IS_IPHONE_6")
        }

        
        if DeviceType.IS_IPHONE_6P {
            self.buttonOneConstraint.constant = 120
            self.buttonFourConstraint.constant = 120
            self.buttonSevenConstraint.constant = 120
            self.buttonAstericsConstraint.constant = 120
//          print("IS_IPHONE_6P")
        }
         // Define the delegates and dataSources
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.callsignTextField.delegate = self
   
        // Intialize the dataArray
        for _ in 1...dataArrayMaxEntries {
         dataArray.append("XX XXXX")
        }
   
        
        // Display the main screen
        displayMenuZero()
        
        // Watch Bluetooth connection
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.connectionChanged(_:)), name: BLEServiceChangedStatusNotification, object: nil)

        // Watch for received data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.dataReceived(_:)), name: BLEReadDataNotification, object: nil)

        btDiscoverySharedInstance

     }
/******************************************
      DID MEMORY WARNING
******************************************/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**************************************************
     Text Field Processing
     **************************************************/
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Dimiss keyboard
        self.callsignTextField.resignFirstResponder()
    }
    

    // Textfield delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // Animate the textfield up over the keyboard
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(1, animations: {
            
            // Change the constant of the constraint for the textfield
            self.textFieldBottonConstraint.constant = 100
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        // When user has finished editing the textfield
        self.dataArray[18] = "CL: " + self.callsignTextField.text!

        // Reload the tableview
        self.tableView.reloadData()
        
        // Dismiss keyboard
        self.dismissKeyboard()
        
        // Reset Menu indexes
        menuIndex = 0
        subMenuIndex = 0
        
        displayMenuZero()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // When user has finished editing the textfield
        self.txtCallSign = self.callsignTextField.text!
        
        // send the new call sign to thwe UV3
        let tempString:String = callSignCmd + self.callsignTextField.text!
        sendChars(tempString)
        
        
        // Load the table entry
        dataArray[18] = "CL: " + self.callsignTextField.text!
        
        // Reload the tableview
        self.tableView.reloadData()
        
        
        // Dismiss keyboard
        self.dismissKeyboard()
        
        // End the editing
        self.callsignTextField.endEditing(true)
        
        // Display the Sent to UV3 message
        self.lineThreeImageView.text = self.dataUpdateMsg
        
        // Reset the menuIndex and subMenuIndex
        menuIndex = 0
        subMenuIndex = 0
        
        // Display the main menu in 3 seconds
        delay(3){
            self.displayMenuZero()
        }
        
        return true
    }
    
    func dismissKeyboard() {
        
        // Dismiss the keyboard
        self.callsignTextField.resignFirstResponder()
        
        // Animate the constraint so that the textfield goes back to the original position
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(1, animations: {
            
            // Change the constant of the constraint for the textfield
            self.textFieldBottonConstraint.constant = 850
            self.view.layoutIfNeeded()
        })
        
    }
    
    func popKeyboard(){
        // Animate the textfield up over the keyboard
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(1, animations: {
            
            // Change the constant of the constraint for the textfield
            self.textFieldBottonConstraint.constant = 100
            self.view.layoutIfNeeded()
        })
        
    }
    
/*************************************************************
       Process Main Index
**************************************************************/
    
    // Mark: Main menu method
    func processMenuIndex() {
        
        // Process used to display the first menu of function
        // Determine first line of menu
        //Then display the submenu function
        
        // if not menu zero display function selection
        if (menuIndex > 0) {
            self.lineZeroImageView.text = menuFunctionSelectionLabel
        }
        
        // Display the second line of the menu
        self.lineOneImageView.text = functionMenus[menuIndex  - 1]
        
        // Display the third line of the display
        // if not menu zero display function number line
        if (menuIndex > 0) {
            self.lineTwoImageView.text = "Enter Fn " + String(menuIndex)
        }
    }
    
 /*********************************************************************
            Display Main screen - menu index and submenu inde = Zero
**********************************************************************/
    // Mark:  menu zero or main screen - displayed when app starts and when a sub  menu is done

    func displayMenuZero(){
        if (self.unitSwitch == true) {
            self.lineZeroImageView.text = self.menuZeroTextFieldUnitA
            self.lineOneImageView.text = self.rxTextField + self.txtSpace16 + self.boardAtempText
        }
        else {
            self.lineZeroImageView.text = self.menuZeroTextFieldUnitB
            self.lineOneImageView.text = self.rxTextField + self.txtSpace16 + self.boardBtempText
        }
        self.lineTwoImageView.text = self.txTextField
        self.lineThreeImageView.text = ""
        menuIndex = 0
        subMenuIndex = 0
        
    }
    
/*************************************************************
     Display Clock
**************************************************************/
   
    func displayClockMenu() {
        
        // Display the menu title from the table on first line
        self.lineZeroImageView.text = functionMenus[subMenuIndex - 1] + " to UTC"
        
        // get the date and time

        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        var convertedDate = dateFormatter.stringFromDate(currentDate)

        // ensure display is for UTC
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm:ss"
        let convertedTime = dateFormatter.stringFromDate(currentDate)
        arduinoTime = convertedTime
        
        dateFormatter.dateFormat = "MM/dd/yy"
        convertedDate = dateFormatter.stringFromDate(currentDate)
        arduinoDate = convertedDate

        // display the time
        lineOneImageView.text = convertedTime + "    " + convertedDate
        
        // Blan line three
        lineTwoImageView.text = txtSpaceOne
        
        // Display line four
        lineThreeImageView.text = txtPressStar
        
    }

    
/***************************************************************************
     
   ***********************
   * Function Selection  *
   * Title               *
   * FN #                *   Process when sub Menu Index Greater than Zero
   *                     *
   ***********************
***************************************************************************/
    
    // Mark: User hasa hit * button now display the correct function sub menu
    func processSubMenu(){
        
        if (subMenuIndex != 12) { // Reset UV3 line one is different
            
            // Display the menu title from the table on first line
            self.lineZeroImageView.text = functionMenus[subMenuIndex - 1]
            
            // Blank the last line
            lineThreeImageView.text = self.txtSpaceOne
        }
        
        switch subMenuIndex {
            
        case 1:    // set receive frequency
            
            // Disable A B C & D keys Only allow numberics, asterics and hashtag
            disableAkey = true
            disableBkey = true
            disableCkey = true
            disableDkey = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Process an input key
            processInputChar()
            
            // Blank Line four
            self.lineThreeImageView.text = ""
            
            // Done
            break
            
        case 2:     // set the transmit frequency
            
            // Disable A B C & D keys Only allow numberics, asterics and hashtag
            disableAkey = true
            disableBkey = true
            disableCkey = true
            disableDkey = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Process an input key
            processInputChar()
            
            // Blank line four
            self.lineThreeImageView.text = ""
            
            // Done
            break
            
        case 3:      // Set Squelch level
            
            // disable C and D keys
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know it should save any data entered
            saveData = true
            
            // Blank line teo
            self.lineOneImageView.text = ""
            
            // dislay Squelch = and it's value
            self.lineTwoImageView.text = menuLineTwoSquelchTxt + String(squelchValue)
            
            // Display prompt for press A or B
            self.lineThreeImageView.text = menuLineThreeAorBtxt
            
            // Done
            break
            
        case 4:        // Set Tone Squlech Mode
            
            // Disable C and D keys
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Dislpay Mode = Value
            self.lineTwoImageView.text = txtToneSquelchMode + String(toneSquelchModeValue)
            
            // Display prompt for A or B
            self.lineThreeImageView.text = menuLineThreeAorBtxt
            break
            
        case 5:      // Set CTCSS value
            
            // Disable C & D keys
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Display CTCSS = value selected
            self.lineTwoImageView.text = txtCTCSS + ctcssValue
            
            // Set value for lookup
            ctcssIndex = 50
            
            // Display [prompt for A or B
            self.lineThreeImageView.text = menuLineThreeAorBtxt
            
            // Done
            break
            
        case 6:    // Turn Repeater On or Off
            
            // Disable B C and D keys
            disableBkey = true
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Display if repeater on or off
            if (repeaterSwitch == true) {
                self.lineTwoImageView.text = self.txtRepeaterSwitchEqual + self.txtOn
            } else {
                self.lineTwoImageView.text = self.txtRepeaterSwitchEqual + self.txtOff
            }
            
            // Display prompt to press A to toggle on or off
            self.lineThreeImageView.text = txtPressAtoToggle
            
            // Done
            break
            
        case 7:  // tuirn Beep on or off
            
            // Disable B C and D keys
            disableBkey = true
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Display if repeater on or off
            if (beepSwitch == true) {
                self.lineTwoImageView.text = self.txtBeepSwitchEqual + self.txtOn
            } else {
                self.lineTwoImageView.text = self.txtBeepSwitchEqual + self.txtOff
            }
            
            // Display prompt to press A to toggle on or off
            self.lineThreeImageView.text = txtPressAtoToggle
            
            // Done
            break
            
        case 8:    // Turn Fan On or Off
            
            // Disable B C and D keys
            disableBkey = true
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Display if fan on or off
            if (fanSwitch == true) {
                self.lineTwoImageView.text = self.txtFanSwitchEqual + self.txtOn
            } else {
                self.lineTwoImageView.text = self.txtFanSwitchEqual + self.txtOff
            }
            
            // Display prompt to press A to toggle on or off
            self.lineThreeImageView.text = txtPressAtoToggle
            
            // Done
            break
            
        case 9:
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Done
            break
            
            
        case 10:      // Set volume value
            
            // Disable C & D keys
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Display volume = value selected
            self.lineTwoImageView.text = txtVolume + volumeValue
            
            // Display prompt for A or B
            self.lineThreeImageView.text = menuLineThreeAorBtxt
            
            // Done
            break
        case 11:      // Display System Info
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Done
            break
            
        case 12:      // Display System Info
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Done
            break
            
        case 13: // Set callsign
            
            let workArray = self.dataArray[18].componentsSeparatedByString(" ")
            self.callsignTextField.text! =   workArray[1]

            // blank line two
            lineOneImageView.text = self.txtSpaceOne
            
            //blank line 3
            lineTwoImageView.text = self.txtSpaceOne
            
            // Popup the keyboard
            popKeyboard()
            
            // Done
            break
            
        case 14: // Xmit call sign
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // blank line three
            self.lineTwoImageView.text = txtPressStarReset
            
            // Done
            break
            
        case 15: // Set hang time
            
            // Disable C & D keys
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Display hang time equals
            if (hangTime == 0) {
                self.lineTwoImageView.text = "Hang time = 0000 Secs"
            } else {
                self.lineTwoImageView.text = "Hang time = " + String(hangTime) + " Secs"
            }
            
            // Display [prompt for A or B or C or D
            self.lineThreeImageView.text = menuLineThreeAorBtxt
            
        case 16: // Set id time
            
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Display hang time equals
            if (idTime == 0) {
                self.lineTwoImageView.text = "ID timer = 00 Secs"
            } else {
                self.lineTwoImageView.text = "ID Timer time = " + String(idTime) + " Secs"
            }
            
            // Display [prompt for A or B or C or D
            self.lineThreeImageView.text = menuLineThreeAorBorCorDtxt
            
        case 17: // Set time out timer
            
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            // Blank line two
            self.lineOneImageView.text = ""
            
            // Display time out timer equals
            if (timeOutTimer == 0) {
                self.lineTwoImageView.text = "TO timer = 00 Secs"
            } else {
                self.lineTwoImageView.text = "TO timer = " + String(timeOutTimer) + " Ms"
            }
            
            // Display [prompt for A or B or C or D
            self.lineThreeImageView.text = menuLineThreeAorBorCorDtxt
            
            // Done
            break
            
        case 18:      // Set Squelch level
            
            // disable C and D keys
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know it should save any data entered
            saveData = true
            
            // Blank line teo
            self.lineOneImageView.text = ""
            
            // dislay Squelch = and it's value
            self.lineTwoImageView.text = txtXmitterState + String(toggleValue)
            
            // Display prompt for press A or B
            self.lineThreeImageView.text = menuLineThreeAorBtxt
            
            // Done
            break
            
        case 19:      // Set Squelch level
            
            // disable B C and D keys
            disableBkey = true
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know it should save any data entered
            saveData = true
            
            // Blank line teo
            self.lineOneImageView.text = ""
            
            // dislay DTMF value
            if (DTMFstate == false) {
                lineTwoImageView.text = txtDTMFequal + txtOff
                } else {
                lineTwoImageView.text = txtDTMFequal + txtOn
            }
            
            // Display prompt for press A to toggle
            self.lineThreeImageView.text = txtPressAtoToggle
            
            // Done
            break

        case 20:
            
            // disable C and D keys
            disableCkey = true
            disableDkey = true
            
            // Let Asterics key know it should save any data entered
            saveData = true
            
            // Blank line teo
            self.lineOneImageView.text = ""
            
            // dislay Squelch = and it's value
            self.lineTwoImageView.text = txtCodeSpeed + String(codeSpeed)
            
            // Display prompt for press A or B
            self.lineThreeImageView.text = menuLineThreeAorBtxt
            
            // Done
            break
            
        default:
            break
        }
    }
   
    // Mark: The user has tapped the * button on a fn sub menu
    
    
/*************************************************************
       Proces input key for rx or tx frequency
*************************************************************/
    
    
    //   For submenus 1 or 2 prepare frequency buffer
    //   keep track of what position in the buffer the number goes  and append it to the buffer
    //   after the sixth digit send the buffer to the Arduino and then go back to menu zero
    
    func processInputChar() {
        
        // Display RX: or TX: based upon which sub menu index
        switch subMenuIndex {
            
        case 1:
            self.lineBuffer = "Rx: "
            break
            
        case 2:
            self.lineBuffer = "Tx: "
            break
            
        default :
            break

            
        }
        
        // Process on which digit is being inputted to buffer
        // Append to the buffer the next input key
        switch inputCharCtr {
            
        case 0:
            // Display RX or TX plus all dashes
            self.lineBuffer += "---.---"
            self.lineTwoImageView.text = lineBuffer
            break

        
        case 1:
            // Input buffer has one key in it
            // Display RX or TX + Input buffer + dashes
            self.lineBuffer += inputBuffer + "--.---"
            self.lineTwoImageView.text = lineBuffer
            break
            
        case 2:
            // Input buffer has two keys in it
            // Display RX or TX + Input buffer + dashes
            self.lineBuffer +=  inputBuffer + "-.---"
            self.lineTwoImageView.text = lineBuffer
            break
            
        case 3:
            // Input buffer has three keys in it
            // Display RX or TX + Input buffer + dashes
            self.lineBuffer += inputBuffer + ".---"
            self.lineTwoImageView.text = lineBuffer
            inputBuffer += "."
            break
            
        case 4:
            // Input buffer has four keys in it
            // Display RX or TX + Input buffer + dashes
            self.lineBuffer += inputBuffer + "--"
            self.lineTwoImageView.text = lineBuffer
            break
            
        case 5:
            // Input buffer has five keys in it
            // Display RX or TX + Input buffer + dashes
            self.lineBuffer += inputBuffer + "-"
            self.lineTwoImageView.text = lineBuffer
            break
            
        case 6:
            
            // Edit the value of the string to band limits
            let myDouble:Double = (inputBuffer as NSString).doubleValue
            var freqGood:Bool = false
   
            if (myDouble > 146 && myDouble < 148) {
                freqGood = true
                } else if (myDouble > 220 && myDouble < 225) {
                           freqGood = true
                } else if (myDouble > 420 && myDouble < 450) {
                           freqGood = true
                } else {
                       freqGood = false
                    }
 
            if (freqGood == false) {
                // display the inputted frequency
                self.lineBuffer += inputBuffer
                self.lineTwoImageView.text = lineBuffer

                // display bad freq message
                self.lineThreeImageView.text = self.txtFreqBad
                delay(3) {
                         self.displayMenuZero()
                         }
                
                // Done
                break
                 }
            
            // Freuncy is good display the inoutted frequency
            self.lineBuffer += inputBuffer
            self.lineTwoImageView.text = lineBuffer

            // send the frequency command to the Arduino
            self.sendChars(lineBuffer)
            
            // Update the RX or TX line for main menu with the newq frequency
            if (menuIndex == 1) {
                self.rxTextField = lineBuffer
            } else if (menuIndex == 2) {
                self.txTextField = lineBuffer
            }
            
            // Disable A B C & D keys
            self.disableAkey = false
            self.disableBkey = false
            self.disableCkey = false
            self.disableDkey = false
            
            // Reset the menu indexes
            menuIndex = 0
            subMenuIndex = 0
            
            // Send the update sent to UV3 message
            
            // Dispatch Main Menu in 33 seconds
            self.lineThreeImageView.text = self.dataUpdateMsg
            delay(3) {
                     self.displayMenuZero()
            }
            
            // Done
            break
            
            
        default:
            break
        }
    }
    
/*********************************************************************************
                     Processing for each key follow
*********************************************************************************/

    // Mark:  * has been selected - bump the menuIndex and then display the correct function menu
    //              or the data for a function is ready to be sent to the Arduino
    @IBAction func buttonAstericsTapped(sender: UIButton) {
    
        // record last key
        lastKeyPressed = "*"
        
        // Process the * key based upon menuIndex
        switch menuIndex {
            
            
            // if menu index equal zero increment menu index & process menu index
        case 0:
            // Increment the menu index
            menuIndex = menuIndex + 1
            
            // set input buffer to null and key counter to zero
            self.inputCharCtr = 0
            self.inputBuffer = ""
            
            // process the menu index
            processMenuIndex()
            
            // Done
            break
            
        case 1:                   // set rx frequency

            // set subMenuIndex = to the menuIndex, the input buffer to null and the inpput key counter to zero
            subMenuIndex = menuIndex
            self.inputCharCtr = 0
            self.inputBuffer = ""
            self.lineBuffer = ""
            
            // process subMenuIndex
            processSubMenu()
            
            // Done
            break
            
        case 2:                 // set TX frfequency
            
            // set subMenuIndex = to the menuIndex, the input buffer to null and the inpput key counter to zero
            subMenuIndex = menuIndex
            self.inputCharCtr = 0
            self.inputBuffer = ""
            self.lineBuffer = ""

            // process subMenuIndex
            processSubMenu()
            
            // Done
            break
            
        case 3:                   // Set Squelch value

            // test if * means save the value
            if (saveData == true) {

                // turn off the save switch
                saveData = false
                
                // Build the command to be sent to the UV3
                let tempSqString:String = self.squelchCmd + String(squelchValue)
                
                // Send the command to the UV3
                sendChars(tempSqString)
                
                // Reset the menuIndex and the subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main screen in 3 secnds
                self.lineThreeImageView.text = self.dataUpdateMsg
                delay(3){
                        self.displayMenuZero()
                        }
                
                // Done
                break
                }

            // set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex

            // process subMenuIndex
            processSubMenu()
            break
            
        case 4:        // Set tone squelch mode
            
            // Test if * key means save the data
            if (saveData == true) {
                
                // Rest the switch
                saveData = false
                
                // Build the coammand to besent to theUV3
                let tempTmString:String = self.toneSquelchModeCmd + String(toneSquelchModeValue)
                
                // send the comand to theUV3
                sendChars(tempTmString)
                
                // Reset menuIndex and SsubMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
                
                // Display main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }

                // Done
                break
            }
            
            // set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process subMenuIndex
            processSubMenu()

            // Done
            break
            
        case 5:        // Set CTCSS
            // Test if * key means save the data
            if (saveData == true) {
                
                // Rest the switch
                saveData = false

            
                // Set a temporary float with the tanle entry
                var tempCTCSSF:Float = CTCSStableF[ctcssIndex]
            
                // Multiply the value by 100
                tempCTCSSF = tempCTCSSF * 100
            
                // Turn the number into an integer
                let tempCTSSI:Int = Int(tempCTCSSF)
            
                // format the command to be sent to the UV3 - FNnnnnnn
                var tempCTCSS:String = String(format: "TF%2i", tempCTSSI) 
            
                // Send the command to the UV3
                sendChars(tempCTCSS)
            
                // reset menuIndex and ssubMenuIndex
                menuIndex = 0
                subMenuIndex = 0
            
                // Display the sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
 
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                    }
                
                // Done
                break
            }
            
            // set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process subMenuIndex
            processSubMenu()
            

            // Done
            break

            case 6:         // Set repeater ON or Off

                // Test if * key means save the data
                if (saveData == true) {
                    
                    // Rest the switch
                    saveData = false
                    // Test if repeater is on or off and build the correct command
                    if (repeaterSwitch == true) {
                        let tempCmd:String = self.repeaterCmd + txtOn
                        sendChars(tempCmd)
                    } else {
                        let tempCmd:String = self.repeaterCmd + txtOff
                        sendChars(tempCmd)
                    }
            
                    // Reset the menuIndex and subMenuIndex
                    menuIndex = 0
                    subMenuIndex = 0
            
                    // Display the Sent to UV3 message
                    self.lineThreeImageView.text = self.dataUpdateMsg

                    // Display the main menu in 3 seconds
                    delay(3){
                        self.displayMenuZero()
                        }
                   
                    // Done
                    break
                
                }
                // set subMenuIndex equal to menuIndex
                subMenuIndex = menuIndex
                
                // process subMenuIndex
                processSubMenu()
                

            // Done
            break
          
        case 7:         // Set beep ON or Off
            
            // Test if * key means save the data
            if (saveData == true) {
                
                // Rest the switch
                saveData = false
                // Test if buzzer is on or off and build the correct command
                if (beepSwitch == true) {
                    var tempCmd:String = self.beepCmd + txtOn
                    sendChars(tempCmd)
                } else {
                    var tempCmd:String = self.beepCmd + txtOff
                    sendChars(tempCmd)
                }
                
                // Reset the menuIndex and subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
                
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
                
            }
            // set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process subMenuIndex
            processSubMenu()
            
            
            // Done
            break
            
        case 8:         // Set fan ON or Off
            // Test if * key means save the data
            if (saveData == true) {
                
                // Rest the switch
                saveData = false

                // Test if repeater is on or off and build the correct command
                if (fanSwitch == true) {
                    let tempCmd:String = self.fanCmd + txtOn
                    sendChars(tempCmd)
                } else {
                    let tempCmd:String = self.fanCmd + txtOff
                    sendChars(tempCmd)
                }
            
                // Reset the menuIndex and subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
            
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
            
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                    }
                
                // Done
                break
            }
            // set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process subMenuIndex
            processSubMenu()
            

            // Done
            break
            
            
        case 9: // Set the clock
            
            if (saveData == true) {
                saveData = false
                
                // send the time to the Arduino
                let offSet:Int  = ltzOffset()/3600
                var tempString:String = timeCmd + arduinoTime + arduinoDate + String(offSet)
                sendChars(tempString)
  
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
                
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
            }
            
            subMenuIndex = menuIndex
            saveData = true
            displayClockMenu()
            // Done
            break
            
            
        case 10: // Set the volume
            
            if (saveData == true) {
                saveData = false
                
                // Build command for Arduino
                let tempVolume:Int = Int(self.volumeValue)!
                var tempString:String = ""
                
                if (tempVolume < 10) {
                    tempString = self.volumeCmd + "0" + self.volumeValue
                } else {
                    tempString = self.volumeCmd + self.volumeValue
                }
                // Send the command to the UV3
                self.sendChars(tempString)
                
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg

                // Reset the menuIndex and subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
                
            }
            subMenuIndex = menuIndex
            saveData = true
            processSubMenu()
            
            // done
            break
            
        case 11: // Display system Info
            
            if (saveData == true) {
                saveData = false
                
                // Change the status
                self.imgBluetoothStatus.image = UIImage(named: "receiving")
                
                // Send the command to the UV3
                self.sendChars("HelloUV3")   // send good morning message to Arduino
                
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
                
                // Reset the menuIndex and subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
                
            }
            subMenuIndex = menuIndex
            saveData = true
            processSubMenu()
            
            // done
            break
            
        case 12: // Reset UV3
            
            if (saveData == true) {
                saveData = false
                
                // Send the command to the UV3
                self.sendChars("AD1")   // send good morning message to Arduino
                
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
                
                // Reset the menuIndex and subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
                
            }
            subMenuIndex = menuIndex
            saveData = true
            processSubMenu()
            
            // done
            break
            
        case 13: // Set Call Sign
            
            // Set the index
            subMenuIndex = menuIndex
            
            // go do it
            processSubMenu()
            
            // done
            break
            
        case 14: // Xmit call sign
            
            if (saveData == true) {
                saveData = false
                
                // Send the command to the UV3
                self.sendChars("CT")   // send good morning message to Arduino
                
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
                
                // Reset the menuIndex and subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
                
            }
            // Set the index
            subMenuIndex = menuIndex
            
            // go do it
            processSubMenu()
            
            // done
            break
        
        case 15: // Set hang timer
            
            if (saveData == true) {
                saveData = false
            
                var hangTimeCmd:String = "HT "
                    
                if (self.hangTime == 0 ) {
                    hangTimeCmd += "0000"
                }   else {
                    hangTimeCmd += String(self.hangTime)
                }
                
                // Set data array
                self.dataArray[32] = hangTimeCmd

                // Reload the tableview
                self.tableView.reloadData()
            
                // Send the command to the UV3
                self.sendChars(hangTimeCmd)   // send hang time
                
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
                
                // Reset the menuIndex and subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
                
            }
            // Set the index
            subMenuIndex = menuIndex
            
            // go do it
            processSubMenu()
            
            // done
            break
            
        case 16: // Set ID timer
            
            if (saveData == true) {
                saveData = false
                
                if (self.idTime > 99){
                    idTimeCmd = txtITcmd + String(self.idTime)
                    } else if (self.idTime > 9) {
                               idTimeCmd = txtITcmd + "0" + String(self.idTime)
                                    } else {
                                        idTimeCmd = txtITcmd + "00" + String(self.idTime)
                                        }
                
                // Set data array
                self.dataArray[27] = idTimeCmd
                
                // Reload the tableview
                self.tableView.reloadData()
                
                // Send the command to the UV3
                self.sendChars(idTimeCmd)   // send hang time
                
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
                
                // Reset the menuIndex and subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
                
            }
            // Set the index
            subMenuIndex = menuIndex
            
            // go do it
            processSubMenu()
            
            // done
            break
            
        case 17: // Set time out timer
            
            if (saveData == true) {
                saveData = false
                
                if (self.timeOutTimer > 99){
                    timeOutTimerCmd = "TO " + String(self.timeOutTimer)
                } else if (self.timeOutTimer > 9) {
                    timeOutTimerCmd = "TO " + "0" + String(self.timeOutTimer)
                } else {
                    timeOutTimerCmd = "TO " + "00" + String(self.timeOutTimer)
                }
                
                // Set data array
                self.dataArray[33] = timeOutTimerCmd
                
                // Reload the tableview
                self.tableView.reloadData()
                
                // Send the command to the UV3
                self.sendChars(timeOutTimerCmd)   // send hang time
                
                // Display the Sent to UV3 message
                self.lineThreeImageView.text = self.dataUpdateMsg
                
                // Reset the menuIndex and subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main menu in 3 seconds
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
                
            }
            // Set the index
            subMenuIndex = menuIndex
            
            // go do it
            processSubMenu()
            
            // done
            break
        case 18:                   // Toggle Transmitter
            
            // test if * means save the value
            if (saveData == true) {
                
                // turn off the save switch
                saveData = false
                
                // Build the command to be sent to the UV3
                let tempToggleString:String = "TX " + String(toggleValue)
                
                // Send the command to the UV3
                sendChars(tempToggleString)
                
                // Reset the menuIndex and the subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main screen in 3 secnds
                self.lineThreeImageView.text = self.dataUpdateMsg
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
            }
            
            // set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process subMenuIndex
            processSubMenu()
            break
        case 19:      // Toggle DTMF
            
            // test if * means save the value
            if (saveData == true) {
                
                // turn off the save switch
                saveData = false
                
                // Build the command to be sent to the UV3
                var tempToggleString:String = ""

                if (DTMFstate == true) {
                    tempToggleString = "DR 1"
                    self.dataArray[22] = "DR: ON"
                }  else {
                    tempToggleString = "DR 0"
                    self.dataArray[22] = "DR: OFF"
                }
                
                
                // Send the command to the UV3
                sendChars(tempToggleString)
                
                // Reset the menuIndex and the subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main screen in 3 secnds
                self.lineThreeImageView.text = self.dataUpdateMsg
                delay(3){
                    self.displayMenuZero()
                }
                
                // Done
                break
            }
            
            // set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process subMenuIndex
            processSubMenu()
            break
            
        case 20:           //  set code speed
            
            // test if * means save the value
            if (saveData == true) {
                
                // turn off the save switch
                saveData = false
                
                // Build the command to be sent to the UV3
                var tempCodeSpeedString:String = ""
                
                if (codeSpeed < 10) {
                    tempCodeSpeedString = "CS0" + String(codeSpeed)
                } else {
                    tempCodeSpeedString = "CS" + String(codeSpeed)
                }
                
                // Send the command to the UV3
                sendChars(tempCodeSpeedString)
                
                // Reset the menuIndex and the subMenuIndex
                menuIndex = 0
                subMenuIndex = 0
                
                // Display the main screen in 3 secnds
                self.lineThreeImageView.text = self.dataUpdateMsg
                delay(3){
                    self.displayMenuZero()
                }
            
                // Done
                break
            }
            
            // set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process subMenuIndex
            processSubMenu()
            break
           
        default:
            break
            
        }  // end of switch


    }
    
    // Mark: - A has been tapped
    @IBAction func buttonATapped(sender: UIButton) {

        // make sure key can be processed
        if (disableAkey == true) {
         return
        }
        
        // check for paging menus
        if((lastKeyPressed == "A" && subMenuIndex == 0) || (lastKeyPressed == "B" && subMenuIndex == 0) || (lastKeyPressed == "C" && subMenuIndex == 0) || (lastKeyPressed == "D" && subMenuIndex == 0) || (lastKeyPressed == "*" && subMenuIndex == 0)) {
           
            // Increment the menu index
            menuIndex = menuIndex + 1
            
            // if greater than max reset menuIndex
            if (menuIndex > menuMax) {
                menuIndex = menuMin
            }
            
            // temporarily set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process the menuIndex
            processMenuIndex()
            
            // reset the subMenuIndex
            subMenuIndex = 0
                return
            
        }

        // record last key
        lastKeyPressed = "A"

        switch menuIndex {
        
        case 0: // If menuIndex is at zero switch unit value
            // Set the switch for unitA
            unitSwitch = true
            
            // clear the last key pressed
            lastKeyPressed = ""
            
            // send the command to the Arduino
            sendChars(self.unitAcmd)
            
            menuIndex = 0
            subMenuIndex = 0
            // Display the Main Menu
            displayMenuZero()
            break

        case 3:  // Increment the squelch value
            
            // Set the save data for * key
            saveData = true
            
            if (subMenuIndex == menuIndex) {
            // Increment the squelch value
            self.squelchValue = self.squelchValue + 1
            
            // test if max value reached
            if (self.squelchValue > 9) {
                self.squelchValue = 0
                }
            
            // Dislay the new value of line 3
            self.lineTwoImageView.text = menuLineTwoSquelchTxt + String(squelchValue)
            }
        
            // Done
            break

        case 4: // Increment the tone squelch value
            
            // set the save data for * key
            saveData = true
            if (subMenuIndex == menuIndex) {
            // Increment the tone squelch mode
            self.toneSquelchModeValue = self.toneSquelchModeValue + 1
            
            // test if mode is max
            if (self.toneSquelchModeValue > 2) {
                self.toneSquelchModeValue = 0
            }
            
            // display line 3 with new value
            self.lineTwoImageView.text = txtToneSquelchMode + String(toneSquelchModeValue)
            }
            // Done
            break
            
        case 5:   // Increment the index into the CTCSS table
            
            // Set the save data for * key
            saveData = true
            if (subMenuIndex == menuIndex) {
            // Increment the table index for CTCSS
            self.ctcssIndex = self.ctcssIndex + 1
            
            // test index for max
            if (self.ctcssIndex > 50) {
                self.ctcssIndex = 0
            }
            
            // Display line 3 with the new value
            self.lineTwoImageView.text = txtCTCSS + String(self.CTCSStableF[ctcssIndex])
            }
            // Done
            break
            
        case 6:     // Toggle the valuue of the repeater On or Off
            
            // Flop the value of the switch and diplay the line
            if (repeaterSwitch == true) {
                repeaterSwitch = false
                self.lineTwoImageView.text = txtRepeaterSwitchEqual + txtOff
                } else {
                repeaterSwitch = true
                self.lineTwoImageView.text = txtRepeaterSwitchEqual + txtOn
                }
            
            // Done
            break
            
        case 7:     // Toggle the value of the buzzer On or Off
            if (subMenuIndex == menuIndex) {
            // Flop the value of the switch and diplay the line
            if (beepSwitch == true) {
                beepSwitch = false
                self.lineTwoImageView.text = txtBeepSwitchEqual + txtOff
            } else {
                beepSwitch = true
                self.lineTwoImageView.text = txtBeepSwitchEqual + txtOn
            }
            }
            // Done
            break
            
        case 8:     // Toggle the valuue of the fan On or Off
            if (subMenuIndex == menuIndex) {
            // Flop the value of the switch and diplay the line
            if (fanSwitch == true) {
                fanSwitch = false
                self.lineTwoImageView.text = txtFanSwitchEqual + txtOff
            } else {
                fanSwitch = true
                self.lineTwoImageView.text = txtFanSwitchEqual + txtOn
            }
            }
            // Done
            break
            
        case 10:   // Increment the volumeValue
            
            // Set the save data for * key
            saveData = true
            if (subMenuIndex == menuIndex) {
                // Increment the volumeValue
                var tempVolume:Int
                tempVolume = Int(self.volumeValue)!
                tempVolume = tempVolume + 1
                
                // test index for max
                if (tempVolume > 39) {
                    tempVolume = 1
                }
                self.volumeValue = String(tempVolume)
                // Display line 3 with the new value
                if (tempVolume < 10) {
                    self.lineTwoImageView.text = txtVolume + "0" + self.volumeValue
                } else {
                    self.lineTwoImageView.text = txtVolume + self.volumeValue
                }
            }
            // Done
            break
            
        case 15:   // Increment hang time
            
            // Let Asterics key know if should save any data processed
            saveData = true

            if (subMenuIndex == menuIndex) {
                hangTime = hangTime + 1000
                
                // test index for max
                if (hangTime > 5000) {
                    hangTime = 0
                }
                
                // Display hang time equals
                if (hangTime == 0) {
                    self.lineTwoImageView.text = "Hang time = 0000 Ms"
                } else {
                    self.lineTwoImageView.text = "Hang time = " + String(hangTime) + " Ms"
                }
            }
            // Done
            break
        
        case 16:   // Increment ID timer
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                idTime = idTime + 1
                
                // test index for max
                if (idTime > 500) {
                    idTime = 0
                }
                
                // Display ID timer equals
                if (idTime == 0) {
                    self.lineTwoImageView.text = "ID Timer = 00 Secs"
                } else {
                    self.lineTwoImageView.text = "ID Timer = " + String(idTime) + " Ms"
                }
            }
            // Done
            break

        case 17:   // Increment time out timer
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                timeOutTimer = timeOutTimer + 1
                
                // test index for max
                if (timeOutTimer > 600) {
                    timeOutTimer = 0
                }
                
                // Display time out timer equals
                if (timeOutTimer == 0) {
                    self.lineTwoImageView.text = "TO Timer = 00 Secs"
                } else {
                    self.lineTwoImageView.text = "TO Timer = " + String(timeOutTimer) + " Secs"
                }
            }
            // Done
            break
            
        case 18:  // Increment the xmitterState

            // Set the save data for * key
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                
                // Increment the xmitterState
                self.toggleValue = self.toggleValue + 1
                
                // test if max value reached
                if (self.toggleValue > 5) {
                    self.toggleValue = 0
                }
                
                // Dislay the new value of line 3
                self.lineTwoImageView.text = txtXmitterState + String(toggleValue)
            }
            
            // Done
            break
           
        case 19:  // Toggle DTMF state
            
            // Set the save data for * key
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                
                // test state
                if (DTMFstate == false) {
                    DTMFstate = true
                    lineTwoImageView.text = txtDTMFequal + txtOn
                } else {
                    lineTwoImageView.text = txtDTMFequal + txtOff
                    DTMFstate = false
                }
                
            }
            
            // Done
            break
            
        case 20:      // Increment codeSpeed
            
            // Set the save data for data received
            saveData = true
            if (subMenuIndex == menuIndex) {
                
                // Increment codeSpeed
                self.codeSpeed = self.codeSpeed  + 1
                
                if (self.codeSpeed > 25) {
                    self.codeSpeed = 5
                }
                
                // Display the new value of line3
                self.lineTwoImageView.text = txtCodeSpeed + String(codeSpeed)
            }
            
            // Done
            break
            
     default:  // if submenu index eqaual zero then process as a menu bump otherwise it is an escape
            
            // bump menu index by one
            menuIndex = menuIndex + 1
            
            // if menu index equal greater than max set to one
            if (menuIndex > menuMax) {
                menuIndex = menuMin
            }
            
            // call process menu index
            processMenuIndex()
        }  // end of switch
    }
    
    // Mark: B has been tapped
    @IBAction func buttonBTapped(sender: UIButton) {
        
        // check for paging menus
        if((lastKeyPressed == "A" && subMenuIndex == 0) || (lastKeyPressed == "B" && subMenuIndex == 0) || (lastKeyPressed == "C" && subMenuIndex == 0) || (lastKeyPressed == "D" && subMenuIndex == 0) || (lastKeyPressed == "*" && subMenuIndex == 0)) {
    
            // Increment the menu index
            menuIndex = menuIndex  - 1
            
            // if greater than max reset menuIndex
            if (menuIndex < menuMin) {
                menuIndex = menuMax
            }
            
            // temporarily set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process the menuIndex
            processMenuIndex()
            
            // reset the subMenuIndex
            subMenuIndex = 0
            return
            
        }
     
        // record last key
        lastKeyPressed = "B"

        
        switch menuIndex {
        
        case 0: // If menuIndex is at zero switch unit value
            
            // clear the last key pressed
            lastKeyPressed = ""
 
            // Set for unit B
            unitSwitch = false

            // Send the command to the Arduino
            sendChars(self.unitBcmd)
            
            
            menuIndex = 0
            subMenuIndex = 0
            // Display the Main Menu
            displayMenuZero()
            
            
            // Done
            break
            
        case 3: // Decrement the squelch value
            
            // Set the save data switch for the * key
            saveData = true
            
            // Decrement the squelch value
            self.squelchValue = self.squelchValue - 1
            
            // Test if below minimum
            if (self.squelchValue < 0) {
                    self.squelchValue = 9
                    }
            
            // Display the new value
            self.lineTwoImageView.text = menuLineTwoSquelchTxt + String(squelchValue)
            
            // Done
            break
        
        case 4: // Decrement the tone squelch mode
            
            // Set the save data switch for the * key
            saveData = true
            
            // Decrement the Mode value
            self.toneSquelchModeValue = self.toneSquelchModeValue - 1
            
            // Test for min value
            if (self.toneSquelchModeValue < 0) {
                    self.toneSquelchModeValue = 2
                    }
            
            // Display the new value
            self.lineTwoImageView.text = txtToneSquelchMode + String(toneSquelchModeValue)
            
            // Done
            break
                
        case 5: // Decrement the index to the CTCSS table
            
            // Set the save data switch for the * key
            saveData = true
            
            // Decrement the ctcssIndex
            self.ctcssIndex = self.ctcssIndex - 1
            
            // Test for min value
            if (self.ctcssIndex < 0) {
                self.ctcssIndex = 50
            }
            
            // Display the new value
            self.lineTwoImageView.text = txtCTCSS + String(self.CTCSStableF[ctcssIndex])
            
            
            // Done
            break
            
        case 10:   // Decrement the volumeValue
            
            // Set the save data for * key
            saveData = true
            if (subMenuIndex == menuIndex) {
                // Decrement the volumeValue
                var tempVolume:Int
                tempVolume = Int(self.volumeValue)!
                tempVolume = tempVolume - 1
                
                // test index for max
                if (tempVolume < 1) {
                    tempVolume = 39
                }
                self.volumeValue = String(tempVolume)
                // Display line 3 with the new value
                if (tempVolume < 10) {
                    self.lineTwoImageView.text = txtVolume + "0" + self.volumeValue
                } else {
                    self.lineTwoImageView.text = txtVolume + self.volumeValue
                }
            }
            // Done
            break
        case 15:   // Decrement hang time
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                hangTime = hangTime - 1000
                
                // test index for max
                if (hangTime < 0) {
                    hangTime = 5000
                }
                
                // Display hang time equals
                if (hangTime == 0) {
                    self.lineTwoImageView.text = "Hang time = 0000 Ms"
                } else {
                        self.lineTwoImageView.text = "Hang time = " + String(hangTime) + " Ms"
                        }
            }
            // Done
            break
        case 16:   // Increment ID timer
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                idTime = idTime - 1
                
                // test index for max
                if (idTime < 0) {
                    idTime = 500
                }
                
                // Display ID timer equals
                if (idTime == 0) {
                    self.lineTwoImageView.text = "ID Timer = 00 Secs"
                } else {
                    self.lineTwoImageView.text = "ID Timer = " + String(idTime) + " Secs"
                }
            }
            // Done
            break
            
        case 17:   // Deccrement time out timer
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                timeOutTimer = timeOutTimer - 1
                
                // test index for max
                if (timeOutTimer < 0) {
                    timeOutTimer = 600
                }
                
                // Display time out timer equals
                if (timeOutTimer == 0) {
                    self.lineTwoImageView.text = "TO Timer = 00 Secs"
                } else {
                    self.lineTwoImageView.text = "TO Timer = " + String(timeOutTimer) + " Ms"
                }
            }
            // Done
            break

        case 18:  // Decrement the xmitterState
            
            // Set the save data for * key
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                
                // Increment the xmitterState
                self.toggleValue = self.toggleValue - 1
                
                // test if max value reached
                if (self.toggleValue < 0) {
                    self.toggleValue = 5
                }
                
                // Dislay the new value of line 3
                self.lineTwoImageView.text = txtXmitterState + String(toggleValue)
            }
            
            // Done
            break
            
        case 20:      // Decrement codeSpeed
            
            // Set the save data for data received
            saveData = true
            if (subMenuIndex == menuIndex) {
                
                // Increment codeSpeed
                self.codeSpeed = self.codeSpeed - 1
                
                if (self.codeSpeed < 5) {
                    self.codeSpeed = 25
                }
                
                // Display the new value of line3
                self.lineTwoImageView.text = txtCodeSpeed + String(codeSpeed)
            }
            
            // Done
            break


        default:        // if submenu index eqaual zero then process as a menu bump otherwise it is an escape
            
            // decrement menu index by one
            menuIndex = menuIndex - 1
            
            // if menu index equal greater than max set to one
            if (menuIndex < menuMin) {
                menuIndex = menuMax
                }
            
            // call process menu index
            processMenuIndex()
        }
    }
    
    // Mark: C has been tapped
    @IBAction func buttonCTapped(sender: UIButton) {
        
        // check for paging menus
        if ((lastKeyPressed == "A" && subMenuIndex == 0) || (lastKeyPressed == "B" && subMenuIndex == 0) || (lastKeyPressed == "C" && subMenuIndex == 0) || (lastKeyPressed == "D" && subMenuIndex == 0) || menuIndex == subMenuIndex || lastKeyPressed == "*") {
            
            // Increment the menu index
            menuIndex = menuIndex + 5
            
            // if greater than max reset menuIndex
            if (menuIndex > menuMax) {
                menuIndex = menuMin
            }
            
            // temporarily set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process the menuIndex
            processMenuIndex()
            
            // reset the subMenuIndex
            subMenuIndex = 0
            return
            
        }
        
        // record last key
        lastKeyPressed = "C"
        
     
        // test if menu zero
        if (menuIndex == 0) {
            return
        }

        switch menuIndex {
        
        case 16:   // Increment ID timer
        
        // Let Asterics key know if should save any data processed
        saveData = true
        
        if (subMenuIndex == menuIndex) {
            idTime = idTime + 50
            
            // test index for max
            if (idTime > 500) {
                idTime = 0
            }
            
            // Display ID timer equals
            if (idTime == 0) {
                self.lineTwoImageView.text = "ID Timer = 00 Secs"
            } else {
                self.lineTwoImageView.text = "ID Timer = " + String(idTime) + " Secs"
            }
        }
        // Done
        break
            
        case 19:   // Increment time out timer
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                timeOutTimer = timeOutTimer + 50
                
                // test index for max
                if (timeOutTimer > 600) {
                    timeOutTimer = 0
                }
                
                // Display time out timer equals
                if (timeOutTimer == 0) {
                    self.lineTwoImageView.text = "TO Timer = 00 Secs"
                } else {
                    self.lineTwoImageView.text = "TO Timer = " + String(timeOutTimer) + " Ms"
                }
            }
            // Done
            break
            
        default:        // if submenu index eqaual zero then process as a menu bump otherwise it is an escape
        
        // decrement menu index by one
        menuIndex = menuIndex - 1
        
        // if menu index equal greater than max set to one
        if (menuIndex < menuMin) {
            menuIndex = menuMax
        }
        
        // call process menu index
        processMenuIndex()
    }
    
    
    
    }

    // Mark: D has been tapped
    @IBAction func buttonDTapped(sender: UIButton) {
        
        
        // check for paging menus
        if((lastKeyPressed == "A" && subMenuIndex == 0) || (lastKeyPressed == "B" && subMenuIndex == 0) || (lastKeyPressed == "C" && subMenuIndex == 0) || (lastKeyPressed == "D" && subMenuIndex == 0) || menuIndex == subMenuIndex || lastKeyPressed == "*") {
            
            // Increment the menu index
            menuIndex = menuIndex - 5
            
            // if greater than max reset menuIndex
            if (menuIndex < menuMin) {
                menuIndex = menuMax
            }
            
            // temporarily set subMenuIndex equal to menuIndex
            subMenuIndex = menuIndex
            
            // process the menuIndex
            processMenuIndex()
            
            // reset the subMenuIndex
            subMenuIndex = 0
            return
            
        }

        
        // record last key
        lastKeyPressed = "D"

        
        // test if menu zero
        if (menuIndex == 0) {
            return
        }
        switch menuIndex {
            
        case 16:   // Increment ID timer
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                idTime = idTime - 50
                
                // test index for max
                if (idTime < 0) {
                    idTime = 500
                }
                
                // Display ID timer equals
                if (idTime == 0) {
                    self.lineTwoImageView.text = "ID Timer = 00 Secs"
                } else {
                    self.lineTwoImageView.text = "ID Timer = " + String(idTime) + " Secs"
                }
            }
            // Done
            break
            
        case 17:   // Decrement time out timer
            
            // Let Asterics key know if should save any data processed
            saveData = true
            
            if (subMenuIndex == menuIndex) {
                timeOutTimer = timeOutTimer - 50
                
                // test index for max
                if (timeOutTimer < 0) {
                    timeOutTimer = 600
                }
                
                // Display time out timer equals
                if (timeOutTimer == 0) {
                    self.lineTwoImageView.text = "TO Timer = 00 Secs"
                } else {
                    self.lineTwoImageView.text = "TO Timer = " + String(timeOutTimer) + " Ms"
                }
            }
            // Done
            break
            
        default:        // if submenu index eqaual zero then process as a menu bump otherwise it is an escape
            
            // decrement menu index by one
            menuIndex = menuIndex - 1
            
            // if menu index equal greater than max set to one
            if (menuIndex < menuMin) {
                menuIndex = menuMax
            }
            
            // call process menu index
            processMenuIndex()
        }
        
    }
    
    // Mark: # has been tapped - like cancel key
    @IBAction func buttonHastagTapped(sender: UIButton) {
        
        // record last key
        lastKeyPressed = "#"

        // check if keyboard popped
        if (subMenuIndex == 13) {
            dismissKeyboard()
        }
        
        // reset the menuIndex and process menu
        disableAkey = false
        disableBkey = false
        disableCkey = false
        disableDkey = false
        saveData = false
        menuIndex = 0
        subMenuIndex = 0
        subMenuIndexTwo = 0
 
        // Display the Main Menu
        displayMenuZero()
    }
    
    // Mark: 1 has been tapped
    @IBAction func buttonOneTapped(sender: UIButton) {

        // record last key
        lastKeyPressed = "1"

          if (menuIndex > 0 && subMenuIndex == 0) {
            menuIndex = 1
            processMenuIndex()
            return
        }
        
        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "1"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
    // Mark: 2 has been tapped
    @IBAction func buttonTwoTapped(sender: UIButton) {
        
        // record last key
        lastKeyPressed = "2"

        
        if (menuIndex > 0 && subMenuIndex == 0) {
            menuIndex = 2
            processMenuIndex()
            return
        }

        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "2"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
    // Mark: 3 has been tapped
    @IBAction func buttonThreeTapped(sender: UIButton) {
        // record last key
        lastKeyPressed = "3"

        
        if (menuIndex > 0 && subMenuIndex == 0) {
            menuIndex = 3
            processMenuIndex()
            return
        }
        
        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "3"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
    // Mark: 4 has been tapped
    @IBAction func buttonFourTapped(sender: UIButton) {
        // record last key
        lastKeyPressed = "4"

        if (menuIndex > 0 && subMenuIndex == 0) {
            menuIndex = 4
            processMenuIndex()
            return
        }
        
        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "4"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
    // Mark: 5 has been tapped
    @IBAction func buttonFiveTapped(sender: UIButton) {
        // record last key
        lastKeyPressed = "5"

        
        if (menuIndex > 0 && subMenuIndex == 0) {
            menuIndex = 5
            processMenuIndex()
            return
        }
        
        
        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "5"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
    // Mark: 6 has been tapped
    @IBAction func buttonSixTapped(sender: UIButton) {
        // record last key
        lastKeyPressed = "6"

        
        if (menuIndex > 0 && subMenuIndex == 0) {
            menuIndex = 6
            processMenuIndex()
            return
        }
        
        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "6"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
    // Mark: 7 has been tapped
    @IBAction func buttonSevenTapped(sender: UIButton) {
        // record last key
        lastKeyPressed = "7"

        if (menuIndex > 0 && subMenuIndex == 0) {
            menuIndex = 7
            processMenuIndex()
            return
        }
        
        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "7"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
    // Mark: 8 has been tapped
    @IBAction func buttonEightTapped(sender: UIButton) {
        // record last key
        lastKeyPressed = "8"

        
        if (menuIndex > 0 && subMenuIndex == 0) {
            menuIndex = 8
            processMenuIndex()
            return
        }
        
        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "8"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
    // Mark: 9 has been tapped
    @IBAction func buttonNineTapped(sender: UIButton) {
        // record last key
        lastKeyPressed = "9"

        
        if (menuIndex > 0 && subMenuIndex == 0) {
            menuIndex = 9
            processMenuIndex()
            return
        }
        
        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "9"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
    // Mark: 0 has been tapped
    @IBAction func buttonZeroTapped(sender: UIButton) {
        // record last key
        lastKeyPressed = "0"

        // Test for RX or TX
        if (subMenuIndex == 1 || subMenuIndex == 2) {
            inputBuffer += "0"
            inputCharCtr = inputCharCtr + 1
            processInputChar()
        }
    }
    
/***********************************************************************
               Bluetooth methods
***********************************************************************/
     
    // Mark: Bluetooth has notified connection status has changed
    func connectionChanged(notification: NSNotification) {
   
        // Connection status changed. Indicate on GUI.
        let userInfo = notification.userInfo as! [String: Bool]
        
        dispatch_async(dispatch_get_main_queue(), {
            // Set image based on connection status
            if let isConnected: Bool = userInfo["isConnected"] {
                if isConnected {
                    self.imgBluetoothStatus.image = UIImage(named: "receiving")
                    if (self.sendHello == true) {
                        self.sendHello = false
                        self.sendChars("HelloUV3")   // send good morning message to Arduino
                        } else {
                        self.sendChars("HelloUV3")   // send good morning message to Arduino
                        self.sendHello = true
                                }
                    } else {
                    self.imgBluetoothStatus.image = UIImage(named: "disconnected")
                }
            }
        });
    }

    // Mark: Bluetooth has notified data has been received
    func dataReceived(notification: NSNotification)
    {

        // Connection status changed. Indicate on GUI.
        let userInfo = notification.userInfo as! [String: NSData]
     
        // Convert NSData to NSString
        let receivedStr = NSString(data: userInfo["data"]!, encoding: NSUTF8StringEncoding)
        
        // Move MSString to global variable
        self.receivedDataString = receivedStr as! String
        
        // debug statements - select on or the other
        // NSLog("%@",receivedStr!)
        // print(receivedStr)
        
        // receivedStr has the data
        processReceivedData()
        
    }
    
    
 /****************************************************************
      Processing the data received
*****************************************************************/
    // Mark - Process received data
    func processReceivedData() {

        // Assign the string into arrays use space character to separate the first field
        // Data is either KEY space Daata or just one key
        let receivedDataArray = receivedDataString.componentsSeparatedByString(" ")
 
 //   print(receivedDataArray)
    
        // Create a temporary string to compare
        let dataKey:String = receivedDataArray[0]
        
        // Debug statement
 //       NSLog("@", receivedDataArray)
        

        // Test for "Done" and change status image
        if (dataKey == "Done") {
            dispatch_async(dispatch_get_main_queue(), {
            self.imgBluetoothStatus.image = UIImage(named: "connected")
                self.tableView.reloadData()
                          });
        }
        
        // Test for key for RX: set rxTextField
        else if (dataKey == "RX:") {
            
            // Put the receive frequency in an array and on the main display - done as an asyncronous process
            self.dataArray[0] = self.receivedDataString
  
            dispatch_async(dispatch_get_main_queue(), {
                
                    self.rxTextField = self.receivedDataString
                
                    // display the RX line
                    self.lineOneImageView.text = self.rxTextField + self.txtSpace16 + self.boardAtempText
                    });
     
        } // end of if RX:

        // Test for key for TX: set txTextField
        else if (dataKey == "TX:") {
            
            // Put the transmit frequency in an array and on the main display - done as an asyncronous process
            self.dataArray[1] = self.receivedDataString
            
            dispatch_async(dispatch_get_main_queue(), {
                self.txTextField = self.receivedDataString
                
                // Displat the TX line
                self.lineTwoImageView.text = self.txTextField
                    });
            
        } // end of if TX:
        
        // Test for key for unitA set the unit switch true
        else if (dataKey == "unitA") {
            
            // Put the data into the array then display the unit letter on line one
            self.dataArray[2] = self.receivedDataString
            self.unitSwitch = true
            dispatch_async(dispatch_get_main_queue(), {
                self.lineZeroImageView.text = self.menuZeroTextFieldUnitA
                });

        } // end of if unitA

        // Test for key for unitB set the unit switch false
        else if (dataKey == "unitB") {

            // Put the data into the array then display the unit letter on line one
            self.dataArray[2] = self.receivedDataString
            self.unitSwitch = false
            dispatch_async(dispatch_get_main_queue(), {
                self.lineZeroImageView.text = self.menuZeroTextFieldUnitB
                    });
            
        } // end of if unitB
        
        // Test for key for Squelch level
        else if (dataKey == "SQ:") {
            
            // Put the data into the array
            if (dataArray.count > 1) {
                self.dataArray[3] = self.receivedDataString
                let tempSquelch = receivedDataArray[1]
                   self.squelchValue = Int(tempSquelch)!
                
            }
        } // end of if SQ

        else if (dataKey == "TM:") {
            
            // Put the data into the array
            if (dataArray.count > 1) {
                self.dataArray[4] = self.receivedDataString
                var tempSquelchMode:String
                if (receivedDataArray[1]  != "") {
                    tempSquelchMode = receivedDataArray[1]
                    self.toneSquelchModeValue = Int(tempSquelchMode)!
                }
            }
            
        } // end of if TM
        
        // check for CTCss
        else if (dataKey == "TF:") {
            
            // Put the data into the array
            if (dataArray.count > 1) {
                self.dataArray[5] = self.receivedDataString
                let tempCTCCS:Float = Float(receivedDataArray[1])! / 100
                self.ctcssValue = String(tempCTCCS)
            }
        } // end of if TM
        
        // check for repeater on or off
        else if (dataKey == "Repeater:") {
            
            // Put the data into the array
            if (dataArray.count > 1) {
                self.dataArray[6] = self.receivedDataString
                if (receivedDataArray[1] == "true") {
                    self.repeaterSwitch = true
                    } else {
                            self.repeaterSwitch = false
                            }
            }
        } // end of if Repeater On OFF
        
        else if (dataKey == "Fan:") {
            
            // Put the data into the array
            if (dataArray.count > 1) {
                self.dataArray[7] = self.receivedDataString
                if (receivedDataArray[1] == "true") {
                    self.fanSwitch = true
                    } else {
                           self.fanSwitch = false
                    }
            }
        } // end of if FAN On OFF
        
        // Check for buzzer change
        else if (dataKey == "Beep:") {
            
            // Put the data into the array
            if (dataArray.count > 1) {
                self.dataArray[8] = self.receivedDataString
                if (receivedDataArray[1] == "true") {
                    self.beepSwitch = true
                    } else {
                            self.beepSwitch = false
                            }
            }
            
        } // end of if Buzzer On OFF
        
        //Check for board temp
        else if (dataKey == "Temp:") {
            
            if (menuIndex == 0 && subMenuIndex == 0) {
            
                // Put the data into the array
                if (dataArray.count > 1) {
                    self.dataArray[9] = self.receivedDataString
                    self.boardAtempText = receivedDataArray[1]
                    dispatch_async(dispatch_get_main_queue(), {
                    
                    // display the RX line
                    self.lineOneImageView.text = self.rxTextField + self.txtSpace16 + self.boardAtempText
                    });
                }
         }
            
        } // end of temp
        
            //Check for board temp
        else if (dataKey == "TP:") {
            
            // Put the data into the array
            if (dataArray.count > 2) {
                self.dataArray[9] = self.receivedDataString
                self.boardAtempText = receivedDataArray[3]
            }
        } // end of temp
            

            
        // Check for volume
        else if (dataKey == "VU:") {
            
            // Put the data into the array
            if (dataArray.count > 1) {
                self.dataArray[10] = self.receivedDataString
           
                if (receivedDataArray[1]   != "" ) {
                    self.volumeValue = receivedDataArray[1]
                    } else if (receivedDataArray[2] != "" ){
                               self.volumeValue = receivedDataArray[2]
                               }
                if (  self.volumeValue == "") {
                    self.volumeValue = "01"
                    }
            }
            
        } // end of if VU

        
        //Check for board AF
        else if (dataKey == "AF:") {
                
                // Put the data into the array
                self.dataArray[11] = self.receivedDataString
                
            } // end of AF
            
        //Check for board AI
        else if (dataKey == "AI:") {
                self.dataArray[11] = self.receivedDataString
                
                // Reload the tableview
                self.tableView.reloadData()
                
                // Done
                return
            } // end of AI
            
        //Check for board AO
        else if (dataKey == "AO:") {
                self.dataArray[12] = self.receivedDataString
                
            } // end of AO
            
        //Check for board B1
        else if (dataKey == "B1:") {
                
                // Put the data into the array
                self.dataArray[13] = self.receivedDataString
                
                // Reload the tableview
                self.tableView.reloadData()
                
                // done
                return
            } // end of B1
            
        //Check for board B2
        else if (dataKey == "B2:") {
                self.dataArray[14] = self.receivedDataString
                
            } // end of B2
            
        //Check for board BM
        else if (dataKey == "BM:") {
                
                // Put the data into the array
                self.dataArray[15] = self.receivedDataString
                
            } // end of BM
            
        //Check for board BT
        else if (dataKey == "BT:") {
                self.dataArray[16] = self.receivedDataString
                
            } // end of BT
            
        //Check for board CF
        else if (dataKey == "CF:") {
                
                // Put the data into the array
                self.dataArray[17] = self.receivedDataString
                
            } // end of CF
            
        //Check for board CL
        else if (dataKey == "CL:") {
                
                // Put the data into the array
                self.dataArray[18] = self.receivedDataString
                
            } // end of CL
            
        //Check for board CS
        else if (dataKey == "CS:") {
                
                // Put the data into the array
                self.dataArray[19] = self.receivedDataString
            
            if (dataArray.count > 2) {
                   self.codeSpeed = Int(receivedDataArray[3])!
                }
            } // end of CS
            
        //Check for board DD
        else if (dataKey == "DD:") {
                self.dataArray[20] = self.receivedDataString
                
            } // end of DD
            
        //Check for board DP
        else if (dataKey == "DP:") {
                
                // Put the data into the array
                self.dataArray[21] = self.receivedDataString
                
            } // end of DP
            
        //Check for board DR
        else if (dataKey == "DR:") {
                
                // Put the data into the array
                self.dataArray[22] = self.receivedDataString
            
            // Check the setting of DTMF
            if (dataArray.count > 1) {
                if (receivedDataArray[1] == "OFF") {
                    DTMFstate = false
                    } else if(receivedDataArray[1] == "ON") {
                DTMFstate = true
                }
            }
            } // end of DR
            
        //Check for board EX
        else if (dataKey == "EX:") {
                
                // Put the data into the array
                self.dataArray[23] = self.receivedDataString
                
            } // end of EX
            
        //Check for board FW
        else if (dataKey == "FW:") {
                
                // Put the data into the array
                self.dataArray[24] = self.receivedDataString
            } // end of FW
            
        //Check for board GM
        else if (dataKey == "GM:") {
                
                // Put the data into the array
                self.dataArray[25] = self.receivedDataString
                
            } // end of GM
            
        //Check for board GT
        else if (dataKey == "GT:") {
                self.dataArray[26] = self.receivedDataString
                
            } // end of GT
            
        //Check for board IT
        else if (dataKey == "IT") {
                
                // Put the data into the array
            if (dataArray.count > 1) {
                self.dataArray[27] = self.receivedDataString
                self.idTime = Int(receivedDataArray[1])!
                }
            } // end of IT
            
        //Check for board PD
        else if (dataKey == "PD:") {
                
                // Put the data into the array
                self.dataArray[28] = self.receivedDataString
                
            } // end of PD

        //Check for board SD
        else if (dataKey == "SD:") {
            
            // Put the data into the array
            self.dataArray[29] = self.receivedDataString
            
        } // end of SD
        
        //Check for board SO
        else if (dataKey == "SO:") {
            
            // Put the data into the array
            self.dataArray[30] = self.receivedDataString
            
        } // end of PD

        //Check for board TG
        else if (dataKey == "TG:") {

            // Put the data into the array
            self.dataArray[31] = self.receivedDataString
            
        } // end of TG

            //Check for hang time
        else if (dataKey == "HT:") {
            
                self.dataArray[32] = self.receivedDataString
            
        //    self.hangTime = Int(tempHangTime)!
            
        } // end of hang time
            
            //Check for timeout timer
        else if (dataKey == "TO:") {
            
            // Put the data into the array
            if (dataArray.count > 4) {
                self.dataArray[33] = self.receivedDataString
                let tempTimeOutTime = receivedDataArray[5]
                self.timeOutTimer = Int(tempTimeOutTime)!
            }
        } // end of hang time
            
            //Check for VOX Sensitivity
        else if (dataKey == "VL:") {
            
            // Put the data into the array
                self.dataArray[34] = self.receivedDataString

        } // end of VOX Sensitivity
        
            //Check for VOX State
        else if (dataKey == "VX:") {
            
            // Put the data into the array
                self.dataArray[35] = self.receivedDataString
      
        } // end of VOX Sensitivity
        
        // Reload the tableview
        self.tableView.reloadData()
    }
    
/******************************************************************************
     Send Characters
******************************************************************************/
    
    // Mark: - Sending of strings - called from anywhere I need to send a string
    // this method will call the method in BTService
    func sendChars(characters: String) {
        
        // Send string to BLE Shield (if service exists and is connected)
        if let bleService = btDiscoverySharedInstance.bleService {
            bleService.writeChars(characters)
        }
    }
    
/*****************************************************************************
   Delay
*****************************************************************************/
    
    // Mark: Delay function
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
/******************************************************************************
       Time Zone
******************************************************************************/
    // Mark: Getting time zone
    func ltzOffset() -> Int {
        return NSTimeZone.localTimeZone().secondsFromGMT
    }

/******************************************************************************
       Tableview methods
******************************************************************************/
    // Mark: tableview methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Try to get a cell to reuse
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Tablecell")!
        
        // Set the cell propertiwes
        cell.textLabel!.text = self.dataArray[indexPath.row]
        
        // Return the cell
        return cell
        
    }
 
   
    
    
}


