Config {

   -- appearance
  font =         "xft:Jetbrains Mono NL:size=15:antialias=true"
   , bgColor =      "black"
   , fgColor =      "#D0E1F9"
   , position =     Top
   , border =       BottomB
   , borderColor =  "#2b4b6e"
   , additionalFonts = [ "xft:FontAwesome:pixelsize=13" ]

   -- layout
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , template = "%battery% %multicpu%  %coretemp% | %memory% | %dynnetwork% }{ %RJTT% | %date% || %kbd% "

   -- general behavior
   , lowerOnStart =     True    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)

   -- plugins
   --   Numbers can be automatically colored according to their value. xmobar
   --   decides color based on a three-tier/two-cutoff system, controlled by
   --   command options:
   --     --Low sets the low cutoff
   --     --High sets the high cutoff
   --
   --     --low sets the color below --Low cutoff
   --     --normal sets the color between --Low and --High cutoffs
   --     --High sets the color above --High cutoff
   --
   --   The --template option controls how the plugin is displayed. Text
   --   color can be set by enclosing in <fc></fc> tags. For more details
   --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
   , commands =

        -- weather monitor
        [ Run Weather "RJTT" [ "--template", "<skyCondition> | <fc=#749AF7><tempC></fc>°C | <fc=#749AF7><rh></fc>% | <fc=#749AF7><pressure></fc>hPa"] 36000

        -- network activity monitor (dynamic interface resolution)
        , Run DynNetwork     [ "--template" , "<dev>: <tx>kB/s|<rx>kB/s"
                             , "--Low"      , "1000"       -- units: B/s
                             , "--High"     , "5000"       -- units: B/s
                             , "--low"      , "#B6E63E"
                             , "--normal"   , "#ffa500"
                             , "--high"     , "#E74C3C"
                             ] 10

        -- cpu activity monitor
        , Run MultiCpu       [ "--template" , "Cpu: <total0>% <total1>% <total2>% <total3>%"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#B6E63E"
                             , "--normal"   , "#ffa500"
                             , "--high"     , "#E74C3C"
                             ] 10

        -- cpu core temperature monitor
        , Run CoreTemp       [ "--template" , "Temp: <core0>°C|<core1>°C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "#B6E63E"
                             , "--normal"   , "#ffa500"
                             , "--high"     , "#E74C3C"
                             ] 50

        -- memory usage monitor
        , Run Memory         [ "--template" ,"Mem: <usedratio>%"
                             , "--Low"      , "20"        -- units: %
                             , "--High"     , "90"        -- units: %
                             , "--low"      , "#B6E63E"
                             , "--normal"   , "#ffa500"
                             , "--high"     , "#E74C3C"
                             ] 10

        -- battery monitor
        , Run Battery        [ "--template" , "Batt: <acstatus>"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--low"      , "#E74C3C"
                             , "--normal"   , "#ffa500"
                             , "--high"     , "#B6E63E"

                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#dAA520>Charging</fc>"
                                       -- charged status
                                       , "-i"	, "<fc=#006000>Charged</fc>"
                             ] 50

        -- time and date indicator
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run Date           "<fc=#4CB5F5>%F (%a) %T</fc>" "date" 10

        -- keyboard layout indicator
        , Run Kbd            [ ("ru" , "Ru")
                             , ("us" , "En")
                             ]
        ]
   }