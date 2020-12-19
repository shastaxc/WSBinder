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

default_main_binds = {
  ['Hand-to-Hand'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Victory Smite", --empyrean
      ['CTRL+numpad8'] = "", --mythic
      ['CTRL+numpad9'] = "Final Heaven", --relic
      ['CTRL+numpad4'] = "Asuran Fists", --ambuscade
      ['CTRL+numpad5'] = "Shijin Spiral", --aeonic
      ['CTRL+numpad6'] = "Shoulder Tackle",
      ['CTRL+numpad1'] = "Spinning Attack", --aoe
      ['CTRL+numpad2'] = "Raging Fists",
      ['CTRL+numpad3'] = "Howling Fist",
    },
    ['MNK'] = {
      ['CTRL+numpad8'] = "Ascetic's Fury", --mythic
    },
    ['PUP'] = {
      ['CTRL+numpad8'] = "Stringing Pummel", --mythic
    },
  },
  ['Dagger'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Rudra's Storm", --empyrean
      ['CTRL+numpad8'] = "", --mythic
      ['CTRL+numpad9'] = "Mercy Stroke", --relic
      ['CTRL+numpad4'] = "Evisceration", --ambuscade
      ['CTRL+numpad5'] = "Exenterator", --aeonic
      ['CTRL+numpad6'] = "Shark Bite",
      ['CTRL+numpad1'] = "Aeolian Edge", --aoe
      ['CTRL+numpad2'] = "Cyclone", --elemental
      ['CTRL+numpad3'] = "Energy Drain", --elemental
    },
    ['THF'] = {
      ['CTRL+numpad8'] = "Mandalic Stab", --mythic
    },
    ['DNC'] = {
      ['CTRL+numpad8'] = "Pyrrhic Kleos", --mythic
    },
    ['BRD'] = {
      ['CTRL+numpad8'] = "Mordant Rime", --mythic
    },
  },
  ['Sword'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Chant du Cygne", --empyrean
      ['CTRL+numpad8'] = "", --mythic
      ['CTRL+numpad9'] = "Knights of Round", --relic
      ['CTRL+numpad4'] = "Savage Blade", --ambuscade
      ['CTRL+numpad5'] = "Requiescat", --aeonic
      ['CTRL+numpad6'] = "Sanguine Blade",
      ['CTRL+numpad1'] = "Circle Blade", --aoe
      ['CTRL+numpad2'] = "Red Lotus Blade", --elemental
      ['CTRL+numpad3'] = "Seraph Blade", --elemental
    },
    ['RDM'] = {
      ['CTRL+numpad8'] = "Death Blossom", --mythic
    },
    ['PLD'] = {
      ['CTRL+numpad8'] = "Atonement", --mythic
    },
    ['BLU'] = {
      ['CTRL+numpad8'] = "Expiacion", --mythic
    },
  },
  ['Great Sword'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Torcleaver", --empyrean
      ['CTRL+numpad8'] = "Dimidiation", --mythic
      ['CTRL+numpad9'] = "Scourge", --relic
      ['CTRL+numpad4'] = "Ground Strike", --ambuscade
      ['CTRL+numpad5'] = "Resolution", --aeonic
      ['CTRL+numpad6'] = "Power Slash",
      ['CTRL+numpad1'] = "Shockwave", --aoe
      ['CTRL+numpad2'] = "Freezebite", --elemental
      ['CTRL+numpad3'] = "Herculean Slash",
    },
  },
  ['Axe'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Cloudsplitter", --empyrean
      ['CTRL+numpad8'] = "Primal Rend", --mythic
      ['CTRL+numpad9'] = "Onslaught", --relic
      ['CTRL+numpad4'] = "Decimation", --ambuscade
      ['CTRL+numpad5'] = "Ruinator", --aeonic
      ['CTRL+numpad6'] = "Smash Axe",
      ['CTRL+numpad1'] = "Rampage",
      ['CTRL+numpad2'] = "Gale Axe", --elemental
      ['CTRL+numpad3'] = "Bora Axe",
    },
  },
  ['Great Axe'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Ukko's Fury", --empyrean
      ['CTRL+numpad8'] = "King's Justice", --mythic
      ['CTRL+numpad9'] = "Metatron Torment", --relic
      ['CTRL+numpad4'] = "Steel Cyclone", --ambuscade
      ['CTRL+numpad5'] = "Upheaval", --aeonic
      ['CTRL+numpad6'] = "Weapon Break",
      ['CTRL+numpad1'] = "Fell Cleave", --aoe
      ['CTRL+numpad2'] = "Shield Break",
      ['CTRL+numpad3'] = "Armor Break",
    },
  },
  ['Scythe'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Quietus", --empyrean
      ['CTRL+numpad8'] = "Insurgency", --mythic
      ['CTRL+numpad9'] = "Catastrophe", --relic
      ['CTRL+numpad4'] = "Spiral Hell", --ambuscade
      ['CTRL+numpad5'] = "Entropy", --aeonic
      ['CTRL+numpad6'] = "Cross Reaper",
      ['CTRL+numpad1'] = "Spinning Scythe", --aoe
      ['CTRL+numpad2'] = "Shadow of Death", --elemental
      ['CTRL+numpad3'] = "Nightmare Scythe",
    },
  },
  ['Polearm'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Camlann's Torment", --empyrean
      ['CTRL+numpad8'] = "Drakesbane", --mythic
      ['CTRL+numpad9'] = "Geirskogul", --relic
      ['CTRL+numpad4'] = "Impulse Drive", --ambuscade
      ['CTRL+numpad5'] = "Stardiver", --aeonic
      ['CTRL+numpad6'] = "Leg Sweep",
      ['CTRL+numpad1'] = "Sonic Thrust", --aoe
      ['CTRL+numpad2'] = "Raiden Thrust", --elemental
      ['CTRL+numpad3'] = "Penta Thrust",
    },
  },
  ['Katana'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Blade: Hi", --empyrean
      ['CTRL+numpad8'] = "Blade: Kamu", --mythic
      ['CTRL+numpad9'] = "Blade: Metsu", --relic
      ['CTRL+numpad4'] = "Blade: Ku", --ambuscade
      ['CTRL+numpad5'] = "Blade: Shun", --aeonic
      ['CTRL+numpad6'] = "Blade: Chi",
      ['CTRL+numpad1'] = "Blade: Yu",
      ['CTRL+numpad2'] = "Blade: Ei", --elemental
      ['CTRL+numpad3'] = "Blade: Ten",
    },
  },
  ['Great Katana'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Tachi: Fudo", --empyrean
      ['CTRL+numpad8'] = "Tachi: Rana", --mythic
      ['CTRL+numpad9'] = "Tachi: Kaiten", --relic
      ['CTRL+numpad4'] = "Tachi: Kasha", --ambuscade
      ['CTRL+numpad5'] = "Tachi: Shoha", --aeonic
      ['CTRL+numpad6'] = "Tachi: Hobaku",
      ['CTRL+numpad1'] = "Tachi: Gekko",
      ['CTRL+numpad2'] = "Tachi: Jinpu", --elemental
      ['CTRL+numpad3'] = "Tachi: Koki", --elemental
    },
  },
  ['Club'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Dagan", --empyrean
      ['CTRL+numpad8'] = "", --mythic
      ['CTRL+numpad9'] = "Randgrith", --relic
      ['CTRL+numpad4'] = "Black Halo", --ambuscade
      ['CTRL+numpad5'] = "Realmrazer", --aeonic
      ['CTRL+numpad6'] = "Brainshaker",
      ['CTRL+numpad1'] = "Hexa Strike",
      ['CTRL+numpad2'] = "Seraph Strike", --elemental
      ['CTRL+numpad3'] = "Skullbreaker",
    },
    ['WHM'] = {
      ['CTRL+numpad8'] = "Mystic Boon", --mythic
    },
    ['GEO'] = {
      ['CTRL+numpad8'] = "Exudation", --mythic
    },
  },
  ['Staff'] = {
    ['All'] = {
      ['CTRL+numpad7'] = "Myrkr", --empyrean
      ['CTRL+numpad8'] = "", --mythic
      ['CTRL+numpad9'] = "Gate of Tartarus", --relic
      ['CTRL+numpad4'] = "Retribution", --ambuscade
      ['CTRL+numpad5'] = "Shattersoul", --aeonic
      ['CTRL+numpad6'] = "Shell Crusher",
      ['CTRL+numpad1'] = "Cataclysm", --aoe
      ['CTRL+numpad2'] = "Earth Crusher", --elemental
      ['CTRL+numpad3'] = "Sunburst", --elemental
    },
    ['BLM'] = {
      ['CTRL+numpad8'] = "Vidohunir", --mythic
    },
    ['SMN'] = {
      ['CTRL+numpad8'] = "Garland of Bliss", --mythic
    },
    ['SCH'] = {
      ['CTRL+numpad8'] = "Omniscience", --mythic
    },
  }
}
ranged_ws_disclaimer = '\n'..
  '-- =====================================================\n'..
  '-- IMPORTANT: Ranged keybinds should be different than\n'..
  '-- all of the other WS keybinds Otherwise, you will\n'..
  '-- only get either main WSs or ranged WSs, but not both.'..
  '-- The only exception is if you enable exclusive mode.\n'..
  '-- =====================================================\n'
default_ranged_binds = {
  ['Archery'] = {
    ['All'] = {
      ['ALT+numpad7'] = "Jishnu's Radiance", --empyrean
      ['ALT+numpad8'] = "", --mythic
      ['ALT+numpad9'] = "Namas Arrow", --relic
      ['ALT+numpad4'] = "Empyreal Arrow", --ambuscade
      ['ALT+numpad5'] = "Apex Arrow", --aeonic
      ['ALT+numpad6'] = "Sidewinder",
      ['ALT+numpad1'] = "Dulling Arrow",
      ['ALT+numpad2'] = "Flaming Arrow", --elemental
      ['ALT+numpad3'] = "Refulgent Arrow",
    },
    ['RNG'] = {
      ['ALT+numpad9'] = "Namas Arrow", --relic
      ['ALT+numpad5'] = "Apex Arrow", --aeonic
    },
    ['SAM'] = {
      ['ALT+numpad9'] = "Namas Arrow", --relic
    },
  },
  ['Marksmanship'] = {
    ['All'] = {
      ['ALT+numpad7'] = "Wildfire", --empyrean
      ['ALT+numpad8'] = "", --mythic
      ['ALT+numpad9'] = "", --relic
      ['ALT+numpad4'] = "Detonator",
      ['ALT+numpad5'] = "", --aeonic
      ['ALT+numpad6'] = "Slug Shot",
      ['ALT+numpad1'] = "Sniper Shot",
      ['ALT+numpad2'] = "Hot Shot", --elemental
      ['ALT+numpad3'] = "Numbing Shot",
    },
    ['RNG'] = {
      ['ALT+numpad8'] = "Trueflight", --mythic
      ['ALT+numpad5'] = "Last Stand", --aeonic
      ['ALT+numpad9'] = "Coronach", --relic
    },
    ['COR'] = {
      ['ALT+numpad8'] = "Leaden Salute", --mythic
      ['ALT+numpad5'] = "Last Stand", --aeonic
    },
  },
}

valid_keybind_modifiers = {
  ["SHIFT"] = "~", 	-- Shift
  ["CTRL"]  = "^", 	-- Ctrl
  ["WIN"]   = "@", 	-- Win
  ["ALT"]   = "!", 	-- Alt
  ["APPS"]  = "#", 	-- Apps
}

valid_keybinds = S{
  "escape",
  "f1",
  "f2",
  "f3",
  "f4",
  "f5",
  "f6",
  "f7",
  "f8",
  "f9",
  "f10",
  "f11",
  "f12",
  "`",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "0",
  "-",
  "=",
  "backspace",
  "tab",
  "q",
  "w",
  "e",
  "r",
  "t",
  "y",
  "u",
  "i",
  "o",
  "p",
  "[",
  "]",
  "\\",
  "capslock",
  "a",
  "s",
  "d",
  "f",
  "g",
  "h",
  "j",
  "k",
  "l",
  ";",
  "'",
  "enter",
  "return",
  "shift",
  "lshift",
  "z",
  "x",
  "c",
  "v",
  "b",
  "n",
  "m",
  ",",
  ".",
  "/",
  "rshift",
  "ctrl",
  "lctrl",
  "windows",
  "lwindows",
  "alt",
  "lalt",
  "space",
  "ralt",
  "rwindows",
  "apps",
  "rctrl",
  "scrolllock",
  "pause",
  "insert",
  "home",
  "pageup",
  "delete",
  "end",
  "pagedown",
  "up",
  "left",
  "down",
  "right",
  "numlock",
  "numpad/",
  "numpad*",
  "numpad-",
  "numpad+",
  "numpad7",
  "numpad8",
  "numpad9",
  "numpad4",
  "numpad5",
  "numpad6",
  "numpad1",
  "numpad2",
  "numpad3",
  "numpad0",
  "numpad.",
  "numpadenter",
  "kana",
  "convert",
  "noconvert",
  "yen",
  "kanji",
  "sysrq",
  "mail",
  "mmselect",
  "mmstop",
  "mute",
  "mycomputer",
  "mmnext",
  "mmnexttrack",
  "mmplaypause",
  "power",
  "mmprevtrack",
  "mmstop",
  "mmvolup",
  "mmvoldown",
  "webback",
  "webfav",
  "webforward",
  "webhome",
  "webrefresh",
  "websearch",
  "webstop",
}

keybind_modifier_order = {
  ["SHIFT"] = 1, -- Shift
  ["CTRL"]  = 2, -- Ctrl
  ["WIN"]   = 3, -- Win
  ["ALT"]   = 4, -- Alt
  ["APPS"]  = 5, -- Apps
}

keybind_order = {
  ["escape"]        = 1,
  ["f1"]            = 2,
  ["f2"]            = 3,
  ["f3"]            = 4,
  ["f4"]            = 5,
  ["f5"]            = 6,
  ["f6"]            = 7,
  ["f7"]            = 8,
  ["f8"]            = 9,
  ["f9"]            = 10,
  ["f10"]           = 11,
  ["f11"]           = 12,
  ["f12"]           = 13,
  ["`"]             = 14,
  ["1"]             = 15,
  ["2"]             = 16,
  ["3"]             = 17,
  ["4"]             = 18,
  ["5"]             = 19,
  ["6"]             = 20,
  ["7"]             = 21,
  ["8"]             = 22,
  ["9"]             = 23,
  ["0"]             = 24,
  ["-"]             = 25,
  ["="]             = 26,
  ["backspace"]     = 27,
  ["tab"]           = 28,
  ["q"]             = 29,
  ["w"]             = 30,
  ["e"]             = 31,
  ["r"]             = 32,
  ["t"]             = 33,
  ["y"]             = 34,
  ["u"]             = 35,
  ["i"]             = 36,
  ["o"]             = 37,
  ["p"]             = 38,
  ["["]             = 39,
  ["]"]             = 40,
  ["\\"]            = 41,
  ["capslock"]      = 42,
  ["a"]             = 43,
  ["s"]             = 44,
  ["d"]             = 45,
  ["f"]             = 46,
  ["g"]             = 47,
  ["h"]             = 48,
  ["j"]             = 49,
  ["k"]             = 50,
  ["l"]             = 51,
  [";"]             = 52,
  ["'"]             = 53,
  ["enter"]         = 54,
  ["return"]        = 55,
  ["shift"]         = 56,
  ["lshift"]        = 57,
  ["z"]             = 58,
  ["x"]             = 59,
  ["c"]             = 60,
  ["v"]             = 61,
  ["b"]             = 62,
  ["n"]             = 63,
  ["m"]             = 64,
  [","]             = 65,
  ["."]             = 66,
  ["/"]             = 67,
  ["rshift"]        = 68,
  ["ctrl"]          = 69,
  ["lctrl"]         = 70,
  ["windows"]       = 71,
  ["lwindows"]      = 72,
  ["alt"]           = 73,
  ["lalt"]          = 74,
  ["space"]         = 75,
  ["ralt"]          = 76,
  ["rwindows"]      = 77,
  ["apps"]          = 78,
  ["rctrl"]         = 79,
  ["scrolllock"]    = 80,
  ["pause"]         = 81,
  ["insert"]        = 82,
  ["home"]          = 83,
  ["pageup"]        = 84,
  ["delete"]        = 85,
  ["end"]           = 86,
  ["pagedown"]      = 87,
  ["up"]            = 88,
  ["left"]          = 89,
  ["down"]          = 90,
  ["right"]         = 91,
  ["numlock"]       = 92,
  ["numpad/"]       = 93,
  ["numpad*"]       = 94,
  ["numpad-"]       = 95,
  ["numpad+"]       = 96,
  ["numpad7"]       = 97,
  ["numpad8"]       = 98,
  ["numpad9"]       = 99,
  ["numpad4"]       = 100,
  ["numpad5"]       = 101,
  ["numpad6"]       = 102,
  ["numpad1"]       = 103,
  ["numpad2"]       = 104,
  ["numpad3"]       = 105,
  ["numpad0"]       = 106,
  ["numpad."]       = 107,
  ["numpadenter"]   = 108,
  ["kana"]          = 109,
  ["convert"]       = 110,
  ["noconvert"]     = 111,
  ["yen"]           = 112,
  ["kanji"]         = 113,
  ["sysrq"]         = 114,
  ["mail"]          = 115,
  ["mmselect"]      = 116,
  ["mmstop"]        = 117,
  ["mute"]          = 118,
  ["mycomputer"]    = 119,
  ["mmnext"]        = 120,
  ["mmnexttrack"]   = 121,
  ["mmplaypause"]   = 122,
  ["power"]         = 123,
  ["mmprevtrack"]   = 124,
  ["mmstop"]        = 125,
  ["mmvolup"]       = 126,
  ["mmvoldown"]     = 127,
  ["webback"]       = 128,
  ["webfav"]        = 129,
  ["webforward"]    = 130,
  ["webhome"]       = 131,
  ["webrefresh"]    = 132,
  ["websearch"]     = 133,
  ["webstop"]       = 134,
}

range_mult = {
  [2] = 1.55,
  [3] = 1.490909,
  [4] = 1.44,
  [5] = 1.377778,
  [6] = 1.30,
  [7] = 1.15,
  [8] = 1.25,
  [9] = 1.377778,
  [10] = 1.45,
  [11] = 1.454545454545455,
  [12] = 1.666666666666667,
}

inverted_valid_keybind_modifiers = {
  ["~"] = "SHIFT",-- Shift
  ["^"] = "CTRL", -- Ctrl
  ["@"] = "WIN", 	-- Win
  ["!"] = "ALT", 	-- Alt
  ["#"] = "APPS", -- Apps
}
