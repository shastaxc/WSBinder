-- Copyright © 2020, Silvermutt (Asura)
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:

--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of WSBinder nor the
--       names of its contributors may be used to endorse or promote products
--       derived from this software without specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

_addon.name = 'WSBinder'
_addon.author = 'Silvermutt (Asura)'
_addon.version = '1.0'
_addon.commands = {'wsbinder', 'wsb'}

-------------------------------------------------------------------------------
-- Imports
-------------------------------------------------------------------------------
res = require 'resources'
config = require('config')
require('statics')
require('strings')
files = require('files')
texts = require('texts')

-- Create user binds file if it doesn't already exist, and load with init data
if not files.exists('data/user-binds.lua') then
  new_file = files.new('data/user-binds.lua', true)
  files.write(new_file, 'user_ws_binds = {}', true)
end
require('data/user-binds')

function initialize()
  -------------------------------------------------------------------------------
  -- Define default settings, load user settings
  -------------------------------------------------------------------------------
  defaults = {}
  defaults.target_modes = {}
  defaults.target_modes.main_hand = 't'
  defaults.target_modes.ranged = 't'
  
  defaults.wstxt = {}
  defaults.wstxt.pos = {}
  defaults.wstxt.pos.x = -150
  defaults.wstxt.pos.y = 48
  defaults.wstxt.text = {}
  defaults.wstxt.text.font = 'Arial'
  defaults.wstxt.text.size = 10
  defaults.wstxt.flags = {}
  defaults.wstxt.flags.right = true
  
  defaults.show_overlay = true
  defaults.show_debug_messages = false
  defaults.show_range_highlight = true
  
  -- Load settings from file and merge/overwrite defaults
  settings = config.load(defaults)
  ws_binds = mix_in_user_binds(default_ws_binds, user_ws_binds)
  ws_overlay = texts.new('${value}', settings.wstxt)

  -------------------------------------------------------------------------------
  -- Global vars
  -------------------------------------------------------------------------------
  current_weapon_type = nil
  current_ranged_weapon_type = nil
  latest_ws_binds = {} -- format: { [keybind"] = "ws name" }
  latest_ws_binds_pretty = {} -- format: { [1] = { weapon_typ ="weapon type", modifier="mod", key="key", ws_name="ws name" }}
  is_changing_job = nil
  player = {}
  player.equipment = {}
  inventory_loaded = false
end

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------
function pretty_sort()
  table.sort(latest_ws_binds_pretty, function(a, b)
    if a.weapon_type > b.weapon_type then
      return true
    elseif a.weapon_type < b.weapon_type then
      return false
    else
      -- Ensure modifier exists
      if a.modifier and not b.modifier then
        return true
      elseif not a.modifier and b.modifier then
        return false
      elseif not a.modifier and not b.modifier then
        return true
      end
      -- At this point, modifier must exist
      if a.modifier > b.modifier then
        return true
      elseif a.modifier < b.modifier then
        return false
      else
        if a.key > b.key then
          return true
        elseif a.key < b.key then
          return false
        else
          if a.ws_name > b.ws_name then
            return true
          elseif a.ws_name < b.ws_name then
            return false
          end
        end
      end
    end
    return false
  end)
end

function chat_msg(color, msg, is_debug)
  if is_debug and settings.show_debug_messages then
    windower.add_to_chat(color, msg)
  elseif not is_debug then
    windower.add_to_chat(color, msg)
  end
end

function display_overlay()
  local t = windower.ffxi.get_mob_by_target('t') or windower.ffxi.get_mob_by_target('st')
  local s = windower.ffxi.get_mob_by_target('me')
  local list = 'Weapon Skills:\n'

  for n,ws_data in pairs(latest_ws_binds_pretty) do
    local ws = res.weapon_skills:with('en', ws_data.ws_name)
    local is_out_of_range = isOutOfRange(ws.range, s, t)

    -- Add to display list
    local mod_msg
    if ws_data.modifier then
      mod_msg = ws_data.modifier.."+"
    else
      mod_msg = ""
    end
    local key_msg = ws_data.key.." "
    local ws_name_msg = ws_data.ws_name
    if t and t.distance:sqrt() ~= 0 and not is_out_of_range and settings.show_range_highlight then 
      list = list..'\\cs(0,255,0)'..mod_msg..key_msg..ws_name_msg..'\\cs(255,255,255)'..'\n'
    else
      list = list..'\\cs(255,255,255)'..mod_msg..key_msg..ws_name_msg..'\n'
    end
  end
  ws_overlay.value = list
  ws_overlay:visible(settings.show_overlay)
end

-- 'ws_range' expected to be the range pulled from weapon_skills.lua
-- 's' is self player object
-- 't' is target object
function isOutOfRange(ws_range, s, t)
  if ws_range == nil or s == nil or t == nil then
    return true
  end

  local distance = t.distance:sqrt()
  local is_out_of_range = distance > (t.model_size + ws_range * range_mult[ws_range] + s.model_size)

  return is_out_of_range
end

-- Overwrites first table with values in second table
function mix_in_user_binds(d_ws_binds, u_ws_binds)
  local merged_binds = d_ws_binds
  for weapon_type,weapon_table in pairs(merged_binds) do
    if u_ws_binds[weapon_type] then
      merged_binds[weapon_type] = u_ws_binds[weapon_type]
    end
  end
  return merged_binds
end

function update_weaponskill_binds(force_update)
  if is_changing_job then
    return
  end

  local has_main_weapon_changed = false
  local has_ranged_weapon_changed = false
  local main_weapon = nil
  local main_weapon_type = nil
  local ranged_weapon = nil
  local ranged_weapon_type = nil

  -- Get main weapon and type
  -- Handle barehanded case
  if player.equipment.main == nil or player.equipment.main == 0 or player.equipment.main == 'empty' then
    main_weapon_type = 'Hand-to-Hand'
  else -- Handle equipped weapons case
    main_weapon = res.items:with('name', player.equipment.main)
    main_weapon_type = res.skills[main_weapon.skill].en
  end

  -- Get ranged weapon and type
  if player.equipment.range ~= nil and player.equipment.range ~= 0 and player.equipment.range ~= 'empty' then
    ranged_weapon = res.items:with('name', player.equipment.range)
    ranged_weapon_type = res.skills[ranged_weapon.skill].en
  end

  has_main_weapon_changed = main_weapon_type ~= current_main_weapon_type
  has_ranged_weapon_changed = ranged_weapon_type ~= current_ranged_weapon_type

  -- Do not proceed to update keybinds only if all these happen at once:
  -- `force_update` flag isn't set
  -- Main weapon type has not changed, and
  -- Ranged weapon type has not changed, and
  if not force_update and not has_main_weapon_changed and not has_ranged_weapon_changed then
    return
  end

  -- Update the main weapon type tracker and get new keybinds
  current_main_weapon_type = main_weapon_type
  -- Get new main hand bindings
  local new_main_ws_bindings = get_ws_bindings(main_weapon_type)

  -- Update the ranged weapon type tracker and get new keybinds
  current_ranged_weapon_type = ranged_weapon_type
  -- Get new ranged bindings
  local new_ranged_ws_bindings = get_ws_bindings(ranged_weapon_type)

  -- Merge main and ranged keybinds into same table
  local merged_main_ranged_bindings = new_main_ws_bindings
  for keybind,ws_name in pairs(new_ranged_ws_bindings) do
    -- If key is already in the table for main hand WS, warn user
    if merged_main_ranged_bindings[keybind] then
      print('Keybind Overwrite Warning: "'..ws_name..'" overwriting "'..
          merged_main_ranged_bindings[keybind]..'" keybind ('..keybind..').')
    end
    merged_main_ranged_bindings[keybind] = new_ranged_ws_bindings[keybind]
  end

  -- Unbind previous bindings if there is no overlap in new bindings. This
  -- is necessary because unbind commands appear to be asynchronous and
  -- would otherwise erase your new keybinds too.
  for old_keybind,old_ws_name in pairs(latest_ws_binds) do
    local is_same = false
    for new_keybind,new_ws_name in pairs(merged_main_ranged_bindings) do
      if old_keybind == new_keybind then
        is_same = true
        break
      end
    end
    if not is_same then
      windower.send_command("unbind "..old_keybind)
    end
  end

  -- Set weaponskill bindings according to table
  for keybind,ws_name in pairs(merged_main_ranged_bindings) do
    local ws = res.weapon_skills:with('en', ws_name)
    local is_main_hand_keybind = ws.skill > 0 and ws.skill < 13 -- Skill ID 1-12 are main hand
    local target_mode_main = settings.target_modes.main_hand
    local target_mode_ranged = settings.target_modes.ranged
    if is_main_hand_keybind then
      windower.send_command("bind "..keybind.." input /ws \""..ws_name.."\" <"..settings.target_modes.main_hand..">")
    else
      windower.send_command("bind "..keybind.." input /ws \""..ws_name.."\" <"..settings.target_modes.ranged..">")
    end
  end

  latest_ws_binds = merged_main_ranged_bindings
    
  -- Make a separate table with good format for displaying in overlay
  latest_ws_binds_pretty = {}
  for keybind,ws_name in pairs(merged_main_ranged_bindings) do
    local entry = {}
    entry.ws_name = ws_name
    if new_ranged_ws_bindings[keybind] then
      entry.weapon_type = ranged_weapon_type
    else
      entry.weapon_type = main_weapon_type
    end
    entry.modifier = inverted_valid_keybind_modifiers[keybind:sub(1,1)]
    if entry.modifier then
      entry.key = keybind:slice(2)
    else
      entry.key = keybind
    end
    table.insert(latest_ws_binds_pretty, entry)
  end

  pretty_sort() -- Sorts the latest_ws_binds_pretty table

  -- Notify user that keybinds have been updated
  local weapon_type = main_weapon_type
  if ranged_weapon_type ~= nil then
    weapon_type = weapon_type..'/'..ranged_weapon_type
  end
  local player_job = windower.ffxi.get_player().main_job
  local sub_job = windower.ffxi.get_player().sub_job
  if sub_job then
    player_job = player_job..'/'..sub_job
  end

  local notify_msg = 'Set keybinds '
    ..string.char(31,001)..weapon_type
    ..string.char(31,008)..' for '
    ..string.char(31,001)..player_job
    chat_msg(8, notify_msg, true)
end

-- Keys are not guaranteed to be sorted in any particular order, but keybinds must be overwritten
-- in a particular order: Default -> Main job only -> Main/Sub job combo
-- So they need to be pulled out by category, ignoring job bindings that don't match player's current job
-- then recombined in the right order so overwriting keybinds is done as intended.
function get_ws_bindings(weapon_type)
  -- Null check
  if ws_binds == nil or weapon_type == nil then
    return {}
  end

  local player_main_job = windower.ffxi.get_player().main_job
  local player_sub_job = windower.ffxi.get_player().sub_job
  local weapon_specific_bindings = ws_binds[weapon_type]

  -- Separate bindings into job-specific categories
  local default_bindings
  local main_job_bindings
  local main_sub_combo_bindings

  for key,job_specific_table in pairs(weapon_specific_bindings) do
    key_upper = key:upper()
    local is_key_default = key_upper == 'DEFAULT'
    if is_key_default then
      -- Add to default category
      default_bindings = job_specific_table
    else -- Handle job-specific categories
      local is_key_main_sub_combo = key_upper:length() == 7 and key_upper[4] == '/'
      local key_main_job = key_upper:sub(1,3)
      local key_sub_job
      if is_key_main_sub_combo then
        local key_sub_job = key_upper:sub(5,7)
      end
      -- Ensure main job is valid
      if key_main_job then
        if not res.jobs:with('ens', key_main_job) then
          print("Invalid job key in "..weapon_type.." table: "..key)
          key_main_job = nil -- Nullify value to avoid binding
        end
      end
      -- Ensure sub job is valid (if specified)
      if is_key_main_sub_combo then
        if not res.jobs:with('ens', key_sub_job) then
          print("Invalid job key in "..weapon_type.." table: "..key)
          key_sub_job = nil -- Nullify value to avoid binding
        end
      end
      
      -- Get main/sub bindings
      if (is_key_main_sub_combo and key_main_job == player_main_job
          and key_sub_job == player_sub_job) then
        main_sub_combo_bindings = job_specific_table
      -- Get main job bindings
      elseif (not is_key_main_sub_combo and key_main_job == player_main_job) then
        main_job_bindings = job_specific_table
      end
    end
  end
  
  -- Combine default, main job, and sub job bindings in that
  -- order to give priority to sub job bindings
  local job_merged_bindings = {}
  if default_bindings then
    for keybind,ws_name in pairs(default_bindings) do
      job_merged_bindings[keybind] = ws_name
    end
  end
  if main_job_bindings then
    for keybind,ws_name in pairs(main_job_bindings) do
      job_merged_bindings[keybind] = ws_name
    end
  end
  if main_sub_combo_bindings then
    for keybind,ws_name in pairs(main_sub_combo_bindings) do
      job_merged_bindings[keybind] = ws_name
    end
  end

  -- Convert keybinds to computer-readable format & purge invalid entries
  return clean_ws_binds(job_merged_bindings)
end

-- Convert keybinds to computer-readable format & purge invalid entries
-- Convert example: "CTRL+Numpad1" becomes "^numpad1"
-- Purge example: given "CTR+Numpad1" the modifier "CTR" is invalid, entry will throw error
-- Blank WS names will not throw an error, but binding will be skipped for that entry
function clean_ws_binds(ws_bindings)
  local cleaned_table = {}
  for keybind,ws_name in pairs(ws_bindings) do
    -- Check if modifier is included
    -- Modifier could be in two formats, so check both
    local char_mod = inverted_valid_keybind_modifiers[keybind:sub(1,1)]
    local modifier
    local bind_btn
    local split_keybind = keybind:split('+')

    if char_mod then
      if split_keybind[1]:length() == 1 then
        -- Keybind is literally just a modifier, invalid
        print("Invalid modifier: "..pretty_bind(keybind, ws_name))
      else
        modifier = char_mod
        bind_btn = split_keybind[1]:slice(2):lower()
      end
    else
      if #split_keybind == 1 then -- No modifier
        bind_btn = split_keybind[1]:lower()
      elseif #split_keybind == 2 then
        modifier = split_keybind[1]:upper()
        bind_btn = split_keybind[2]:lower()
      end
    end

    local final_bind = ""
    if modifier then
      if valid_keybind_modifiers[modifier] then
        -- Modifier is valid, but change its format
        final_bind = valid_keybind_modifiers[modifier]
      elseif char_mod then
        -- Modifier is valid
        final_bind = char_mod
      else
        print("Invalid modifier: "..pretty_bind(keybind, ws_name))
      end
    end
    if bind_btn then
      if valid_keybinds:contains(bind_btn) then
        final_bind = final_bind..bind_btn
      else
        print("Invalid keybind: "..pretty_bind(keybind, ws_name))
      end
    else
      print("Invalid keybind: "..pretty_bind(keybind, ws_name))
      final_bind = nil
    end

    -- At this point, final_bind is either in the correct format or nil
    -- If final_bind is nil, may as well skip the rest of this loop cycle
    if final_bind then -- Ensure keybind is not blank
      -- Now validate the WS name
      local is_ws_name_valid = res.weapon_skills:with('en', ws_name) ~= nil

      -- If keybind is valid and ws name is valid, add to cleaned table
      if is_ws_name_valid then
        cleaned_table[final_bind] = ws_name
      elseif ws_name and ws_name ~= '' then
        print("Invalid WS Name: "..pretty_bind(keybind, ws_name))
      end
    end
  end

  return cleaned_table
end

function pretty_bind(keybind, ws_name)
  local msg = ""
  if keybind and keybind~='' then
    msg = msg.."["..keybind.."]"
  else
    msg = msg.."[Blank Keybind]"
  end
  if ws_name and ws_name ~='' then
    msg = msg.."["..ws_name.."]"
  else
    msg = msg.."[Blank WS Name]"
  end

  return msg
end

function unbind_ws(ws_to_unbind)
  if ws_to_unbind == nil then
    return
  end

  -- Iterate through the latest keybinds and unbind them all
  for keybind,ws_name in pairs(ws_to_unbind) do
    windower.send_command("unbind "..keybind)
  end
end

-- Save all currently-equipped gear in global table
-- Adapted this function from GearInfo
function check_equipped()
	local new_gear_table = {}
  local items_equipped = windower.ffxi.get_items().equipment

	local default_slot = T{'sub','range','ammo','head','body','hands','legs','feet','neck','waist', 'left_ear', 'right_ear', 'left_ring', 'right_ring','back'}
	default_slot[0]= 'main'

	if items_equipped then
		for id,name in pairs(default_slot) do
			items_equipped[name] = {
        slot = items_equipped[name],
        bag = items_equipped[name..'_bag']
      }
      items_equipped[name..'_bag'] = nil
		end
	end

	for k,v in pairs(items_equipped) do
		if v.slot == 0 then
			new_gear_table[k] = "empty"
    else
      local item_id = windower.ffxi.get_items(v.bag, v.slot).id
      if item_id ~= 0 and item_id ~= nil then
        new_gear_table[k] = res.items[item_id].en
      end
		end
	end

	player.equipment = new_gear_table

	return new_gear_table
end


-------------------------------------------------------------------------------
-- Event hooks
-------------------------------------------------------------------------------
windower.register_event('login', function(name)
  initialize()
  display_overlay()
end)

windower.register_event('logout', function()
  unbind_ws(latest_ws_binds)
  ws_overlay:visible(false)
end)

windower.register_event('load', function()
  initialize()
  display_overlay()
end)

windower.register_event('unload', function()
  unbind_ws(latest_ws_binds)
  ws_overlay:visible(false)
end)

windower.register_event('addon command', function(...)
  local cmdArgs = {...}
  -- Force all args to lowercase
  for i, arg in ipairs(cmdArgs) do
    cmdArgs[i] = arg:lower()
  end
  if cmdArgs[1] == 'help' or cmdArgs[1] == 'h' or cmdArgs[1] == '?' then
    chat_msg(8, 'WSBinder: Valid commands are //wsb <command>:', false)
    chat_msg(8, 'reload    | Reloads this addon.', false)
    chat_msg(8, 'debug     | Toggles debug messages on/off.', false)
    chat_msg(8, 'visible   | Show/hide the overlay that shows your current keybinds.', false)
    chat_msg(8, 'showrange | Toggles highlighting of the keybinds.', false)
    chat_msg(8, 'tm main   | Cycles through valid target modes for main hand.', false)
    chat_msg(8, 'tm ranged | Cycles through valid target modes for ranged.', false)
    chat_msg(8, '', false)
    chat_msg(8, 'To change keybinds, you must directly edit the \'user-binds.lua\' '..
     'file. For more information on the keybind mapping, visit https://github.com/shastaxc/WSBinder', false)
  elseif cmdArgs[1] == 'reload' or cmdArgs[1] == 'r' then
    windower.send_command('lua r wsbinder')
  elseif cmdArgs[1] == 'targetmode' or cmdArgs[1] == 'tm' then
    local ws_type = cmdArgs[2]
    if ws_type == 'main_hand' or ws_type == 'main' or ws_type == 'm' then
      ws_type = 'main_hand'
    elseif ws_type == 'ranged' or ws_type == 'range' or ws_type == 'r' then
      ws_type = 'ranged'
    else
      chat_msg(8, 'Invalid command. Type //wsb help for more info.', false)
      ws_type = nil
    end

    if ws_type then
      local new_mode
      if settings.target_modes[ws_type] == 't' then
        new_mode = 'stnpc'
      else
        new_mode = 't'
      end
      if settings.target_modes[ws_type] == 't' then
        new_mode = 'stnpc'
      else
        new_mode = 't'
      end

      settings.target_modes[ws_type] = new_mode
      config.save(settings)
      chat_msg(8, 'WS target mode for '..ws_type..' now set to <'..new_mode..'>.', false)
      update_weaponskill_binds(true)
    end
  elseif cmdArgs[1] == 'list' or cmdArgs[1] == 'visible'
      or cmdArgs[1] == 'show' or cmdArgs[1] == 'hide' then
    -- Toggle
    settings.show_overlay = not settings.show_overlay
    display_overlay()
    config.save(settings)
  elseif cmdArgs[1] == 'debug' or cmdArgs[1] == 'd' then
    settings.show_debug_messages = not settings.show_debug_messages
    config.save(settings)
  elseif cmdArgs[1] == 'showrange' or cmdArgs[1] == 'showranges' then
    settings.show_range_highlight = not settings.show_range_highlight
    config.save(settings)
  else
    chat_msg(8, 'Invalid command. Type //wsb help for more info.', false)
  end
end)

-- Executes on every frame. This is a way to create a perpetual loop.
frame_count = 0
windower.register_event('prerender',function()
  -- Use frame count to limit execution rate (roughly 0.25-0.5 seconds depending on FPS)
  if frame_count%15 == 0 and windower.ffxi.get_info().logged_in and windower.ffxi.get_player() then
    check_equipped()
    update_weaponskill_binds()
    display_overlay()
    frame_count = 0
  else
    frame_count = frame_count + 1
  end
end)

-- Hook into job/subjob change event (happens AFTER job has finished changing)
windower.register_event('job change', function(main_job_id, main_job_level, sub_job_id, sub_job_level)
  is_changing_job = false -- Disable this flag so keybinds can update again
  update_weaponskill_binds(true)
end)

-- Hook into job/subjob change event (happens BEFORE job starts changing)
windower.register_event('outgoing chunk', function(id, data, modified, injected, blocked)
  if id == 0x100 then -- Send lockstyle command to server
    is_changing_job = true -- Set this flag to lock keybind updating until job change is complete
    unbind_ws(latest_ws_binds)
  end
end)

