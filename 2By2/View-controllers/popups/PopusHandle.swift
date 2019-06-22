//
//  popusHandle.swift
//  2By2
//
//  Created by mac on 11/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class PopusHandle: UIViewController {

    class func openGenderPopup() -> GenderPopUpViewController {
        let tab = getStoryBoard().instantiateInitialViewController() as! GenderPopUpViewController
        return tab
    }
    
    class func openAgePopup() -> AgePopUpViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "agePopupViewController") as! AgePopUpViewController
        return tab
    }
    
    class func openAgendaPopup() -> agendaPopupViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "agendaPopupViewController") as! agendaPopupViewController
        return tab
    }
    
    private static func getStoryBoard() -> UIStoryboard {
        let story = UIStoryboard(name: "popups", bundle: nil)
        return story
    }
    
    class func openBMIPopup() -> BMIPopUpViewController {
        let storyboard = UIStoryboard(name: "popups", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "bmiPopupViewController") as! BMIPopUpViewController
        return vc 
    }
    
    class func pickYourCoachPopupViewController() -> PickYourCoachPOPUPViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "pickYourCoachPopupViewController") as! PickYourCoachPOPUPViewController
        return tab
    }
    
    class func CoachSliderPopupViewController() -> coachesSliderPOPUPViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "coachSliderPopupViewController") as! coachesSliderPOPUPViewController
        return tab
    }
    
    class func WorkoutBuddyPopupViewController() -> workoutBuddyPOPUPViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "workoutPopupViewController") as! workoutBuddyPOPUPViewController
        return tab
    }
    
    class func FilterPOPUPViewController() -> FilterPOPUPViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "filterVCPopupViewController") as! FilterPOPUPViewController
        return tab
    }
    
    
    
    class func calenderViewController() -> calenderViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "calenderVCPopupViewController") as! calenderViewController
        return tab
    }
    
    class func HWPopupViewController() -> HWPopupViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "HWPopupViewController") as! HWPopupViewController
        return tab
    }
    
    class func detailsPopupViewController() -> detailsPOPUPViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "detailsPopupViewController") as! detailsPOPUPViewController
        return tab
    }
    
    
    
    class func ratePopupViewController() -> coachPOPUPRateViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "ratePopupViewController") as! coachPOPUPRateViewController
        return tab
    }
    
    class func changePasswordPopupViewController() -> changePasswordPOPUPViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "changePasswordPopupViewController") as! changePasswordPOPUPViewController
        return tab
    }
    
    class func changePOPUPViewController() -> changePOPUPViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "changeMobilePopupViewController") as! changePOPUPViewController
        return tab
    }
    
    class func sessionExperiencesViewController() -> sessionExperiencesViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "sessionExperiencesViewController") as! sessionExperiencesViewController
        return tab
    }
    
    class func paymyinstallmentPopupViewController() -> payMyInstallmentPOPUPViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "paymyinstallmentPopupViewController") as! payMyInstallmentPOPUPViewController
        return tab
    }
    
    class func inbodyPOPUPViewController() -> inbodyPOPUPViewController {
        let tab = getStoryBoard().instantiateViewController(withIdentifier: "inbodyPopupViewController") as! inbodyPOPUPViewController
        return tab
    }
    
    
    
    
}
