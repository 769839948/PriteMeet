//
//  NVActivityIndicatorView.swift
//  NVActivityIndicatorViewDemo
//
//  Created by Nguyen Vinh on 7/21/15.
//  Copyright (c) 2015 Nguyen Vinh. All rights reserved.
//

import UIKit

public enum NVActivityIndicatorType {
    case blank
    case ballPulse
    case ballGridPulse
    case ballClipRotate
    case squareSpin
    case ballClipRotatePulse
    case ballClipRotateMultiple
    case ballPulseRise
    case ballRotate
    case cubeTransition
    case ballZigZag
    case ballZigZagDeflect
    case ballTrianglePath
    case ballScale
    case lineScale
    case lineScaleParty
    case ballScaleMultiple
    case ballPulseSync
    case ballBeat
    case lineScalePulseOut
    case lineScalePulseOutRapid
    case ballScaleRipple
    case ballScaleRippleMultiple
    case ballSpinFadeLoader
    case lineSpinFadeLoader
    case triangleSkewSpin
    case pacman
    case ballGridBeat
    case semiCircleSpin
    case ballRotateChase
    
    fileprivate func animation() -> NVActivityIndicatorAnimationDelegate {
        switch self {
        case .blank:
            return NVActivityIndicatorAnimationBlank()
        case .ballPulse:
            return NVActivityIndicatorAnimationBallPulse()
        case .ballGridPulse:
            return NVActivityIndicatorAnimationBallGridPulse()
        case .ballClipRotate:
            return NVActivityIndicatorAnimationBallClipRotate()
        case .squareSpin:
            return NVActivityIndicatorAnimationSquareSpin()
        case .ballClipRotatePulse:
            return NVActivityIndicatorAnimationBallClipRotatePulse()
        case .ballClipRotateMultiple:
            return NVActivityIndicatorAnimationBallClipRotateMultiple()
        case .ballPulseRise:
            return NVActivityIndicatorAnimationBallPulseRise()
        case .ballRotate:
            return NVActivityIndicatorAnimationBallRotate()
        case .cubeTransition:
            return NVActivityIndicatorAnimationCubeTransition()
        case .ballZigZag:
            return NVActivityIndicatorAnimationBallZigZag()
        case .ballZigZagDeflect:
            return NVActivityIndicatorAnimationBallZigZagDeflect()
        case .ballTrianglePath:
            return NVActivityIndicatorAnimationBallTrianglePath()
        case .ballScale:
            return NVActivityIndicatorAnimationBallScale()
        case .lineScale:
            return NVActivityIndicatorAnimationLineScale()
        case .lineScaleParty:
            return NVActivityIndicatorAnimationLineScaleParty()
        case .ballScaleMultiple:
            return NVActivityIndicatorAnimationBallScaleMultiple()
        case .ballPulseSync:
            return NVActivityIndicatorAnimationBallPulseSync()
        case .ballBeat:
            return NVActivityIndicatorAnimationBallBeat()
        case .lineScalePulseOut:
            return NVActivityIndicatorAnimationLineScalePulseOut()
        case .lineScalePulseOutRapid:
            return NVActivityIndicatorAnimationLineScalePulseOutRapid()
        case .ballScaleRipple:
            return NVActivityIndicatorAnimationBallScaleRipple()
        case .ballScaleRippleMultiple:
            return NVActivityIndicatorAnimationBallScaleRippleMultiple()
        case .ballSpinFadeLoader:
            return NVActivityIndicatorAnimationBallSpinFadeLoader()
        case .lineSpinFadeLoader:
            return NVActivityIndicatorAnimationLineSpinFadeLoader()
        case .triangleSkewSpin:
            return NVActivityIndicatorAnimationTriangleSkewSpin()
        case .pacman:
            return NVActivityIndicatorAnimationPacman()
        case .ballGridBeat:
            return NVActivityIndicatorAnimationBallGridBeat()
        case .semiCircleSpin:
            return NVActivityIndicatorAnimationSemiCircleSpin()
        case .ballRotateChase:
            return NVActivityIndicatorAnimationBallRotateChase()
        }
    }
}

open class NVActivityIndicatorView: UIView {
    fileprivate static let DEFAULT_TYPE: NVActivityIndicatorType = .pacman
    fileprivate static let DEFAULT_COLOR = UIColor.white
    fileprivate static let DEFAULT_SIZE: CGSize = CGSize(width: 40, height: 40)
    
    open var type: NVActivityIndicatorType
    open var color: UIColor
    open var nvSize: CGSize
    
    open var animating: Bool = false
    open var hidesWhenStopped: Bool = true
    
    /**
        Create a activity indicator view with default type, color and size
        This is used by storyboard to initiate the view
    
        - Default type is pacman\n
        - Default color is white\n
        - Default size is 40
    
        - parameter decoder:
    
        - returns: The activity indicator view
    */
    required public init?(coder aDecoder: NSCoder) {
        self.type = NVActivityIndicatorView.DEFAULT_TYPE
        self.color = NVActivityIndicatorView.DEFAULT_COLOR
        self.nvSize = NVActivityIndicatorView.DEFAULT_SIZE
        super.init(coder: aDecoder);
        super.backgroundColor = UIColor.clear
    }
    
    /**
        Create a activity indicator view with specified type, color, size and size
        
        - parameter frame: view's frame
        - parameter type: animation type, value of NVActivityIndicatorType enum. Default type is pacman.
        - parameter color: color of activity indicator view. Default color is white.
        - parameter size: actual size of animation in view. Default size is 40
    
        - returns: The activity indicator view
    */
    public init(frame: CGRect, type: NVActivityIndicatorType = DEFAULT_TYPE, color: UIColor = DEFAULT_COLOR, size: CGSize = DEFAULT_SIZE) {
        self.type = type
        self.color = color
        self.nvSize = size
        super.init(frame: frame)
    }
    
    /**
        Start animation
    */
    open func startAnimation() {
        if hidesWhenStopped && isHidden {
            isHidden = false
        }
        if (self.layer.sublayers == nil) {
            setUpAnimation()
        }
        self.layer.speed = 1
        self.animating = true
    }
    
    /**
        Stop animation
    */
    open func stopAnimation() {
        self.layer.speed = 0
        self.animating = false
        if hidesWhenStopped && !isHidden {
            isHidden = true
        }
    }
    
    // MARK: Privates

    fileprivate func setUpAnimation() {
        let animation: NVActivityIndicatorAnimationDelegate = self.type.animation()
        
        self.layer.sublayers = nil
        animation.setUpAnimationInLayer(self.layer, size: self.nvSize, color: self.color)
    }
}
