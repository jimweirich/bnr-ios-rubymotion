class BNRMapPoint
  def initialize(coord=nil, title="Hometown")
    @coordinate ||= coord || CLLocationCoordinate2DMake(43.07, 89.03)
    @title = title
  end

  def coordinate
    @coordinate
  end

  def setCoordinate(coord)
    @coordinate = coord
  end

  def title
    @title
  end

  def setTitle(title)
    @title = title
  end
end

class WhereWasIViewController < UIViewController
  def initWithNibName(nib_name, bundle:bundle)
    super
    @location_manager = CLLocationManager.alloc.init
    @location_manager.setDelegate(self)
    @location_manager.setDesiredAccuracy(KCLLocationAccuracyBest)
    @update_map_view = true
    self
  end

  def viewDidLoad
    margin = 40

    @world_view = MKMapView.alloc.init.tap do |w|
      width = view.bounds.size.width
      height = view.bounds.size.height - 30
      w.frame = [[0, 0],[width, height]]
      w.delegate = self
      w.showsUserLocation = true
      w.mapType = 0
      view.addSubview(w)
    end

    @location_title_field = UITextField.alloc.init.tap do |w|
      w.frame = [[margin, 30], [view.bounds.size.width - 2*margin, 25]]
      w.textColor = UIColor.blackColor
      w.backgroundColor = UIColor.whiteColor
      w.placeholder = "Enter Location Name"
      w.delegate = self
      view.addSubview(w)
    end

    @activity_indicator = UIActivityIndicatorView.alloc.init.tap do |w|
      w.frame = [[view.bounds.size.width/2-13, 30], [26,26]]
      w.backgroundColor = UIColor.grayColor
      w.hidesWhenStopped = true
      view.addSubview(w)
    end

    @selector = UISegmentedControl.alloc.initWithItems(['Map', 'Satellite', 'Hybrid', 'Topological']).tap do |w|
      width = view.bounds.size.width
      height = 30
      x = 0
      y = view.bounds.size.height - height
      w.frame = [[x, y], [width, height]]
      w.segmentedControlStyle = UISegmentedControlStyleBar
      w.apportionsSegmentWidthsByContent = true
      w.addTarget(self, action:'mapSelect:', forControlEvents:UIControlEventValueChanged)
      view.addSubview(w)
    end
  end

  def mapSelect(selector)
    index = @selector.selectedSegmentIndex
    @world_view.mapType = index
  end

  def mapView(map_view, didUpdateUserLocation:user_location)
    if @update_map_view
      focus_map_on(user_location)
      @update_map_view = false
    end
  end

  def locationManager(location_manager, didUpdateToLocation:to_location, fromLocation:from_location)
    t = to_location.timestamp.timeIntervalSinceNow
    NSLog("Time = %@", t)
    found_location(to_location) if t > -180
  end

  def textFieldShouldReturn(text_field)
    find_location
    text_field.resignFirstResponder
    true
  end

  def find_location
    @location_manager.startUpdatingLocation
    @activity_indicator.startAnimating
    @location_title_field.hidden = true
  end

  def found_location(location)
    @location_manager.stopUpdatingLocation
    mp = BNRMapPoint.new(location.coordinate, @location_title_field.text)
    @world_view.addAnnotation(mp)
    focus_map_on(location)

    @location_title_field.text = ""
    @activity_indicator.stopAnimating
    @location_title_field.hidden = false
  end

  def focus_map_on(location)
    loc = location.coordinate
    @world_view.setRegion(MKCoordinateRegionMakeWithDistance(loc, 250, 250), animated:true)
  end
end

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = WhereWasIViewController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end

def appdel
  UIApplication.sharedApplication.delegate
end

def rvc
  appdel.instance_eval { @window }.rootViewController
end

def fc(pattern, mod=Object, path=[], seen={})
  return if seen[mod]
  seen[mod] = true
  path << mod
  mod.constants(true).each do |c|
    puts "#{path.join('::')}::#{c}" if c =~ pattern
    begin
      v = mod.const_get(c)
      fc(pattern, v, path, seen) if v.is_a?(Module)
    rescue NameError => ex
      # ignore name errors
    end
  end
  path.pop
  nil
end
