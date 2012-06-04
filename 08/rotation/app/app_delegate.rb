class HeavyViewController < UIViewController
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
    nc = NSNotificationCenter.defaultCenter
    NSLog("Adding Observer")
    nc.addObserver(self,
      selector:'orientationChanged:',
      name:UIDeviceOrientationDidChangeNotification,
      object:device)
    @window.backgroundColor = UIColor.whiteColor
    @window.rootViewController = HeavyViewController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    NSLog("APP INIT DONE")
    true
  end

  def orientationChanged(note)
    NSLog("orientationChanged: %d", note.object.orientation)
  end
end
