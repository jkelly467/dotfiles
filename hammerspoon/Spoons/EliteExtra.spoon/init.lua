--- === EliteExtra ===
---
--- Adds a chooser to query for and interact with Extra sites. Relies on a backing server to cache and serve the data.


local obj = {}
obj.__index = obj

-- Metadata
obj.name = "EliteExtra"
obj.version = "1.0"
obj.author = "Jon Kelly <jkelly@adc4gis.com>"
obj.homepage = "https://bitbucket.org/applieddataconsultants/extra-viz-helper"

--- EliteExtra.server_url
--- Variable
--- The URL of the backing server. Defaults to 'http://localhost:9908'
obj.server_url = "http://localhost:9908"

--- EliteExtra.server_home
--- Variable
--- The home directory of the backing server. Must be set for this spoon to manage your server, otherwise you will be in charge of making sure the server is running.
obj.server_home = nil

--- EliteExtra.gradle_home
--- Variable
--- The home directory of the gradle executable. Defaults to '$HOME/.sdkman/candidates/gradle/current/bin/gradle'
obj.gradle_home = os.getenv("HOME").."/.sdkman/candidates/gradle/current/bin/gradle"

--- EliteExtra.use_dbeaver
--- Variable
--- If this is true, query windows will be opened in DBeaver. Otherwise, PGAdmin3 will be used.
obj.use_dbeaver = false

--- EliteExtra.use_named_connections
--- Variable
--- If this is true and "use_dbeaver" is true, query windows will use named connections generated as "dbeaver-data-sources-dbs.xml" by the connection generator script. By default, temp connections will be used.
obj.use_named_connections = false

local chsr
local lastQ
local logger = hs.logger.new("ee", "debug")
local serverStarting = false

-- helper function to query the server for a list of choices
local generateChoices = function(q)
    local c = {}

    local _, body = hs.http.get(obj.server_url.."/check/"..q, nil)

    if body ~= nil and string.len(body) > 0 then
      body = hs.json.decode(body)
      for k,v in pairs(body) do
          c[k] = {
              ["text"] = v.name,
              ["subText"] = v.info.." [ctrl->open site, shift->couch doc]"
          }
      end
    end 

    return c
end

-- select callback to handle actions when a choice is selected
local selectFunc = function(info) 
  if info ~= nil then
    local keyMods = hs.eventtap.checkKeyboardModifiers()
    local _, body = hs.http.get(obj.server_url.."/stats/"..info.text, nil)
    body = hs.json.decode(body)

    if keyMods.ctrl then
      hs.urlevent.openURL(body.url) 
    elseif keyMods.shift then
      hs.urlevent.openURL("http://couchdb.adc.int:5984/_utils/document.html?extra_setup/"..body.name)
    elseif obj.use_dbeaver then
      local cmdString
      if obj.use_named_connections then
        cmdString = "open -a DBeaver.app -n --args  -con 'name="..body.name.."|folder=DBs/"..body.db.."|driver=PostgreSQL|host="..body.db.."|server="..body.db.."|database="..body.name.."|user=postgres|password=postgres|savePassword=true|openConsole=true' -nosplash"
      else
        cmdString = "open -a DBeaver.app -n --args  -con 'name="..body.name.."|folder=Temp/"..body.db.."|driver=PostgreSQL|host="..body.db.."|server="..body.db.."|database="..body.name.."|user=postgres|password=postgres|savePassword=true|openConsole=true' -nosplash"
      end
      hs.execute(cmdString)
    else
      hs.execute("open -a pgAdmin3.app -n --args -qc 'hostaddr="..body.db.." dbname="..body.name.." user=postgres'")
    end
  end
end

-- query change callback to query the server when term length >= 2
local onQueryChange = function(q)
    if q ~= lastQ then
      lastQ = q
      if q ~= nil and string.len(q) > 1 then
          chsr:choices(generateChoices(q))
      else
          chsr:choices(nil)
      end
    end
end

-- Server run task will hit this hammerspoon URL to wait for the server to start and open the chooser
hs.urlevent.bind("EEServer", function(name, params)
  local rc = hs.http.get(obj.server_url.."/up", nil)
  while rc < 200 do
    os.execute('sleep 0.3')
    rc = hs.http.get(obj.server_url.."/up", nil)
  end
  chsr:show()
end)

-- show callback function, to manage the server if "server_home" is set
local onShow = function()
  local rc = hs.http.get(obj.server_url.."/up", nil)

  -- server is down
  if rc < 200 then 
    chsr:choices(nil)

    --notify that server is starting up
    hs.notify.show(
      'Hammerspoon EE Helper',
      'Starting server',
      'Backing server was not running. Starting server located at'..obj.server_home 
    )
    --start server via gradle
    io.popen(obj.gradle_home..' -b '..obj.server_home..'/build.gradle run &')

    --hide chooser (essentially it will never show up)
    chsr:hide()
  end
end

--- EliteExtra:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for EliteExtra
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * search - This will open the site-search chooser
function obj:bindHotkeys(mapping)
    local def = { search = function() chsr:show() end }
    hs.spoons.bindHotkeysToSpec(def, mapping)
end

--- EliteExtra:start()
--- Method
--- Start EliteExtra site-search chooser
---
--- Parameters:
---  * None
function obj:start()
    chsr = hs.chooser.new(selectFunc)
    chsr:bgDark(true)
    chsr:queryChangedCallback(onQueryChange)

    if self.server_home ~= nil then
      chsr:showCallback(onShow)
    end
end

--- EliteExtra:stop()
--- Method
--- Stop EliteExtra site-search chooser
---
--- Parameters:
---  * None
function obj:stop()
    chsr:delete()
end

return obj
