-- DO NOT EDIT THIS FILE DIRECTLY
-- This is a file generated from a literate programing source file located at
-- https://github.com/binjo/dot-hammerspoon/blob/master/init.org
-- based on zzamboni's config, located at
-- https://github.com/zzamboni/dot-hammerspoon/blob/master/init.org
-- You should make any changes there and regenerate it from Emacs org-mode using C-c C-v t

hs.logger.defaultLogLevel = "info"

hyper = {"cmd","alt","ctrl","shift"}
shift_hyper = {"cmd","alt","ctrl"}

col = hs.drawing.color.x11

function filter(func, tbl)
   local newtbl= {}
   for k,v in pairs(tbl) do
      if func(v) then
         table.insert(newtbl, v)
      end
   end
   return newtbl
end

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.use_syncinstall = true

Install=spoon.SpoonInstall

Install:andUse("WindowHalfsAndThirds",
               {
                 config = {
                   use_frame_correctness = true
                 },
                 hotkeys = 'default'
               }
)

Install:andUse("TextClipboardHistory",
               {
                 -- disable = false,
                 config = {
                   show_in_menubar = false,
                 },
                 hotkeys = {
                   toggle_clipboard = { hyper, "h" } },
                 start = true,
               }
)

Install:andUse("Seal",
               {
                 hotkeys = { show = { hyper, "j" } },
                 fn = function(s)
                   s:loadPlugins({"apps", "calc", "safari_bookmarks", "screencapture", "useractions"})
                   s.plugins.safari_bookmarks.always_open_with_safari = false
                   s.plugins.useractions.actions =
                     {
                           ["Hammerspoon docs webpage"] = {
                             url = "https://hammerspoon.org/docs/",
                             icon = hs.image.imageFromName(hs.image.systemImageNames.ApplicationIcon),
                           },
                     }
                   s:refreshAllCommands()
                 end,
                 start = true,
               }
)

-- usbWatcher = nil
--
-- function usbDeviceCallback(data)
--     if (data["productName"] == "HHKB Professional") then
--         if (data["eventType"] == "added") then
--             hs.notify.new({title="Hammerspoon", informativeText="Hello HHKB"}):send()
--             ok,result = hs.execute("/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --select-profile \"HHKB\"")
--         elseif (data["eventType"] == "removed") then
--             hs.notify.new({title="Hammerspoon", informativeText="Bye HHKB"}):send()
--             ok,result = hs.execute("/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --select-profile \"Default\"")
--             -- app:kill()
--         end
--     end
-- end
--
-- usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
-- usbWatcher:start()

-- auto change the im for the application callback
apps = {
   {
      name = 'Emacs',
      im = 'EN'
   },
   {
      name = 'Google Chrome',
      im = 'EN'
   },
   {
      name = 'VMware',
      im = 'EN'
   },
   {
      name = 'iTerm',
      im = 'EN'
   },
   {
      name = 'Microsoft',
      im = 'EN'
   },
   {
      name = 'WeChat',
      im = 'CN'
   },
   {
      name = 'WeCom',
      im = 'CN'
   },
}

function ims(name, etype, app)
   if (etype == hs.application.watcher.activated) then
      config = filter(
         function(item)
            return string.match(name:lower(), item.name:lower())
         end,
         apps)

      if next(config) == nil then
         hs.keycodes.setLayout("ABC")
      else
         local current = hs.keycodes.currentMethod()
         if (current == nil and string.find (config [1].im, "CN")) then
            hs.keycodes.setMethod("Squirrel")
         elseif (current ~= nil and string.find (config [1].im, "EN")) then
            hs.keycodes.setLayout("ABC")
         end
      end
   end
end

-- auto change the im for the application
imWatcher = hs.application.watcher.new(ims)
imWatcher:start()

local localfile = hs.configdir .. "/init-local.lua"
if hs.fs.attributes(localfile) then
  dofile(localfile)
end

function moveToNextScreen()
  local app = hs.window.focusedWindow()
  app:moveToScreen(app:screen():next())
end
hs.hotkey.bind(hyper, "n", moveToNextScreen)

function getChromeURL()
   local res, url = hs.osascript.applescript('tell application "Google Chrome" to get URL of active tab of front window')
   if res then
      hs.pasteboard.writeObjects(url)
      hs.notify.show("Chrome URL scraped", url, "")
   else
      hs.notify.show("Failed to scrape URL", "Oooops", "")
   end
end
hs.hotkey.bind(hyper, "l", getChromeURL)

hs.urlevent.bind("codebrowser", function()
    local cb = hs.window'codebrowser'
    if cb then
       cb:focus()
    else
       cb = hs.window'ghidra'
       if cb then
          cb:focus()
       end
    end
end)

-- Install:andUse("FadeLogo",
--                {
--                  config = {
--                    default_run = 1.0,
--                  },
--                  start = true
--                }
-- )

hs.notify.show("Welcome to Hammerspoon", "Have fun!", "")
