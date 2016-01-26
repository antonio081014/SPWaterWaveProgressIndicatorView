# SPWaterProgressIndicatorView
This is custom subclass of UIView, which indicates the progress of task in percent.

## What it looks like?
![Presentation](https://raw.githubusercontent.com/286s/Custom-View-and-Control/master/SPWaterProgressIndicatorView/3.gif)
## Directory
- **SPWaterProgressIndicatorView_README.md**
- **SPWaterProgressIndicatorView.hm**
- **WaterWaveDemo** project demostrates how to use this class.

## How to user it?
- Add SPWaterProgressIndicatorView.hm files to the project.
- There are two ways to use this class:
  - Specify a `UIView`'s class as SPWaterProgressIndicatorView in IB.
  - Using `alloc` | `initWithFrame:` to create and initialize an instance, then add it to a `UIView`.

```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.waterView = [[SPWaterProgressIndicatorView alloc] initWithFrame:self.view.bounds];
    self.waterView.center = self.view.center;
    [self.view addSubview:self.waterView];
    
}
```

## Version
1.0

## Reference & Thanks
- [Stefan Ceriu's SCSiriWaveformView on Github](https://github.com/stefanceriu/SCSiriWaveformView)
