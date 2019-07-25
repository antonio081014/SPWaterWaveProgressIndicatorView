//
//  SPWaterProgressIndicatorView.swift
//
//  Created by Antonio081014 on 9/18/16.
//  Copyright © 2016 Antonio081014.com. All rights reserved.
//

import UIKit

class SPWaterProgressIndicatorView: UIView {
    
    var fontSize: CGFloat {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var waveColor: UIColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var completionInPercent: Int {
        didSet {
            if completionInPercent > 100 {
                completionInPercent = 100
            } else if completionInPercent < 0 {
                completionInPercent = 0
            }
            self.textLayer.string = String(format: "%zd %%", self.completionInPercent)
            self.setNeedsDisplay()
        }
    }
    
    
    func startAnimation() {
        self.displaylink = CADisplayLink(target: self, selector: #selector(SPWaterProgressIndicatorView.updateMeters))
        self.displaylink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    func stopAnimation() {
        self.displaylink?.remove(from: RunLoop.current, forMode: RunLoop.Mode.common)
        self.displaylink?.invalidate()
        self.displaylink = nil
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    /// Designate Initializer
    override init(frame: CGRect) {
        self.waveColor = UIColor.cyan
        
        self.completionInPercent = kDefaultPercent
        
        self.frequency = kDefaultFrequency
        
        self.amplitude = kDefaultAmplitude
        self.idleAmplitude = kDefaultIdleAmplitude
        
        self.phaseShift = kDefaultPhaseShift
        self.density = kDefaultDensity
        
        self.primaryWaveLineWidth = kDefaultPrimaryLineWidth
        self.fontSize = kDefaultFontSize
        self.phase = 0
        self.displaylink = CADisplayLink.init()
        
        super.init(frame: frame)
        
        let progressPath = UIBezierPath(ovalIn: self.bounds)
        let layer = CAShapeLayer.init()
        layer.path = progressPath.cgPath
        layer.lineWidth = min(self.bounds.height, self.bounds.width) / 10.0
        self.layer.mask = layer
        
        self.layer.addSublayer(self.textLayer)
        
        self.backgroundColor = UIColor.clear
        
        self.startAnimation()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * Ensure the size is always square.
     */
    override var frame: CGRect {
        didSet {
            if frame.width != frame.height {
                let side = min(frame.width, frame.height)
                frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: side, height: side)
            }
        }
    }
    
    let kDefaultFrequency: CGFloat = 1.5
    let kDefaultAmplitude: CGFloat = 1.0
    let kDefaultIdleAmplitude: CGFloat = 0.01
    let kDefaultPhaseShift: CGFloat = -0.15
    let kDefaultDensity: CGFloat = 5.0
    let kDefaultPercent: Int = 0
    let kDefaultMaximumPercent: Int = 100
    let kDefaultPrimaryLineWidth: CGFloat = 3.0
    let kDefaultFontSize: CGFloat = 20.0
    let kDefaultMinimumFontSize: CGFloat = 12.0
    
    /**
     * Line width used for the proeminent wave
     *
     * Default: 3.0f
     */
    fileprivate var primaryWaveLineWidth: CGFloat
    
    /**
     * The amplitude that is used when the incoming amplitude is near zero.
     * Setting a value greater 0 provides a more vivid visualization.
     *
     * Default: 0.01
     */
    fileprivate var idleAmplitude: CGFloat
    
    /**
     * The frequency of the sinus wave. The higher the value, the more sinus wave peaks you will have.
     *
     * Default: 1.5
     */
    fileprivate var frequency: CGFloat
    
    /**
     * The current amplitude
     */
    fileprivate var amplitude: CGFloat
    
    /**
     * The lines are joined stepwise, the more dense you draw, the more CPU power is used.
     *
     * Default: 5
     */
    fileprivate var density: CGFloat
    
    /**
     * The phase shift that will be applied with each level setting
     * Change this to modify the animation speed or direction
     *
     * Default: -0.15
     */
    fileprivate var phaseShift: CGFloat
    fileprivate var phase: CGFloat
    
    fileprivate var displaylink: CADisplayLink?
    fileprivate lazy var textLayer: CATextLayer = {
        let textlayer = CATextLayer.init()
        textlayer.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: min(self.bounds.height, 40.0))
        textlayer.position = self.center
        textlayer.alignmentMode = CATextLayerAlignmentMode.center
        textlayer.string = String.init(format: "%zd %%", self.completionInPercent)
        textlayer.fontSize = CGFloat(self.fontSize)
        textlayer.foregroundColor = UIColor.gray.cgColor
        return textlayer
    }()
    
    @objc func updateMeters() {
        self.update()
    }
    
    /**
     * With phase shifts, the animation will prevail.
     */
    fileprivate func update() {
        self.phase += self.phaseShift
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // Get current Context.
        let context = UIGraphicsGetCurrentContext()
        
        // Clear everything in the bounds drawed in the last phase,
        // otherwise, drawing will overlap on each other.
        context?.clear(self.bounds)
        
        self.backgroundColor?.set()
        
        context?.fill(rect)
        context?.setLineWidth(CGFloat(self.primaryWaveLineWidth))
        
        let halfHeight = self.bounds.height / 2.0
        let width: CGFloat = self.bounds.width
        let mid = width / 2.0
        
        let maxAmplitude = max(halfHeight / 10 - 4.0, CGFloat(2.0 * self.primaryWaveLineWidth)) // 4 corresponds to twice the stroke width
        
        self.waveColor.withAlphaComponent(self.waveColor.cgColor.alpha).set()
        
        var x = CGFloat(0)
        while  x < (width + self.density) {
            // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
            let scaling = -pow(1 / mid * (x - mid), 2) + 1
            
            let y = scaling * maxAmplitude * self.amplitude * sin(CGFloat(2.0 * CGFloat.pi) * (x / width) * self.frequency + self.phase) + self.bounds.height * CGFloat(100 - self.completionInPercent) / CGFloat(100)
            
            if (x == 0) {
                context?.move(to: CGPoint.init(x: x, y: y))
            } else {
                context?.addLine(to: CGPoint.init(x: x, y: y))
            }
            
            x += self.density
        }
        context?.addLine(to: CGPoint.init(x: width, y: self.bounds.height))
        context?.addLine(to: CGPoint.init(x: CGFloat(0), y: self.bounds.height))
        context?.closePath()
        context?.fillPath()
        context?.strokePath()
    }
    
    
    /**
     * Ensure nothing would happen when user touch out of the mask(circle)
     */
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let layer = self.layer.mask as? CAShapeLayer {
            if UIBezierPath.init(cgPath: layer.path!).contains(point) {
                return super.hitTest(point, with: event)
            }
            return nil
        }
        return nil
    }
}
