@interface PhoneSettingsNetworksController

-(BOOL)_isInManualMode;
-(BOOL)_isInAutomaticMode;

-(BOOL)_setAutomaticSwitchOn:(BOOL)arg1 animated:(BOOL)arg2 ;
-(BOOL)_autoSwitchTurnedOff;
-(BOOL)_autoSwitchTurnedOn;
@end

%hook PhoneSettingsNetworksController

-(BOOL)viewDidAppear:(BOOL)arg1
{
  %orig;

  if([self _isInAutomaticMode])
  {
    // calling this method shows the network list and internally turns off auto-mode
    [self _autoSwitchTurnedOff];
    // the visual status of the switch doesn't get updated to reflect the change to manual mode
    // this method sets it to ON, visually and changes the value idk where
    [self _setAutomaticSwitchOn: false animated: true];
  }
}

-(void)_autoSwitchTurnedOn
{
  %orig;
  // if the view shows manual mode and user switches to auto, again do what was done in viewDidAppear
  [self _autoSwitchTurnedOff];
  [self _setAutomaticSwitchOn: False animated: True];
}

-(BOOL)listItemSelected:(id)arg1
{
  // the manual mode is SET only when a network is selected from list
  // change the status of the button to off
  [self _setAutomaticSwitchOn:false animated:false];
  %orig;
}
%end

%hook PrefsListController

-(BOOL)_showCarrier
{
  return TRUE;
}

%end


%ctor
{
  dlopen("/System/cellular/PreferenceBundles/CarrierSettings.bundle/CarrierSettings", RTLD_LAZY);
  %init(PrefsListController = objc_getClass((kCFCoreFoundationVersionNumber >= 1240.10) ? "PSUIPrefsListController" : "PrefsListController"));
}


/***

state 1 = manual
state 2 = auto



*/
