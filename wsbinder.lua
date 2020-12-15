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
_addon.commands = {'wsbinder', 'wsb', 'weaponskillbinder',}


-------------------------------------------------------------------------------
-- Imports
-------------------------------------------------------------------------------
res = require 'resources'
config = require('config')
require('statics')
require('keybind_map')
require('strings')

function initialize()
  -------------------------------------------------------------------------------
  -- Define default settings, load user settings
  -------------------------------------------------------------------------------
  defaults = {}
  defaults.target_modes = {}
  defaults.target_modes.main_hand = 't'
  defaults.target_modes.ranged = 't'

  -- Load settings from file and merge/overwrite defaults
  settings = config.load(defaults)

  -------------------------------------------------------------------------------
  -- Global vars
  -------------------------------------------------------------------------------
  current_weapon_type = nil
  current_ranged_weapon_type = nil
  latest_ws_binds = {}
  is_changing_job = nil
  player = {}
  player.equipment = {}
end

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

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
  windower.add_to_chat(8, notify_msg)
end

function get_ws_bindings(weapon_type)
  -- Null check
  if ws_binds == nil or weapon_type == nil then
    return {}
  end

  local main_job = windower.ffxi.get_player().main_job:lower()
  local sub_job = windower.ffxi.get_player().sub_job
  if sub_job then
    sub_job = sub_job:lower()
  end
  local weapon_specific_bindings = ws_binds[weapon_type]

  -- Separate bindings into job-specific categories
  local default_bindings
  local main_job_bindings
  local sub_job_bindings
  local main_sub_combo_bindings

  for key,job_specific_table in pairs(weapon_specific_bindings) do
    local is_key_sub_job = key:sub(1, 1) == '/'
    local is_key_main_sub_combo = key:sub(4, 4) == '/' and string.len(key) == 7
    -- Get default bindings
    if key == 'Default' then
      default_bindings = job_specific_table
    -- Get sub job bindings
    elseif (is_key_sub_job and key:sub(2,string.len(key)):lower() == sub_job) then
      sub_job_bindings = job_specific_table
    -- Get main/sub bindings
    elseif (is_key_main_sub_combo and key:sub(1,3):lower() == main_job
        and key:sub(5,7):lower() == sub_job:lower()) then
      main_sub_combo_bindings = job_specific_table
    -- Get main job bindings
    elseif (not is_key_sub_job and not is_key_main_sub_combo and key:lower() == main_job) then
      main_job_bindings = job_specific_table
    end
  end

  -- Combine default, main job, and sub job bindings in that
  -- order to give priority to sub job bindings
  local merged_bindings = {}
  if default_bindings then
    for keybind,ws_name in pairs(default_bindings) do
      merged_bindings[keybind] = ws_name
    end
  end
  if main_job_bindings then
    for keybind,ws_name in pairs(main_job_bindings) do
      merged_bindings[keybind] = ws_name
    end
  end
  if sub_job_bindings then
    for keybind,ws_name in pairs(sub_job_bindings) do
      merged_bindings[keybind] = ws_name
    end
  end
  if main_sub_combo_bindings then
    for keybind,ws_name in pairs(main_sub_combo_bindings) do
      merged_bindings[keybind] = ws_name
    end
  end

  -- Purge invalid entries
  return purge_invalid_ws_bindings(merged_bindings)
end

function purge_invalid_ws_bindings(ws_bindings)
  local purged_table = {}
  for keybind,ws_name in pairs(ws_bindings) do
    -- Check if modifier or state is included
    local first_char = keybind:sub(1,1)
    local second_char = keybind:sub(2,2)
    local modifier
    local state
    local bind_btn
    if valid_keybind_states:contains(first_char) then
      state = first_char
      bind_btn = keybind:sub(2,string.len(keybind))
    elseif valid_keybind_modifiers:contains(first_char) then
      modifier = first_char
      if valid_keybind_states:contains(second_char) then
        state = second_char
        bind_btn = keybind:sub(3,string.len(keybind))
      else
        bind_btn = keybind:sub(2,string.len(keybind))
      end
    else
      bind_btn = keybind
    end

    local is_keybind_blank = bind_btn == ''
    local is_keybind_valid = valid_keybinds:contains(bind_btn)
    local is_ws_name_valid = res.weapon_skills:with('en', ws_name) ~= nil

    -- If keybind is valid and ws name is valid, add to purged table
    if not is_keybind_blank -- Ensure keybind is not blank
        and is_keybind_valid -- Ensure keybind is in list of valid keys
        and is_ws_name_valid then -- Ensure WS name is an actual WS name
      purged_table[keybind] = ws_name
    elseif is_keybind_blank then
      if ws_name ~= '' then
        print("WS Keybind Error: Keybind is blank for "..ws_name)
      else
        print("WS Keybind Error: Keybind is blank")
      end
    elseif not is_keybind_valid then
      print("WS Keybind Error: \""..keybind.."\" is not a valid keybind")
    elseif not is_ws_name_valid and ws_name ~= nil and ws_name ~= '' then
      print("WS Keybind Error: \""..ws_name.."\" is not a valid WS name")
    end
  end

  return purged_table
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
			new_gear_table[k] = res.items[item_id].en
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
end)

windower.register_event('load', function()
  initialize()
end)

windower.register_event('addon command', function(...)
  local cmdArgs = {...}
  if cmdArgs[1]:lower() == 'help' or cmdArgs[1]:lower() == 'h' or cmdArgs[1]:lower() == '?' then
    windower.add_to_chat(8,'WSBinder: Valid commands are //wsb <command>:')
    windower.add_to_chat(8, 'tm main   | Cycles through valid target modes for main hand.')
    windower.add_to_chat(8, 'tm ranged | Cycles through valid target modes for ranged.')
    windower.add_to_chat(8, '')
    windower.add_to_chat(8, 'To change keybinds, you must directly edit the \'keybind_map.lua\' '..
     'file. For more information on the keybind mapping, visit https://github.com/shastaxc/WSBinder')
  elseif cmdArgs[1]:lower() == 'targetmode' or cmdArgs[1]:lower() == 'tm' then
    local ws_type = cmdArgs[2]:lower()
    if ws_type == 'main_hand' or ws_type == 'main' or ws_type == 'm' then
      ws_type = 'main_hand'
    elseif ws_type == 'ranged' or ws_type == 'range' or ws_type == 'r' then
      ws_type = 'ranged'
    else
      windower.add_to_chat(8, 'Invalid command. Type //wsb help for more info.')
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
      windower.add_to_chat(8, 'WS target mode for '..ws_type..' now set to <'..new_mode..'>.')
      update_weaponskill_binds(true)
    end
  elseif cmdArgs[1]:lower() == 'reload' or cmdArgs[1]:lower() == 'r' then
    windower.send_command('lua r wsbinder')
  else
    windower.add_to_chat(8, 'Invalid command. Type //wsb help for more info.')
  end
end)

-- Executes on every frame. This is a way to create a perpetual loop.
frame_count = 0
windower.register_event('prerender',function()
  -- Use frame count to limit execution rate (roughly 0.25-0.5 seconds depending on FPS)
  if frame_count%15 == 0 and windower.ffxi.get_info().logged_in and windower.ffxi.get_player() then
    check_equipped()
    update_weaponskill_binds()
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
