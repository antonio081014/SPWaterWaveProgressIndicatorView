# SPWaterProgressIndicatorView
This is custom subclass of UIView, which indicates the progress of task in percent.

## What it looks like?
![Presentation](https://raw.githubusercontent.com/antonio081014/SPWaterWaveProgressIndicatorView/master/3.gif)
## Directory
- **SPWaterProgressIndicatorView_README.md**
- **SPWaterProgressIndicatorView.hm**
- **SPWaterProgressIndicatorView.swift**
- **WaterWaveDemo** project demostrates how to use this class in Objective-C Project.
- **WaterWaveDemo_Swift** project demostrates how to use this class in Swift Project.

## How to use it?
- Add SPWaterProgressIndicatorView.hm files to the project.
- There are two ways to use this class:
  - Specify a `UIView`'s class as SPWaterProgressIndicatorView in IB.
  - Using `alloc` | `initWithFrame:` (Objective-C) to create and initialize an instance, then add it to a `UIView`.
  - Using `UIView` | `init(frame: CGRect)` (Swift) to create and initialize an instance, then add it to a `UIView`.

__Important to Know__
> 1. Init with `init(frame: CGRect)`
> 2. No matter what CGRect being passed to initialize it, the view will be trunked to be a square.

__Objective-C__
```
// Initialization.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.waterView = [[SPWaterProgressIndicatorView alloc] initWithFrame:self.view.bounds];
    self.waterView.center = self.view.center;
    [self.view addSubview:self.waterView];
    
}

// Update percent
[self.waterView updateWithPercentCompletion:percent];
```
> [Detailed Example in Objc.](https://github.com/antonio081014/SPWaterWaveProgressIndicatorView/blob/master/WaterWaveDemo/WaterWaveDemo/ViewController.m)

__Swift__
```
// Initialization
override func viewDidLoad() {
    super.viewDidLoad()
        
    self.wave = SPWaterProgressIndicatorView(frame: self.view.bounds)
    self.wave.center = self.view.center;
    self.view.addSubview(self.wave)        
}

// Update percent
self.wave.completionInPercent = percent
```
> [Detailed Example in Swift.](https://github.com/antonio081014/SPWaterWaveProgressIndicatorView/blob/master/WaterWaveDemo_Swift/WaterWaveDemo_Swift/ViewController.swift)

## Version
1.0

## Reference & Thanks
- [Stefan Ceriu's SCSiriWaveformView on Github](https://github.com/stefanceriu/SCSiriWaveformView)
