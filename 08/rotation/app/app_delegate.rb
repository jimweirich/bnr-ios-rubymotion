module Orientation
  def landscape?(orientation)
    landscape_left?(orientation) || landscape_right?(orientation)
  end

  def portrait?(orientation)
    right_side_up?(orientation) || upside_down?(orientation)
  end

  def landscape_left?(orientation)
    orientation == UIInterfaceOrientationLandscapeLeft
  end

  def landscape_right?(orientation)
    orientation == UIInterfaceOrientationLandscapeRight
  end

  def right_side_up?(orientation)
    orientation == UIInterfaceOrientationPortrait
  end

  def upside_down?(orientation)
    orientation == UIInterfaceOrientationPortraitUpsideDown
  end
end

class HeavyViewController < UIViewController
  include Orientation

  def loadView
    self.view = UIImageView.alloc.init
  end

  def viewDidLoad
    view.image = UIImage.imageNamed("joeeye.jpg")
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    # NOTE: The UIInterfaceOrientationIsLandscape function is actually
    # a macro and not available in Ruby (ATM).
    landscape?(orientation) || right_side_up?(orientation)
  end
end

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    device = UIDevice.currentDevice
    device.beginGeneratingDeviceOrientationNotifications
    nc = NSNotificationCenter.defaultCenter
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

  NAMES = {
    UIDeviceOrientationUnknown => "UNKNOWN",
    UIDeviceOrientationPortrait => "PORTRAIT",
    UIDeviceOrientationPortraitUpsideDown => "UPSIDE DOWN",
    UIDeviceOrientationLandscapeLeft => "LEFT",
    UIDeviceOrientationLandscapeRight => "RIGHT",
    UIDeviceOrientationFaceUp => "FACE UP",
    UIDeviceOrientationFaceDown => "FACE DOWN",
  }

  def orientationChanged(note)
    NSLog("orientationChanged: %d (#{NAMES[note.object.orientation]})", note.object.orientation)
  end
end
