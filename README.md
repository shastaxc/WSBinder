# WSBinder
FFXI Windower v4 addon that dynamically binds weapon skills based on currently-equipped weapon and current job/sub job by pulling from pre-defined table.

## Descripton

Provides weaponskill keybinds that change dynamically based on your current weapon. This function has the
following benefits:
- Easily use multiple weapons on one job. For example, having a dagger equipped will automatically bind your pre-defined dagger weaponskills, and then changing your weapon to a sword will automatically unbind those dagger WS and set your sword keybinds on the fly.
- Use common keybinds for a specific weapon regardless of your job (but with the ability to customize it per job).
- Have all your keybinds defined in one place instead of in each individual job file.
- No other addons required
- Turn an overlay on or off that tells you your current WS keybinds
- Use main-hand and ranged WS keybinds at the same time (if defined without overlapping keybinds), or enable a toggle to share keybinds (see "exclusive mode").

Override functionality is included so that you can define your own keybinds in a global file without having
to modify this library lua.

## Implementation

1. Create a folder in your Windower/addons folder and name it `WSBinder`.
2. Place all files from this repository into the `WSBinder` folder.
3. (Optional) Enable automatic loading of this addon when you log in. In the file Windower/scripts/init.txt add the following to the bottom:
```
lua load WSBinder
```
4. Remove all conflicting keybinds from your GearSwap job luas.
5. Load this addon with the command ``lua load WSBinder` so it can generate your user files. This must be done first before you can set your own keybinds.

## Usage

### Addon Commands

There are some commands you can use to interact with the WSBinder addon from in-game chat. Commands follow the format of `//wsb <commands>` (without brackets <>). The following are valid commands:
| Command                | Alt Cmd       | Description                                                                      |
| ---------------------- | ------------- | -------------------------------------------------------------------------------- |
| `help`                 | `h`           | Prints out a bunch of helpful messages in the chat log                           |
| `reload`               | `r`           | Toggles the target mode for ranged hand WS's between `<t>` and `<stnpc>`         |
| `debug`                | `d`           | Toggles debug messages (e.g. when changing weapons or jobs)                      |
| `visible`              | `show`/`hide` | Toggles visibility on the overlay that shows your current keybinds               |
| `showrange`            | `showranges`  | Toggles highlighting of the keybinds (will highlight when in range)              |
| `targetmode main`      | `tm m`        | Toggles the target mode for main hand WS's between `<t>` and `<stnpc>`           |
| `targetmode main`      | `tm m`        | Toggles the target mode for ranged hand WS's between `<t>` and `<stnpc>`         |
| `exclusivemode on`     | `em on`       | Grants the ability to use exclusive mode.                                        |
| `exclusivemode off`    | `em off`      | Removes the ability to use exclusive mode.                                       |
| `exclusivemode main`   | `em main`     | Sets exclusive mode to only bind/display main WS's. (only works if `em` is on)   |
| `exclusivemode ranged` | `em ranged`   | Sets exclusive mode to only bind/display ranged WS's. (only works if `em` is on) |

### Repositioning the UI
You can move the UI by holding control and clicking/dragging it with your mouse.

### Changing keybinds

You must load the addon in game at least once for settings files to be created for you, then you can edit them.

**Important if customizing keybinds**
The keybinds for main hand weapon skills and ranged weapon skills should be mutually exclusive. There should be no overlap between the Archery or Marksmanship category and any of the others. Archery and Marksmanship can have the same keybinds as each other though. The reason for this is so that you can use main weapon WS keybinds and ranged WS keybinds at the same time.

You can change the the keybinds by editing the `user_ws_binds` table in the `data/user-binds.lua` file. If you edit the `default_ws_binds` table in `statics.lua`, that will work temporarily but will be reset to original values the next time this addon is updated. Please only use that one as a reference. The syntax is as follows:
```
user_ws_binds = {
  ['Weapon Category'] = {
    ['Default'] = {
      ['keybind1'] = "WS Name",
      ['keybind2'] = "WS2 Name",
    },
    ['JOB'] = {
      ['keybind1'] = "WS3 Name",
    },
    ['JOB/SUB'] = {
      ['keybind1'] = "WS4 Name",
    },
  },
}

Note: Braces and quotes are required around keys that contain a space or special character like `["GEO/WHM"]` (correct) vs `GEO/WHM` (incorrect) or `["Great Sword"]` (correct) vs `Great Sword` (incorrect).

```
| Key/Value         | Description                |
| ----------------- | -------------------------- |
| `Weapon Category` | This must be a weapon type such as `Dagger`, `Hand-to-Hand`, etc. **This is case sensitive.** |
| `All`             | There should always be an `All` table for each weapon type. Keybinds in this table are applied for all jobs. |
| `JOB` | This value should be an actual job 3-character abbreviation such as `MNK`, `RNG`, etc. These keybinds only apply if the specified job is set as your main job |
| `JOB/SUB`         | Same as `JOB` except the keybinds in this table only apply if both your main job and subjob match the table's key. |
| `keybind`         | Each keybind may be either a single key or a modifier+key. For a list of valid modifiers and keys see the `statics.lua` file for `valid_keybind_modifiers` and `valid_keybinds` |
| `WS Name`         | Must be a valid WS name. **This is case sensitive.** |

The weapon category's bindings will be merged in the following order: All -> Main Job -> Main/Sub Combo.
The player's current main job and sub job are used for matching, and non-matching job definitions will be ignored. The `All`
bindings will apply for all jobs. In other words, the most specific definitions will override the others. A Main/Sub combo is obviously the most specific. If you want to "unset" a binding from the `All` table for a specific job, you can create a keybind in that job's table with the same keybind key but leave the WS blank.

The order in which they are defined in your table does not matter. Overrides will always go in the order described above.

You may use as many keybinds per category as you like. The default categories only include 9 keybinds per weapon type in order to fit on the numpad, but you may have more than that.

Modifiers (such as ALT and CTRL) are optional, but the following are supported:

| Key/Value | AKA                      | Notes                                                        |
| --------- | ------------------------ |------------------------------------------------------------ |
| `CTRL`    | Control                  | Must put a `+` between modifier and the key (e.g. `CTRL+F`)  |
| `ALT`     |                          | Must put a `+` between modifier and the key (e.g. `ALT+F`)   |
| `WIN`     | Windows key              | Must put a `+` between modifier and the key (e.g. `WIN+F`)   |
| `APPS`    | Btn left of `right ctrl` | Must put a `+` between modifier and the key (e.g. `APPS+F`)  |
| `SHIFT`   |                          | Must put a `+` between modifier and the key (e.g. `SHIFT+F`) |
| `^`       | CTRL                     | Must NOT put a `+` modifier and the key (e.g. `^F`)          |
| `!`       | ALT                      | Must NOT put a `+` modifier and the key (e.g. `!F`)          |
| `@`       | WIN                      | Must NOT put a `+` modifier and the key (e.g. `@F`)          |
| `#`       | APPS                     | Must NOT put a `+` modifier and the key (e.g. `#F`)          |
| `~`       | SHIFT                    | Must NOT put a `+` modifier and the key (e.g. `~F`)          |

### Changing targeting mode

If you want to use `<stnpc>` targeting instead of the default `<t>` for your weaponskills you can change this in one of two ways:
1. Issue a command in game (in chat window). You can use separate targeting mode for main hand WS's vs ranged WS's:
```
//wsb tm main
```
or
```
//wsb tm ranged
```
2. Change the values in the `data/settings.xml` file.

## Debugging Tips

If any of your job luas have a "bind" or an "unbind" command that overlaps with any of the ws keybinds you have defined, you will run into an issue where switching jobs results some of your keybinds not setting properly. It is up to you to ensure there is no overlap in keybinds.
