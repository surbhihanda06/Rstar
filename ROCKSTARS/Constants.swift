//
//  Constants.swift
//  TravellerApp
//
//  Created by Amritpal Singh on 05/10/16.
//  Copyright © 2016 Amritpal Singh. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import CoreData

public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

/*Declare Global Variable for AppDelegate*/
extension UIViewController {
    
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

/*Check Device Type*/
struct DeviceType {
    
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

enum UIUserInterfaceIdiom : Int {
    
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize {
    
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

let KappDelegate = UIApplication.shared.delegate as! AppDelegate
let defaults                                    = UserDefaults.standard
//let KGoogleKey = "AIzaSyAkB27vm8v1Oi-f7HXhudvyx-4CGxk9Az0"
let KGoogleKey = "AIzaSyAOlENNTvX2XBF_BMMngudph5n44xPLarE"

//MARK:- API NAME

let Kapi = "api"
let Kregister = "register"
let KREGISTER = "REGISTER"
let KjobPost = "jobPost"
let Kget_all_skills = "get_all_skills"
let Kfacebook_register = "facebook_register"
let Kcheck_email_exist = "check_email_exist"
let KgetJobSkills = "getJobSkills"
let KgetJobs = "getJobs"
let KactiveJobs = "activeJobs"
let KemployeeDashboard = "employeeDashboard"
let Klogout = "logout"
let KwithdrawJob = "withdrawJob"
let KdeleteJob = "deleteJob"
let KreadNotification = "readNotification"

let Krate = "rate"
let KTutorial = "Tutorial"
let KTutorialViewController = "TutorialViewController"
let Kjobid  = "job_id"
let KacceptRejectApplicant = "acceptRejectApplicant"
let Ksomethingwentwrong = "Something went wrong"
let Kiphone = "I"
let KTheemailmustbeavalidemailaddress = "The email must be a valid email address."
let Kdevice_type = "device_type"
let Kdevice_token = "device_token"
let KProfileUpdatedsuccessfully = "Profile Updated successfully"
let KJobAppliedSuccessfully = "Job Applied Successfully"
let KJobwithdrawSuccessfully = "Job withdraw Successfully"
let cCELL  = "CELL"
let Kcomplete = "complete"
let Kaps = "aps"
let KextraPayLoad = "extraPayLoad"
let Kalert = "alert"
let Kbody = "body"
let Kjob_date_time = "job_date_time"
let Ktitle = "title"
let Klabel = "label"
let Krating = "rating"
let Kshifts = "shifts"
let Kdata = "data"
let Kpicture = "picture"
let KRating_RegisterVC = "Rating_RegisterVC"
let KmainToUser_Register = "mainToUser_Register"
let Kdescription = "description"
let Kplace_id = "place_id"
let KIsFb_Login = "IsFb_Login"
let KDone = "Done"
let KABOUTME300charactersmax = "ABOUT ME (300 characters max.)"
let KDOBSTAR = "DOB *"
let KPleaseselectatleastoneskill = "Please select at least one skill."
let Kid = "id"
let KError = "Error"
let Kspirit_knowledge = "spirit_knowledge"
let Kcocktail_knowledge = "cocktail_knowledge"
let Kabout_me = "about_me"
let Kskill_name = "skill_name"
let Kselected = "selected"
let Kskills = "skills"
let KjobSkills = "jobSkills"
let KMainToUser_Skills = "MainToUser_Skills"
let Kjob_roles = "job_roles"
let Kpay = "pay"
let Kfinish_time = "finish_time"
let Kstart_time = "start_time"
let Kon_month = "on_month"
let Kon_date = "on_date"
let Kon_year = "on_year"



let KLogout = "Logout"
let KAreyousureyouwanttologout = "Are you sure you want to logout?"
let KLogSpcOut = "Logout"
let KSettings = "Password"
let KRateApp = "Rate App"
let KHelpSupport = "Help & Support"
let KNotification = "Notifications"
let KProfile = "Profile"
let Kcell = "cell"
let KSkills_RegisterVC = "Skills_RegisterVC"
let KIcanidentifyhowlongawhiskeywasfermentedbasedonthefartofsomeonewhodrankit = "I can identify how long a whiskey was fermented based on the fart of someone who drank it"
let KIcanrecommendspiritsknowthetopshelfwell = "I can recommend spirits, know the top shelf well"
let kGooglePlacesAPIKey = "AIzaSyBooXg1K1zk7uWBMd_S6PoRd16ZSYpTyb4"
let kGoogleStreetAPIKey = "AIzaSyBmvVttaIrgGHfkM9bN9yInsOKn5FYt4K0"


let KCandifferentiatefirstpoursfromtopshelf = "Can differentiate first pours from top shelf"
let KVodkaLimeSodaSlinger = "Vodka Lime Soda Slinger"
let KIllsticktobeerthanks = "I'll stick to beer thanks"
let KRating_Sellin = "Rating_Sellin"
let KRatingChange1 = "RatingChange1"
let Kforgot_password =  "forgot_password"
let KInvalidemailaddress = "Invalid email address"
let KPleasefillyouremailaddress = "Please fill your email address"
let KPleasefillyourvenue = "Please fill your venue"
let KPleasefillyourbuilding = "Please fill your building number"
let KPleasefillyourstreetaddress = "Please fill your street address"
let KPleasefillyourpostcode = "Please fill your postcode"
let KPleasefillyourmobilenumber = "Please fill your mobile number"
let KPleasefillyourname = "Please fill your name"
let KEmailhasbeensenttoyouremailIdPleasecheckandResetyourpassword = "A Verification link has been sent to your email address. Click it to reset your password."
let KVenuToUserDashboard = "VenuToUserDashboard"
let OK = "OK"
let KTheemailhasalreadybeentaken = "The email has already been taken."
let KShowPWD = "ShowPWD"
let KCancel = "Cancel"
let KPhotoLibrary = "Photo Library"
let KNocameraavailable = "No camera available"
let KChooseOption = "Choose Option"
let KCamera = "Camera"
let KStillinprogress = "Still in progress"
let Kpostcode = "postcode"
let Kvenue = "venue"
let KPostcode = "Invalid Postcode"
let KDelete = "Delete"
let Klatitude = "latitude"
let Klongitude = "longitude"
let Klocation = "location"
let KeditProfile = "editProfile"
let Kjob_status = "job_status"
let KApplied = "Applied"
let KSearchAcceptedVenueInfoVC = "SearchAcceptedVenueInfoVC"
let Kjob_data = "job_data"

let KMobilenumbershouldbebetween012digits = "Mobile number should be 10 digits."
let KPassworddoesntmatch = "Password doesn't match"
let KPasswordshouldbeatleast6characters  =  "Password should be at least 8 characters."
let KAllfieldsaremandatory = "All fields are mandatory"
let KHidePWD = "HidePWD"
let KMOBILENUMBERSTAR = "MOBILE NUMBER *"
let KNAMESTAR  = "NAME *"
let KEMAILSTAR = "EMAIL *"
let KPASSWORDSTAR = "PASSWORD *"
let KCONFIRMPASSWORDSTAR = "CONFIRM PASSWORD *"
let KVENUESTAR = "VENUE *"
let KOLDPASSWORD = "OLD PASSWORD *"
let KNEWPASSWORD = "NEW PASSWORD *"
let KCONFIRMPASSWORD = "CONFIRM PASSWORD *"
let KBUILIDING = "BUILIDING NUMBER *"
let KVENUEADDRESSSTAR = "VENUE ADDRESS *"
let KSTREETADDRESSSTAR = "STREET ADDRESS *"
let KPOSTCODESTAR = "POSTCODE / SUBURB *"
let KRegisteredSuccessfully = "Registered successfully"
let KmainToVenue_Login = "mainToVenue_Login"
let KmainToUser_Login = "mainToUser_Login"
let KuserID = "user_id"
let Krole_type = "role_type"
let KRefresh = "Refresh"
let Kapplicants = "applicants"
let KapplicantList = "applicantList"
let KApplicantCell = "ApplicantCell"
let KIsLogin = "IsLogin"
let KHistory = "History"
let Khistory = "history"
let KInvalidEmailOrPassword = "Invalid email or password"
let KForgotVC = "ForgotVC"
let KInternetConnectionLost = "Internet connection lost."
let KLogin = "login"
let KPassword = "password"
let KPleaseFillYourPassword = "Please fill your password"
let KInvalidEmailAddress = "Invalid email address"
let KPleaseFillYourEmailAddress = "Please fill your email address"
let KPleasefillyourconfirmpassword = "Please fill your confirm password"
let KPleasefilloldpassword = "Please fill old password"
let KPleasefillnewpassword =  "Please fill new password"
let KPleasefillValidlocation = "Please fill Valid location"
let KRegisterVenueVC = "RegisterVenueVC"
let KRegisterVC = "RegisterVC"
let KApplyJobVC = "ApplyJobVC"
let KApplicantListVC = "ApplicantListVC"
let KMain = "Main"
let KDashboardUser = "Dashboard_User"
let KDashboardVenue = "Dashboard_Venue"
let KPASSWORD = "PASSWORD"
let KEMAIL = "EMAIL"
let KRatingViewController = "RatingViewController"
let KRating_KeepSmil_RegisterVC = "Rating_KeepSmil_RegisterVC"
let KIfCockTailsWere = "If cocktails were magic spells I'm Harry f*ckin Potter"
let KEXPERT = "EXPERT"
let KIMACockTailBartender = "I'm a cocktail bartender, I go to bed dreaming of cock.....tails"
let KADVANCED = "ADVANCED"
let KGotAllTheBasicsDown = "Got all the basics down pat and can even whip up a few fancy ones!"
let KMEDIUM = "MEDIUM"
let KICanMakeTheVeryBasicsLongIslandIceTeasForDays = "I can make the very basics. Long island ice teas for days!"
let KBEGINNER = "BEGINNER"
let KWhatsAcocktail = "Whats a cocktail?"
let KNone = "NONE"
let KRating = "Rating"
let KCockTail_Edit = "CockTail_Edit"
let KSpirits_Edit = "Spirits_Edit"
let KIsTimeRating = "IsTime_Rating"
let KRatingChange = "RatingChange"
let KFailure = "Failure"
let KImage = "image"
let KDob = "dob"
let KMobile = "mobile"
let KEmail = "email"
let Kold = "old_password"
let Knew = "new_password"
let KName = "name"
let KUser = "user"
let Klogo = "logo"
let Kjob_date = "job_date"
let Kjob_time = "job_time"
let Konwards = ". onwards"
let KApplicantProfileVC = "ApplicantProfileVC"
let KRejectedSuccessfully = "Rejected Successfully"
let KRateSpace = "Rate "
let Ksperformance = "'s performance"
let Krstarhired = "rstar_hired"
let KMessage = "message"
let KStatus = "status"
let KSearchViewCell = "SearchViewCell"
let kSignUp  = "/api/v2/customers"
let kLogin   = "/api/v2/customers/login"
let kSendOtp = "/api/v2/customers/requestotp"
let kVerifyOtp = "/api/v2/customers/verifyotp"
let kFacebookLogin = "/api/v2/customers/facebook"
let kGetWeatherAPI = "/api/v2/weather"
let kGetSessionTokenAPI = "/api/v2/customers/get_session_token"
let kCustomersAPI = "/api/v2/customers"
let kFunnelValuesAPI = "/api/v2/paramater/mowz"
let kGetPlanAPI = "/api/v2/jobs/plan"
let kScheduleAPI = "/api/v2/jobs/schedule"
let kQuoteAPI = "/api/v2/jobs/quote"
let kSaveCardAPI = "/api/v2/cards"
let kCouponCodeAPI = "/api/v2/jobs/offers"
let kCreateJobAPI = "/api/v2/jobs"
let kUploadImageAPI = "/api/v2/upload_image"
let KEditProfileVenueVC = "EditProfileVenueVC"


let kBaseUrl = "http://softprodigyphp.in/Rstar/api/"
//let kBaseUrl = "http://52.65.99.35/Rstar/api/"
//let kBaseUrl = "http://192.168.0.93/Rstarm/api/"
let kProfileURL = "getProfile"
let kchangePassword = "changePassword"
let kAcceptedVenueURL = "venueActivity"
let kAcceptedEmpURL = "employeeActivity"
let kUpdateSettingURL = "updateSetting"
let KCheck = "Check"
let KAccepted = "Accepted"
let KSpeakerGray = "SpeakerGray"

let Kedit_profile = "edit_profile"
let Kaccepted_jobs = "accepted_jobs"
let Kjobs = "jobs"
let kEdit = "Edit"
let KEDITPROFILE = "EDIT PROFILE"
let kSuccess = "Success"
let kFailure = "Failure"
let kSessionToken = "sessionToken"
let kRefreshToken = "refreshToken"
let kUserId = "id"
let kPutMethod = "PUT"
let kPostMethod = "POST"
let kGetMethod = "GET"
let kAPIStatusCode = "status_code"
let KvenueUndrScid = "venue_id"
let KCairoSemiBold = "Cairo-SemiBold"

//MARK:- Alert messages
let kOTPSent  = "OTP Sent"
let kOTPStatus  = "OTP Verified Successfully"
let kFacebookStatus  = "Facebook Login Successfull"
let kFillAllFields = "Please fill all fields"
let kFillPassword = "Please fill Password"
let kFillOTP = "Please fill OTP"
let kInvalidEmail  = "Please enter a valid email"
let kInvalidPhoneNo  = "Phone number should be 8-10 digits"
let kInvalidPassword  = "Password should be 6-15 characters"
let kInvalidCardNumber  = "Please add a valid card number"
let kInvalidCVVNumber  = "Please add a valid CVV number"
let kAcceptTerms  = "Please Accept Terms and Conditions"
let kAddPromocode  = "Please add a Promo Code to Apply"
let kAddCardDetails  = "Please add Card Details to continue"
let kSuccessLogin  = "Congratulations! You have registered successfully. Please Login to Continue."
let kLoginFailure = "Unable to login. Please try again later"
let kRequestFailure = "Request cannot be processed right now. Please try again later"
let kInternetCheck = "Please check your Internet connection"
let kEmailAlreadyExist = "Email Already Exist!"
let kPhoneNoAlreadyExist = "Phone Number Already Exist!"
let kUserCreated = "User Created"
let kBadRequest = "Bad Request"
let kAddressChanged = "Default Address Changed Successfully"
let kAddAddress = "Please enter address to continue"
let kChoosePlan = "Please choose a plan to continue"
let KCairoRegular = "Cairo-Regular"
let Kimg = "img"
let KcharcterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,"
let KCharecterSetSpace = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz, 1234567890"
let Kplace = "place"
let Kpredictions = "predictions"
let KPostSuccess = "Post_Success"
let KShowRating = "ShowRating"
let KCheckGray = "CheckGray"
let KSpeaker = "Speaker"
let KNoJobsFound = "No Jobs Found"
let KHistoryGray = "HistoryGray"
let KGetJobs = "Get_Jobs"
let KVenuJob_ActiveCell = "VenuJob_ActiveCell"
/*Main Color for App*/
let mainColor = UIColor.init(colorLiteralRed: 51.0/255.0, green: 169.0/255.0, blue: 242.0/255.0, alpha: 1.0)

let kBaseColor = UIColor.init(colorLiteralRed:147.0/255.0, green: 23.0/255.0, blue: 23.0/255.0, alpha: 1.0)

let kPlowzColor = UIColor.init(colorLiteralRed:18.0/255.0, green: 170.0/255.0, blue: 234.0/255.0, alpha: 1.0)

let kMowzColor = UIColor.init(colorLiteralRed:30.0/255.0, green: 188.0/255.0, blue: 97.0/255.0, alpha: 1.0)

let kLawnzColor = UIColor.init(colorLiteralRed:241.0/255.0, green: 137.0/255.0, blue: 45.0/255.0, alpha: 1.0)


/*Check Platform*/
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

/*Declare fblogin Manager*/
private var _fbLoginManager: FBSDKLoginManager?
var fbLoginManager: FBSDKLoginManager {
get {
    if _fbLoginManager == nil {
        _fbLoginManager = FBSDKLoginManager()
    }
    return _fbLoginManager!
 }
}


/*Check for String is Valid Email*/
extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "\\A[a-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,4}\\z"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPostcode() -> Bool {
        let postcodeRegEx = "^(0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})$"
        let postcodeTest = NSPredicate(format:"SELF MATCHES %@", postcodeRegEx)
        return postcodeTest.evaluate(with: self)
    }
    
    
    var isAlphanumeric: Bool {
        return range(of: "^[a-zA-Z0-9]+$", options: .regularExpression) != nil
    }

}

/*Get Context from CoreData*/
//func getContext () -> NSManagedObjectContext {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    return appDelegate.persistentContainer.viewContext
//}

 
extension UIView {
    
    enum PeakSide: Int {
        case Top
        case Left
        case Right
        case Bottom
    }
    
    
    func addPikeOnView( side: PeakSide, size: CGFloat = 10.0) {
        self.layoutIfNeeded()
        let peakLayer = CAShapeLayer()
        var path: CGPath?
        switch side {
        case .Top:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: size, rightSize: 0.0, bottomSize: 0.0, leftSize: 0.0)
        case .Left:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: 0.0, leftSize: size)
        case .Right:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: size, bottomSize: 0.0, leftSize: 0.0)
        case .Bottom:
            path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: size, leftSize: 0.0)
        }
        peakLayer.path = path
        let color = (self.backgroundColor?.cgColor)
        peakLayer.fillColor = color
        peakLayer.strokeColor = color
        peakLayer.lineWidth = 1
        peakLayer.position = CGPoint.zero
        self.layer.insertSublayer(peakLayer, at: 0)
    }
    
    
    func makePeakPathWithRect(rect: CGRect, topSize ts: CGFloat, rightSize rs: CGFloat, bottomSize bs: CGFloat, leftSize ls: CGFloat) -> CGPath {
        //                      P3
        //                    /    \
        //      P1 -------- P2     P4 -------- P5
        //      |                               |
        //      |                               |
        //      P16                            P6
        //     /                                 \
        //  P15                                   P7
        //     \                                 /
        //      P14                            P8
        //      |                               |
        //      |                               |
        //      P13 ------ P12    P10 -------- P9
        //                    \   /
        //                     P11
        
        let centerX = rect.width - 30
        let centerY = rect.height / 2
        var h: CGFloat = 0
        let path = CGMutablePath()
        var points: [CGPoint] = []
        // P1
        points.append(CGPoint(x:rect.origin.x,y: rect.origin.y))
        // Points for top side
        if ts > 0 {
            h = ts * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y
            points.append(CGPoint(x:x - ts,y: y))
            points.append(CGPoint(x:x,y: y - h))
            points.append(CGPoint(x:x + ts,y: y))
        }
        
        // P5
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y))
        // Points for right side
        if rs > 0 {
            h = rs * sqrt(3.0) / 2
            let x = rect.origin.x + rect.width
            let y = rect.origin.y + centerY
            points.append(CGPoint(x:x,y: y - rs))
            points.append(CGPoint(x:x + h,y: y))
            points.append(CGPoint(x:x,y: y + rs))
        }
        
        // P9
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y + rect.height))
        // Point for bottom side
        if bs > 0 {
            h = bs * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y + rect.height
            points.append(CGPoint(x:x + bs,y: y))
            points.append(CGPoint(x:x,y: y + h))
            points.append(CGPoint(x:x - bs,y: y))
        }
        
        // P13
        points.append(CGPoint(x:rect.origin.x, y: rect.origin.y + rect.height))
        // Point for left sidey:
        if ls > 0 {
            h = ls * sqrt(3.0) / 2
            let x = rect.origin.x
            let y = rect.origin.y + centerY
            points.append(CGPoint(x:x,y: y + ls))
            points.append(CGPoint(x:x - h,y: y))
            points.append(CGPoint(x:x,y: y - ls))
        }
        
        let startPoint = points.removeFirst()
        self.startPath(path: path, onPoint: startPoint)
        for point in points {
            self.addPoint(point: point, toPath: path)
        }
        self.addPoint(point: startPoint, toPath: path)
        return path
    }
    
    func startPath( path: CGMutablePath, onPoint point: CGPoint) {
        path.move(to: CGPoint(x: point.x, y: point.y))
    }
    
    func addPoint(point: CGPoint, toPath path: CGMutablePath) {
        path.addLine(to: CGPoint(x: point.x, y: point.y))
    }
    
    
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}






