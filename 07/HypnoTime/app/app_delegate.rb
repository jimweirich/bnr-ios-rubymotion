class HypnosisView < UIView
  def initWithFrame(frame)
    super(frame)
    self.backgroundColor = UIColor.clearColor
    @color_index = 0
    @colors = [
      UIColor.lightGrayColor,
      UIColor.redColor,
      UIColor.blueColor,
      UIColor.greenColor,
    ]
    self
  end

  def drawRect(dirty_rect)
    ctx = UIGraphicsGetCurrentContext()

    box = Box.new(bounds)
    center = box.center
    max_radius = box.diagonal / 4.0

    CGContextSetLineWidth(ctx, 10)
    @colors[@color_index].setStroke

    r = max_radius
    while r > 0.0
      CGContextAddArc(ctx, center.x, center.y, r, 0.0, 2*Math::PI, 0)
      CGContextStrokePath(ctx)
      r -= 20
    end

    text = "You are getting sleepy"
    font = UIFont.boldSystemFontOfSize(28)
    text_rect = CGRect.new
    text_rect.size = text.sizeWithFont(font)
    text_rect.origin.x = center.x - text_rect.size.width / 2.0
    text_rect.origin.y = center.y - text_rect.size.height / 2.0
    UIColor.blackColor.setFill

    offset = CGSizeMake(4,3)
    color = UIColor.darkGrayColor.CGColor
    save_graphics_context(ctx) do
      CGContextSetShadowWithColor(ctx, offset, 2.0, color)
      text.drawInRect(text_rect, withFont:font)
    end

    delta = [box.height, box.width].min / 15.0
    UIColor.greenColor.setStroke
    CGContextSetLineWidth(ctx, 3)
    CGContextMoveToPoint(ctx, center.x, center.y-delta)
    CGContextAddLineToPoint(ctx, center.x, center.y+delta)
    CGContextMoveToPoint(ctx, center.x-delta, center.y)
    CGContextAddLineToPoint(ctx, center.x+delta, center.y)
    CGContextStrokePath(ctx)
  end

  def bump_color
    @color_index = (@color_index + 1) % @colors.size
    setNeedsDisplay
  end

  def canBecomeFirstResponder
    true
  end

  def save_graphics_context(ctx)
    CGContextSaveGState(ctx)
    yield
  ensure
    CGContextRestoreGState(ctx)
  end

  def motionBegan(motion, withEvent:event)
    if motion == UIEventSubtypeMotionShake
      NSLog("Device started shaking")
      bump_color
    end
  end
end

class HypnosisViewController < UIViewController
  def initWithNibName(nib_name, bundle:bundle)
    super
    tbi = tabBarItem
    tbi.title = "Hypnosis"
    tbi.image = UIImage.imageNamed("Hypno.png")
    self
  end

  def loadView
    NSLog("HypnosisViewController loaded its view")
    self.view = HypnosisView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def viewDidUnload
    super
    NSLog("Unloading Hypno View")
  end
end

class TimeViewController < UIViewController
  def initWithNibName(nib_name, bundle:bundle)
    super
    tbi = tabBarItem
    tbi.title = "Time"
    tbi.image = UIImage.imageNamed("Time.png")
    self
  end

  def viewDidLoad
    NSLog("TimeViewController loaded its view")
    @label = UILabel.new
    @label.font = UIFont.systemFontOfSize(20)
    @label.text = '??:??'
    @label.textAlignment = UITextAlignmentCenter
    @label.frame = centered_frame(200, 30, 20)
    view.addSubview(@label)

    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.frame = centered_frame(150, 30, 60)
    button.setTitle("What time is it?", forState:UIControlStateNormal)
    button.addTarget(self, action:'showCurrentTime', forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(button)
  end

  def viewDidUnload
    super
    NSLog("Unloading Time View")
    @label = nil
  end

  def showCurrentTime
    @label.text = Time.now.strftime("%H:%M:%S")
  end

  def centered_frame(width, height, y)
    box = Box.new(view.bounds)
    [[box.center.x - width/2.0, y], [width, height]]
  end
end

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    tab_bar_controller = UITabBarController.alloc.init
    tab_bar_controller.viewControllers = [
      HypnosisViewController.alloc.init,
      TimeViewController.alloc.init
    ]
    @window.rootViewController = tab_bar_controller

    @window.backgroundColor = UIColor.whiteColor
    @window.makeKeyAndVisible
    true
  end
end
