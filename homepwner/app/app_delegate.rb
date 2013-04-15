class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = ItemsViewController.alloc.init
    @window.backgroundColor = UIColor.whiteColor
    @window.rootViewController.wantsFullScreenLayout = true
#    @window.rootViewController.data_source = recipes
    @window.makeKeyAndVisible
    true
  end
end
