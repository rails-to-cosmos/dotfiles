import XMonad
import XMonad.Actions.GroupNavigation
import XMonad.Config.Xfce
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab

main :: IO()
main = xmonad . ewmh =<< xmobar myConfig

myLayout = Full ||| ThreeColMid nmaster delta ratio -- ||| tiled ||| Mirror tiled ||| threeCol
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 10/100  -- Percent of screen to increment by when resizing panes

myConfig = def
  { modMask = mod4Mask
  , layoutHook = myLayout
  , borderWidth = 0
  }

  `additionalKeysP`
  [ ("M1-C-<Space>", spawn "rofi -show")
  , ("M1-<Tab>", nextMatch Forward isOnAnyVisibleWS)
  , ("M1-S-<Tab>", nextMatch Backward isOnAnyVisibleWS)
  , ("M1-<Space>", spawn "switch-layout")
  ]
