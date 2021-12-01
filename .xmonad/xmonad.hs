-- XMONAD CONFIG

-- 1.0 IMPORTS

--   1.1 Base XMonad
import XMonad
import System.Exit

import qualified Data.Map as Map
import qualified XMonad.StackSet as W

--   1.2 Keys
import Graphics.X11.ExtraTypes.XF86 -- XF86 Keys

--   1.3 Layouts
import XMonad.Layout.BinarySpacePartition -- BSP Layout
import XMonad.Layout.Spacing -- Gaps
import XMonad.Layout.NoBorders -- Disable/Manage Borders

--   1.4 Actions
import XMonad.Actions.Navigation2D -- Keyboard Navigation
import XMonad.Actions.SpawnOn -- Spawn on Workspace

--   1.5 Hooks
import XMonad.Hooks.ManageDocks		-- Self-Explanatory
import XMonad.Hooks.DynamicLog		-- Call logHook every State Update
import XMonad.Hooks.EwmhDesktops	-- EWMH Hints (Needed by Glava)
import XMonad.Hooks.ManageHelpers -- Helper Functions (e.g. doCenterFloat)

--   1.6 Utils
import XMonad.Util.Run -- Proc?

-----------------------------------------------------------

-- 2.0 DEFAULTS

--   2.1 Applications
myTerminal 		= "alacritty"
myBrowser 		= "firefox"
myFM 					= "thunar"
myLauncher		= "/home/edoardo/.config/rofi/theme/launcher"
myDmenu 			= "dmenu_run"
myScreenshot	= "flameshot gui"
myMusic 			= "spotify"

--   2.2 Layouts
myBorderWidth = 0
myNormalBorderColor = "#2e3440"
myFocusedBorderColor = "#d8dee9"

myLayout = binarySpace ||| fullSc
				where
				  binarySpace = avoidStruts $ spacingRaw True (Border 0 18 0 18) True (Border 18 0 18 0) True $ emptyBSP
				  fullSc = noBorders Full

--   2.3 Workspaces
-- myWorkspaces = ["1:Web","2:Cod","3:Sys","4:Prd","5:Ent","6:Mus","7:Gme","8:Soc", "9:Ext"]
xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x    = [x]
myWorkspaces            :: [String]
myWorkspaces            = clickable . (map xmobarEscape) $ ["1:Web","2:Cod","3:Sys","4:Prd","5:Ent","6:Mus","7:Gme","8:Soc","9:Ext"]
                                                                              
  where                                                                       
         clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                             (i,ws) <- zip [1..9] l,                                        
                            let n = i ]

--   2.4 Behaviors
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-----------------------------------------------------------

-- 3.0 KEYS

--   3.1 Default Keys
myModMask = mod4Mask

--   3.2 Key Bindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = Map.fromList $
				
				-- General
				[ ((modm,	xK_Return), spawn myTerminal) 														-- Terminal
				, ((modm, xK_b), spawn myBrowser) 																	-- Browser
				, ((modm, xK_d), spawn myDmenu) 																		-- DMenu
				, ((modm, xK_e), spawn myFM) 																				-- File Manager
				, ((modm, xK_space), spawn myLauncher) 															-- App Launcher
				, ((0, xK_Print), spawn myScreenshot) 															-- Screenshot
				, ((modm, xK_p), spawnOn ( myWorkspaces !! 5 ) myMusic)							-- Music 		

				, ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess)) 					-- Quit XMonad
				, ((modm, xK_Escape), spawn "xmonad --recompile; xmonad --restart")	-- Restart XMonad
				]

				++ -- Window Management
				[ ((modm, xK_l), sendMessage $ ExpandTowards R)											-- Expand Right
				, ((modm, xK_h), sendMessage $ ExpandTowards L)											-- Expand Left
				, ((modm, xK_j), sendMessage $ ExpandTowards D)											-- Expand Down
				, ((modm, xK_k), sendMessage $ ExpandTowards U)											-- Expand Up
				, ((modm, xK_r), sendMessage Rotate)																-- Rotate Windows
				, ((modm, xK_q), kill ) 																						-- Close Focused Window
				, ((modm, xK_t), withFocused $ windows . W.sink) 										-- Tile Window
				, ((modm, xK_Tab), sendMessage NextLayout)													-- Change Layout
				]
				
				++ -- Navigation
				[	((modm, xK_Right), windowGo R False) 															-- Focus Right
				, ((modm, xK_Left), windowGo L False) 															-- Focus Left
				, ((modm, xK_Up), windowGo U False) 																-- Focus Up
				, ((modm, xK_Down), windowGo D False) 															-- Focus Down

				, ((modm .|. shiftMask, xK_Right), windowSwap R False) 							-- Swap Right
				, ((modm .|. shiftMask, xK_Left), windowSwap L False) 							-- Swap Left
				, ((modm .|. shiftMask, xK_Up), windowSwap U False) 								-- Swap Up
				, ((modm .|. shiftMask, xK_Down), windowSwap D False) 							-- Swap Down
				]
				
				++ --XF86
				[ ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume alsa_output.pci-0000_0c_00.4.analog-stereo +5%")	-- Volume Up
				, ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume alsa_output.pci-0000_0c_00.4.analog-stereo -5%")	-- Volume Down
				--[ ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 5%+ unmute")	-- Volume Up
				--, ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 5%- unmute")	-- Volume Down
				, ((0, xF86XK_AudioMute), spawn "amixer set Master toggle")							-- Mute
				, ((0, xF86XK_AudioPlay), spawn "playerctl play-pause")									-- Play
				, ((0, xF86XK_AudioPrev), spawn "playerctl previous")										-- Previous
				, ((0, xF86XK_AudioNext), spawn "playerctl next")												-- Next
				, ((0, xF86XK_MonBrightnessUp), spawn "~/Scripts/brightness.sh up") 		-- Brightness Up
				, ((0, xF86XK_MonBrightnessDown), spawn "~/Scripts/brightness.sh down") -- Brightness Down
				]

				++ -- Workspace
				[ ((m .|. modm, k), windows $ f i)
				| (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
				, (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
				]

-----------------------------------------------------------

-- 4.0 HOOKS

--   4.1 Startup
myStartupHook :: X ()
myStartupHook = spawn "/home/edoardo/Scripts/startup.sh"

--   4.2 Handle Event
myEventHook = handleEventHook def

--   4.3 Manage Hook
myManageHook = (composeAll . concat $
				[ [className	=? c --> doCenterFloat | c <- myCenterFloats]
				, [className	=? c --> hasBorder False | c <- myBorderless]
				, [className	=? c --> doShift ( myWorkspaces !! 2 ) | c <- mySys]
				, [className	=? c --> doShift ( myWorkspaces !! 7 ) | c <- mySocial]
				]) 
				where
				  myCenterFloats = ["Pavucontrol", "GLava", "Qalculate-gtk"]
				  myBorderless = ["GLava"]
				  mySys = ["Pavucontrol"]
				  mySocial = ["Ferdi"]

--   4.4 Log
myLogHook :: X ()
myLogHook = return () 


-----------------------------------------------------------

-- 5.0 MAIN

--   5.1 Func
main = do
				xmproc <- spawnPipe "/usr/bin/xmobar -x 0 ~/.config/xmobar/xmobarrc"
				
				xmonad $ withNavigation2DConfig def $ ewmh $ docks $ myConfig xmproc

--   5.2 Config
myConfig xmproc = def 
				{ terminal						= myTerminal
				, borderWidth					= myBorderWidth
				, normalBorderColor 	= myNormalBorderColor
				, focusedBorderColor	= myFocusedBorderColor
				, layoutHook					=	myLayout
				, workspaces					=	myWorkspaces
				, focusFollowsMouse		=	myFocusFollowsMouse
				--
				, modMask							= myModMask
				, keys								=	myKeys
				--
				, startupHook					=	myStartupHook
				, handleEventHook			= myEventHook
				, manageHook					= manageDocks <+> manageSpawn <+> myManageHook
				, logHook							=	myLogHook <+> dynamicLogWithPP xmobarPP
								{ ppOutput = \x -> hPutStrLn xmproc x
								, ppCurrent = xmobarColor "#bf616a" "" . wrap "{" "}"
								, ppVisible = xmobarColor "#ebcb8b" "" . wrap "(" ")"
								, ppHidden = xmobarColor "#5e81ac" ""
								, ppHiddenNoWindows = xmobarColor "#4c566a" ""
								, ppTitle = xmobarColor "#d08770" "" . shorten 25
								, ppOrder = \(ws:_:t:_) -> [ws,t]
								}
				}

-- ## -- ## -- ## -- ## --  END  -- ## -- ## -- ## -- ## --
