import XMonad
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CopyWindow
import qualified XMonad.StackSet as W

main = xmonad $ ewmh defaultConfig
         {
           modMask = mod4Mask
         , layoutHook = smartBorders (layoutHook defaultConfig)
         , manageHook = manageHook defaultConfig
                        <+> (className =? "xwrits" --> doFloat)
                        <+> ((className =? "wish") <&&> (title =? "Mood Interrogator") --> doFloat) }
         , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
         } `additionalKeysP` myKeys

myKeys = [
       -- ("<Print>", spawn "/home/julian/bin/tp-toggle")
       --   -- , ("<XF86WWW", spawn "")
       --   , ("<XF86AudioPlay>", spawn "deadbeef --toggle-pause")
       --   , ("<XF86AudioPrev>", spawn "deadbeef --prev")
       --   , ("<XF86AudioNext>", spawn "deadbeef --next")
       --   , ("<XF86AudioStop>", spawn "deadbeef --stop")
       --   , ("<XF86AudioLowerVolume>" , spawn "amixer -q set Headphone 2-")
       --   , ("<XF86AudioMute>"        , spawn "/home/julian/bin/mute-toggle")
       --   , ("<XF86AudioRaiseVolume>" , spawn "amixer -q set Headphone 2+")
       --   , ("<XF86MonBrightnessUp>", spawn "/home/julian/bin/bright +4")
       --   , ("<XF86MonBrightnessDown>", spawn "/home/julian/bin/bright -4")
         ]

