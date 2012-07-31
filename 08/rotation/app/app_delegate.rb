class HeavyViewController < UIViewController
  def loadView
    self.view = UIImageView.alloc.init
  end

  def viewDidLoad
    view.image = UIImage.imageNamed("joeeye.jpg")
  end

  def shouldAutorotateToInterfaceOrientation(x)
    # NOTE: The UIInterfaceOrientationIsLandscape function is actually
    # a macro and not available in Ruby (ATM).
    x == UIInterfaceOrientationPortrait ||
      x == UIInterfaceOrientationLandscapeLeft ||
      x == UIInterfaceOrientationLandscapeRight
  end
end

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    device = UIDevice.currentDevice
    device.beginGeneratingDeviceOrientationNotifications
    nc = NSNotificationCenter.defaultCenter
    NSLog("Adding Observer")
    nc.addObserver(self,
      selector: 'orientationChanged:',
      name: UIDeviceOrientationDidChangeNotification,
      object: device)
    @window.backgroundColor = UIColor.whiteColor
    @window.rootViewController = HeavyViewController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

  def orientationChanged(note)
    NSLog("orientationChanged: %d", note.object.orientation)
  end
end
