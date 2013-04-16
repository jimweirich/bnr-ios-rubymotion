class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    items_view_controller = ItemsViewController.alloc.init
    nav_controller = UINavigationController.alloc.
      initWithRootViewController(items_view_controller)
    @window.rootViewController = nav_controller
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
