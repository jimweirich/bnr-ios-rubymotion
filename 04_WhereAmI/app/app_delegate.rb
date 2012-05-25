class WhereamiViewController < UIViewController
  def initWithNibName(nib_name, bundle:bundle)
    result = super
    if result
      @location_manager = CLLocationManager.alloc.init
      @location_manager.setDelegate(self)
      @location_manager.setDesiredAccuracy(KCLLocationAccuracyBest)
      @location_manager.distanceFilter = 10
      @location_manager.startUpdatingLocation
      @location_manager.startUpdatingHeading
      NSLog("DBG: LocationManager: %@", @location_manager)
      NSLog("DBG: Heading Available: %@", @location_manager.headingAvailable)
    end
    result
  end

  def viewDidLoad
    margin = 20
    @text = UITextView.new
    @text.frame = [[margin, 50], [view.frame.size.width - margin * 2, 250]]
    @text.textColor = UIColor.whiteColor
    @text.backgroundColor = UIColor.clearColor
    @text.editable = false
    @text.showsHorizontalScrollIndicator = false
    @text.font = UIFont.boldSystemFontOfSize(24)
    @text.text = "(empty)"
    view.addSubview(@text)

    @heading = UITextView.new
    @heading.frame = [[margin, 250], [view.frame.size.width - margin * 2, 100]]
    @heading.textColor = UIColor.whiteColor
    @heading.backgroundColor = UIColor.clearColor
    @heading.editable = false
    @heading.showsHorizontalScrollIndicator = false
    @heading.font = UIFont.boldSystemFontOfSize(18)
    @heading.text = "Heading Available: #{@location_manager.headingAvailable}"
    view.addSubview(@heading)
end

  def locationManager(location_manager, didUpdateToLocation:to_location, fromLocation:from_location)
    @text.text = "AT: #{to_location.description}"
    NSLog("%@", to_location)
  end

  def locationManager(location_manager, didUpdateHeading:new_heading)
    @heading.text = "AT: #{new_heading.description}"
    NSLog("%@", new_heading)
  end

  def locationManager(location_manager, didFailWithError:error)
    @text.text = "ERROR: #{error.description}"
    NSLog("Could not find location: %@", error)
  end
end

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = WhereamiViewController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
