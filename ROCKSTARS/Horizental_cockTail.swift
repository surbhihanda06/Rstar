//
//  NapySlider.swift
//  NapySlider
//
//  Created by Jonas Schoch on 12.12.15.
//  Copyright © 2015 naptics. All rights reserved.
//

import UIKit

@IBDesignable
open class Horizental_cockTail: UIControl {
    
    // internal variables, our views
    internal var backgroundView: UIView!
    internal var titleBackgroundView: UIView!
    internal var sliderView: UIView!
    internal var sliderBackgroundView: UIView!
    internal var sliderFillView: UIView!
    internal var handleView: UIView!
    internal var currentPosTriangle: TriangleView!
    
     internal var titleLabel: UILabel!
     internal var separtionLabel1: UILabel!
     internal var separtionLabel2: UILabel!
     internal var separtionLabel3: UILabel!
     internal var separtionLabel4: UILabel!
     internal var separtionLabel5: UILabel!
     internal var separtionLabel6: UILabel!
    
    internal var separtionLevel_lbl1: UILabel!
     internal var separtionLevel_lbl2: UILabel!
     internal var separtionLevel_lbl3: UILabel!
     internal var separtionLevel_lbl4: UILabel!
     internal var separtionLevel_lbl5: UILabel!
     internal var separtionLevel_lbl6: UILabel!


    
    internal var handleLabel: UILabel!
    internal var handleImg = UIImageView()
     //handleImg = UIImageView()
    
    internal var currentPosLabel: UILabel!
    internal var currentPosImg: UIImageView!
    internal var maxLabel: UILabel!
    internal var minLabel: UILabel!

    internal var isFloatingPoint: Bool {
        get { return step.truncatingRemainder(dividingBy: 1) != 0 ? true : false }
    }

    // public variables
    var titleHeight: CGFloat = 30
    var sliderWidth: CGFloat = 15
    var handleHeight: CGFloat = 30
    var handleWidth: CGFloat = 50
    
    // public inspectable variables
    @IBInspectable var title: String = "Hello" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var min: Double = 0 {
        didSet {
            //minLabel.text = textForPosition(min)
            minLabel.text = ""
        }
    }
    
    @IBInspectable var max: Double = 8 {
        didSet {
            //maxLabel.text = textForPosition(max)
            maxLabel.text = ""

        }
    }
    
    @IBInspectable var step: Double = 1
    
    // colors
    @IBInspectable var handleColor: UIColor = UIColor.gray
    @IBInspectable var mainBackgroundColor: UIColor = UIColor.groupTableViewBackground
    @IBInspectable var titleBackgroundColor: UIColor = UIColor.lightGray
    @IBInspectable var sliderUnselectedColor: UIColor = UIColor.lightGray
    
    /**
     the position of the handle. The handle moves animated when setting the variable
    */
    var handlePosition:Double {
        set (newHandlePosition) {
            moveHandleToPosition(newHandlePosition, animated: true)
        }
        get {
            let currentY = handleView.frame.origin.y + handleHeight/2
            let positionFromMin = -(Double(currentY) - minPosition - stepheight/2) / stepheight
            
            // add an offset if slider should go to a negative value
            var stepOffset:Double = 0
            if min < 0 {
            let zeroPosition = (0 - min)/Double(step) + 0.5
                if positionFromMin < zeroPosition {
                    stepOffset = 0 - step
                }
            }
            
            //let position = Int((positionFromMin * step + min + stepOffset) / step) * Int(step)
            let position = Double(Int((positionFromMin * step + min + stepOffset) / step)) * step
            return Double(position)
        }
    }
    
    var disabled:Bool = false {
        didSet {
            sliderBackgroundView.alpha = disabled ? 0.4 : 1.0
            self.isUserInteractionEnabled = !disabled
        }
    }
    
    
    fileprivate var steps: Int {
        get {
            if (min == max || step == 0) {
                return 1
            } else {
                return Int(round((max - min) / step)) + 1
            }
        }
    }
    
    fileprivate var maxPosition:Double {
        get {
            return 0
        }
    }
    
    fileprivate var minPosition:Double {
        get {
            return Double(sliderView.frame.height)
        }
    }
    
    
    fileprivate var stepheight:Double {
        get {
            return (minPosition - maxPosition) / Double(steps - 1)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    fileprivate func setup() {
        backgroundView = UIView()
        backgroundView.isUserInteractionEnabled = false
        addSubview(backgroundView)
        
        titleBackgroundView = UIView()
        addSubview(titleBackgroundView)
        
       
        
        sliderBackgroundView = UIView()
        sliderBackgroundView.isUserInteractionEnabled = false
        backgroundView.addSubview(sliderBackgroundView)
        
        
        sliderFillView = UIView()
        sliderFillView.isUserInteractionEnabled = false
        sliderBackgroundView.addSubview(sliderFillView)
        
        
        separtionLabel1 = UILabel()
        sliderBackgroundView.addSubview(separtionLabel1)
        
        separtionLabel2 = UILabel()
        sliderBackgroundView.addSubview(separtionLabel2)
        
        separtionLabel3 = UILabel()
        sliderBackgroundView.addSubview(separtionLabel3)
        
        separtionLabel4 = UILabel()
        sliderBackgroundView.addSubview(separtionLabel4)
        
        separtionLabel5 = UILabel()
        sliderBackgroundView.addSubview(separtionLabel5)
        
        separtionLabel6 = UILabel()
        sliderBackgroundView.addSubview(separtionLabel6)
        
        separtionLevel_lbl1 = UILabel()
        sliderBackgroundView.addSubview(separtionLevel_lbl1)
        
        separtionLevel_lbl2 = UILabel()
        sliderBackgroundView.addSubview(separtionLevel_lbl2)

        
        separtionLevel_lbl3 = UILabel()
        sliderBackgroundView.addSubview(separtionLevel_lbl3)

        
        separtionLevel_lbl4 = UILabel()
        sliderBackgroundView.addSubview(separtionLevel_lbl4)

        
        separtionLevel_lbl5 = UILabel()
        sliderBackgroundView.addSubview(separtionLevel_lbl5)
        separtionLevel_lbl6 = UILabel()
        sliderBackgroundView.addSubview(separtionLevel_lbl6)


        
        
        
        sliderView = UIView()
        sliderView.isUserInteractionEnabled = false
        sliderBackgroundView.addSubview(sliderView)
        
        
        
       
        
        titleLabel = UILabel()
        titleBackgroundView.addSubview(titleLabel)
       
        
        handleView = UIView()
        handleView.isUserInteractionEnabled = false
        sliderView.addSubview(handleView)
        
        
        handleImg = UIImageView()
        handleView.addSubview(handleImg)
        
        handleLabel = UILabel()
        handleView.addSubview(handleLabel)
        
        minLabel = UILabel()
        backgroundView.addSubview(minLabel)
        
        maxLabel = UILabel()
        backgroundView.addSubview(maxLabel)
        
        currentPosLabel = UILabel()
       // sliderBackgroundView.addSubview(currentPosLabel)
        
        currentPosImg = UIImageView()
      //  sliderBackgroundView.addSubview(currentPosImg)
        
        currentPosTriangle = TriangleView()
        currentPosLabel.addSubview(currentPosTriangle)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
      //  sliderBackgroundView.layer.borderWidth = 1
       // sliderBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
        
        titleBackgroundView.isHidden = true
        
        sliderFillView.layer.cornerRadius = 5.0
        sliderView.layer.cornerRadius = 5.0
        sliderBackgroundView.layer.cornerRadius = 5.0
        
       // handleView.isHidden = true
        
        let sliderPaddingTop:CGFloat = 0
        
        let sliderPaddingBottom:CGFloat = 0
        
        
        
      
        
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
       // backgroundView.backgroundColor = mainBackgroundColor
        
        titleBackgroundView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: titleHeight)
        titleBackgroundView.backgroundColor = titleBackgroundColor
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: titleBackgroundView.frame.width, height: titleBackgroundView.frame.height)
        titleLabel.text = title
        titleLabel.textColor = handleColor
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        titleLabel.textAlignment = NSTextAlignment.center
        
        sliderBackgroundView.frame = CGRect(x: backgroundView.frame.width/2 - sliderWidth/2, y: sliderPaddingTop, width: sliderWidth, height: backgroundView.frame.height - (sliderPaddingTop + sliderPaddingBottom))
        
        let PartHeight : CGFloat = (sliderBackgroundView.frame.size.height/4)
        
       
        
        
        separtionLabel1.frame = CGRect(x: 0, y: sliderBackgroundView.frame.size.height-5, width: sliderWidth, height: 1)
        separtionLabel1.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel1.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        separtionLevel_lbl1.frame = CGRect(x: separtionLabel1.frame.size.width-1, y: sliderBackgroundView.frame.size.height-5-10, width: 20, height: 20)
        separtionLevel_lbl1.text = "0"
        separtionLevel_lbl1.textColor = UIColor.darkGray
        separtionLevel_lbl1.textAlignment = .center
        separtionLevel_lbl1.font = UIFont.systemFont(ofSize: 10)
        
         var separtionTop = PartHeight
        
        separtionLabel4.frame = CGRect(x: 0, y: separtionTop, width: sliderWidth, height: 1)
        separtionLabel4.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        separtionLevel_lbl4.frame = CGRect(x: separtionLabel4.frame.size.width-1, y: separtionTop-10, width: 20, height: 20)
        separtionLevel_lbl4.text = "3"
        separtionLevel_lbl4.textColor = UIColor.darkGray
       // separtionLevel_lbl4.backgroundColor = UIColor.yellow
        separtionLevel_lbl4.textAlignment = .center
        separtionLevel_lbl4.font = UIFont.systemFont(ofSize: 10)
        
        
         separtionTop = separtionTop+PartHeight
        
        separtionLabel3.frame = CGRect(x: 0, y: separtionTop, width: sliderWidth, height: 1)
        separtionLabel3.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        separtionLevel_lbl3.frame = CGRect(x: separtionLabel4.frame.size.width-1, y: separtionTop-10, width: 20, height: 20)
        separtionLevel_lbl3.text = "2"
        separtionLevel_lbl3.textColor = UIColor.darkGray
        separtionLevel_lbl3.textAlignment = .center
        separtionLevel_lbl3.font = UIFont.systemFont(ofSize: 10)

        
        separtionTop = separtionTop+PartHeight
        
        separtionLabel2.frame = CGRect(x: 0, y: separtionTop, width: sliderWidth, height: 1)
      
        separtionLabel2.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        separtionLevel_lbl2.frame = CGRect(x: separtionLabel4.frame.size.width-1, y: separtionTop-10, width: 20, height: 20)
        separtionLevel_lbl2.text = "1"
        separtionLevel_lbl2.textColor = UIColor.darkGray
        separtionLevel_lbl2.textAlignment = .center
        separtionLevel_lbl2.font = UIFont.systemFont(ofSize: 10)
        
        
        separtionTop = separtionTop+PartHeight
        
       /* separtionLabel1.frame = CGRect(x: 0, y: separtionTop, width: sliderWidth, height: 1)
       
        separtionLabel1.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        separtionLevel_lbl1.frame = CGRect(x: separtionLabel4.frame.size.width, y: separtionTop-5, width: 10, height: 10)
        separtionLevel_lbl1.text = "1"
        separtionLevel_lbl1.textColor = UIColor.darkGray
        separtionLevel_lbl1.textAlignment = .center
        separtionLevel_lbl2.font = UIFont.systemFont(ofSize: 10)\
 
 */
        
      //  separtionTop = separtionTop+PartHeight
        
        separtionLabel5.frame = CGRect(x: 0, y: 2, width: sliderWidth, height: 1)
        separtionLabel5.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        separtionLevel_lbl5.frame = CGRect(x: separtionLabel4.frame.size.width-1, y: 0-7, width: 20, height: 20)
        separtionLevel_lbl5.text = "4"
        separtionLevel_lbl5.textColor = UIColor.darkGray
        separtionLevel_lbl5.textAlignment = .center
        separtionLevel_lbl5.font = UIFont.systemFont(ofSize: 10)
        
       // separtionTop = separtionTop+PartHeight


        
        
        
        sliderBackgroundView.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        
        sliderView.frame = CGRect(x: 0, y: sliderWidth/2, width: sliderBackgroundView.frame.width, height: sliderBackgroundView.frame.height - sliderWidth)
        sliderView.backgroundColor = UIColor.clear
        
        handleView.frame = CGRect(x: -(handleWidth-sliderWidth)/2, y: sliderView.frame.height - handleHeight/2, width: handleWidth, height: handleHeight)
        handleView.backgroundColor = UIColor.clear
        
        sliderFillView.frame = CGRect(x: 0, y: handleView.frame.origin.y + handleHeight, width: sliderBackgroundView.frame.width, height: sliderBackgroundView.frame.height-handleView.frame.origin.y - handleHeight)
        sliderFillView.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        handleLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 27)
        handleLabel.text = ""
        handleLabel.textAlignment = NSTextAlignment.center
        handleLabel.textColor = UIColor.white
        handleLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFontWeightBold)
        handleLabel.backgroundColor = UIColor.clear
        
        minLabel.frame = CGRect(x: 0, y: backgroundView.frame.height-20, width: backgroundView.frame.width, height: 20)
       // minLabel.text = textForPosition(min)
        minLabel.textAlignment = NSTextAlignment.center
        minLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFontWeightRegular)
        minLabel.textColor = handleColor
        
        maxLabel.frame = CGRect(x: 0, y: 5, width: backgroundView.frame.width, height: 20)
       // maxLabel.text = textForPosition(max)
        maxLabel.textAlignment = NSTextAlignment.center
        maxLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFontWeightRegular)
        maxLabel.textColor = handleColor
        
        currentPosLabel.frame = CGRect(x: (handleView.frame.origin.x)-handleWidth, y: handleView.frame.origin.y + handleHeight*0.5/2, width: handleWidth, height: handleHeight)
      //  currentPosImg.frame = CGRect(x: (handleView.frame.origin.x)-handleWidth+5, y: handleView.frame.origin.y+2 + handleHeight*0.5/2, width: handleWidth, height: handleHeight)
        
         currentPosImg.frame = CGRect(x: currentPosImg.frame.origin.x+15, y: currentPosImg.frame.origin.y+3, width: currentPosImg.frame.size.width-5, height: currentPosImg.frame.size.height-6)
        currentPosLabel.text = ""
        currentPosLabel.textAlignment = NSTextAlignment.center
        currentPosLabel.textColor = UIColor.white
        handleLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
        currentPosLabel.backgroundColor = tintColor
        currentPosLabel.alpha = 0.0
        
        currentPosTriangle.frame = CGRect(x: -10, y: 10, width: currentPosLabel.frame.height-20, height: currentPosLabel.frame.height-20)
        currentPosTriangle.tintColor = tintColor
        currentPosTriangle.backgroundColor = UIColor.clear
        
        
        handleImg.frame = CGRect(x: 0, y: 0, width: handleView.frame.size.width, height: handleView.frame.size.height)
        
        handleImg.image = UIImage.init(named: "scroll")
        
        
        
        currentPosImg.frame = CGRect(x: currentPosLabel.frame.origin.x+15, y: currentPosLabel.frame.origin.y+3, width: currentPosLabel.frame.size.width-5, height: currentPosLabel.frame.size.height-6)
        currentPosImg.image =  UIImage.init(named: "arrow-1")
        currentPosImg.contentMode = .scaleAspectFit
        // currentPosImg.contentMode =
        
        
        //viewHorizentalSlider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
         separtionLevel_lbl4.transform = CGAffineTransform(rotationAngle: (3*CGFloat.pi)/2);
        separtionLevel_lbl1.transform = CGAffineTransform(rotationAngle: (3*CGFloat.pi)/2);
        separtionLevel_lbl3.transform = CGAffineTransform(rotationAngle: (3*CGFloat.pi)/2);
        separtionLevel_lbl2.transform = CGAffineTransform(rotationAngle: (3*CGFloat.pi)/2);
        separtionLevel_lbl5.transform = CGAffineTransform(rotationAngle: (3*CGFloat.pi)/2);
        handleLabel.transform = CGAffineTransform(rotationAngle: (3*CGFloat.pi)/2);
       // dayLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)

    }

    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.currentPosLabel.alpha = 0.0
        })
        return true
    }

    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        let _ = handlePosition
        let point = touch.location(in: sliderView)
        moveHandleToPoint(point)

        return true
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        let endPosition = handlePosition
        handlePosition = endPosition
        handleLabel.text = textForPosition(handlePosition)

        UIView.animate(withDuration: 0.3, animations: {
            self.currentPosLabel.alpha = 0.0
        })
    }

    open override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
    }
    
    
    fileprivate func moveHandleToPoint(_ point:CGPoint)
    {
        var newY:CGFloat
        
        newY = point.y - CGFloat(handleView.frame.height/2)
        
        if newY < -handleHeight/2 {
            newY = -handleHeight/2
        } else if newY > sliderView.frame.height - handleHeight/2 {
            newY = sliderView.frame.height - handleHeight/2
        }
        
        handleView.frame.origin.y = CGFloat(newY)
        sliderFillView.frame = CGRect(x: 0 , y: CGFloat(newY) + handleHeight, width: sliderBackgroundView.frame.width, height: sliderBackgroundView.frame.height-handleView.frame.origin.y - handleHeight)
        
        currentPosLabel.frame = CGRect(x: (handleView.frame.origin.x)-handleWidth, y: handleView.frame.origin.y + handleHeight*0.5/2, width: currentPosLabel.frame.width, height: currentPosLabel.frame.height)
        
        // currentPosImg.frame = CGRect(x: (handleView.frame.origin.x)-handleWidth+5, y: handleView.frame.origin.y+2 + handleHeight*0.5/2, width: currentPosLabel.frame.width, height: currentPosLabel.frame.height)
        
         currentPosImg.frame = CGRect(x: currentPosLabel.frame.origin.x+15, y: currentPosLabel.frame.origin.y+3, width: currentPosLabel.frame.size.width-5, height: currentPosLabel.frame.size.height-6)
        
        let newText = textForPosition(handlePosition)
        if handleLabel.text != newText {
            handleLabel.text = newText
            currentPosLabel.text = newText
        }
        
       
        separtionLabel1.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel5.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel4.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel3.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel2.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel6.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        if(handlePosition == 0)
        {
            
            separtionLabel1.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel5.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel4.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel3.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel2.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel6.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        }
        else if(handlePosition == 1)
        {
            separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
           // separtionLabel2.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
        else if(handlePosition == 2)
        {
            separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel2.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
           // separtionLabel3.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
        else if(handlePosition == 3)
        {
            
            separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel2.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel3.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
           // separtionLabel4.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
        else if(handlePosition == 4)
        {
            separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel2.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel3.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel4.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
           // separtionLabel5.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
    /*    else if(handlePosition == 5)
        {
            
            separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel2.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel3.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel4.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel5.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
           // separtionLabel6.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
 */

    }
    
    fileprivate func moveHandleToPosition(_ position:Double, animated:Bool = false) {
        if step == 0 { return }

        var goPosition = position
        
        if position >= max { goPosition = max }
        if position <= min { goPosition = min }
        
        let positionFromMin = (goPosition - min) / step
        
        let newY = CGFloat(minPosition - positionFromMin * stepheight)
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.handleView.frame.origin.y = newY - self.handleHeight/2
                self.sliderFillView.frame = CGRect(x: 0 , y: CGFloat(newY) + self.handleHeight/2, width: self.sliderBackgroundView.frame.width, height: self.sliderBackgroundView.frame.height - self.handleView.frame.origin.y - self.handleHeight)
                self.currentPosLabel.frame = CGRect(x: (self.handleView.frame.origin.x)-self.handleWidth, y: self.handleView.frame.origin.y + self.handleHeight*0.5/2, width: self.currentPosLabel.frame.width, height: self.currentPosLabel.frame.height)
                
               // self.currentPosImg.frame = CGRect(x: (self.handleView.frame.origin.x)-self.handleWidth+5, y: self.handleView.frame.origin.y+2 + self.handleHeight*0.5/2, width: self.currentPosLabel.frame.width, height: self.currentPosLabel.frame.height)
                
                 self.currentPosImg.frame = CGRect(x: self.currentPosLabel.frame.origin.x+15, y: self.currentPosLabel.frame.origin.y+3, width: self.currentPosLabel.frame.size.width-5, height: self.currentPosLabel.frame.size.height-6)
            })
        } else {
            self.handleView.frame.origin.y = newY - self.handleHeight/2
            self.sliderFillView.frame.origin.y = CGFloat(newY) + self.handleHeight
            currentPosLabel.frame = CGRect(x:  (handleView.frame.origin.x)-handleWidth, y: handleView.frame.origin.y + handleHeight*0.5/2, width: currentPosLabel.frame.width, height: currentPosLabel.frame.height)
            
            //  currentPosImg.frame = CGRect(x:  (handleView.frame.origin.x)-handleWidth+5, y: handleView.frame.origin.y+2 + handleHeight*0.5/2, width: currentPosLabel.frame.width, height: currentPosLabel.frame.height)
            
             currentPosImg.frame = CGRect(x: currentPosLabel.frame.origin.x+15, y: currentPosLabel.frame.origin.y+3, width: currentPosLabel.frame.size.width-5, height: currentPosLabel.frame.size.height-6)
            
            
        }
        
        let newText = textForPosition(position)
        if handleLabel.text != newText {
            handleLabel.text = newText
            currentPosLabel.text = newText
        }
        
       //separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        separtionLabel1.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel5.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel4.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel3.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel2.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        separtionLabel6.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        if(handlePosition == 0)
        {
            
            separtionLabel1.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel5.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel4.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel3.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel2.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
            separtionLabel6.backgroundColor = UIColor.init(red: 120.0/255.0, green: 0.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        }
        else if(handlePosition == 1)
        {
            separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            // separtionLabel2.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
        else if(handlePosition == 2)
        {
            separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel2.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            // separtionLabel3.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
        else if(handlePosition == 3)
        {
            
            separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel2.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel3.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            // separtionLabel4.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
        else if(handlePosition == 4)
        {
            separtionLabel1.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel2.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel3.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            separtionLabel4.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            // separtionLabel5.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        }
 
        
        if(UserDefaults.standard.bool(forKey: KCockTail_Edit))
        {
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: KCockTail_Edit), object: nil, userInfo: nil)
            
        }
            
    }
    
    fileprivate func textForPosition(_ position:Double) -> String {
        if isFloatingPoint { return String(format: "%0.1f", arguments: [position]) }
        else { return String(format: "%0.0f", arguments: [position]) }
    }
}


class TriangleView : UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        
        let ctx : CGContext = UIGraphicsGetCurrentContext()!
        
        ctx.beginPath()
        ctx.move(to: CGPoint(x: rect.minX, y: rect.maxY/2.0))
        ctx.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        ctx.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        ctx.closePath()
        
        ctx.setFillColor(tintColor.cgColor)
        ctx.fillPath()
    }
}
