# WSBinder
FFXI Windower v4 addon that dynamically binds weapon skills based on currently-equipped weapon and current job/sub job by pulling from pre-defined table.

## Descripton

Provides weaponskill keybinds that change dynamically based on your current weapon. This function has the
following benefits:
- Easily use multiple weapons on one job. For example, having a dagger equipped will allow you to
use 9 buttons for dagger weaponskills, and then changing your weapon to a sword will automatically unbind those
dagger WS keybinds and then set your sword keybinds.
- Use common keybinds for a specific weapon regardless of your job (but with the ability to customize it per job).
- Have all your keybinds defined in one place instead of in each individual job file.
- Use main-hand and ranged WS keybinds at the same time (if defined without keybind overlap), or enable a toggle to share keybinds (see "exclusive mode").

Override functionality is included so that you can define your own keybinds in a global file without having
to modify this library lua.

## Implementation

1. Create a folder in your Windower/addons folder and name it `WSBinder`.
2. Place all files from this repository into the `WSBinder` folder.
3. (Optional) Enable automatic loading of this addon when you log in. In the file Windower/scripts/init.txt add the following to the bottom:
```
lua load WSBinder
```

## Usage

### Addon Commands

There are some commands you can use to interact with the WSBinder addon from in-game chat. Commands follow the format of `//wsb <commands>` (without brackets <>). The following are valid commands:
| Command           | Alt Cmd     | Description                                                              |
| ----------------- | ----------- | ------------------------------------------------------------------------ |
| `help`            | `h`         | Prints out a bunch of helpful messages in the chat log                   |
| `targetmode main` | `tm m`      | Toggles the target mode for main hand WS's between `<t>` and `<stnpc>`   |
| `targetmode main` | `tm m`      | Toggles the target mode for ranged hand WS's between `<t>` and `<stnpc>` |
| `reload`          | `r`         | Toggles the target mode for ranged hand WS's between `<t>` and `<stnpc>` |


### Changing keybinds

You can change the default keybinds by editing the `ws_binds` table in the `keybind_map.lua` file. The syntax is as follows:
```
ws_binds = {
  ['Weapon Category'] = {
    ['Default'] = {
      ['keybind1'] = "WS Name",
      ['keybind2'] = "WS2 Name",
    },
    ['JOB'] = {
      ['keybind1'] = "WS3 Name",
    },
    ['/SUB'] = {
      ['keybind1'] = "WS4 Name",
    },
    ['JOB/SUB'] = {
      ['keybind1'] = "WS4 Name",
    },
  },
}
```

The category's bindings will be merged in the following order: Default -> Main Job -> Sub Job -> Main Job/Sub Job Combo.
The player's current main job and sub job are used for matching and non-matching job definitions will be ignored. Default
bindings will apply for all jobs.

In other words, the most specific definitions will overwrite all the others. A Job/Sub combo is obviously the most specific.

The order in which they are defined in your table does not matter. Overwrites will always go in the order described above.

To use a sub job binding the key must begin with '/'. For example, '/NIN' will apply those bindings if your sub job is Ninja.

The 'Default' key is case-sensitive, you must use a capital 'D'. The job and sub job keys are not case sensitive.

**Important if overriding keybinds**
The keybinds for main hand weapon skills and ranged weapon skills should be mutually exclusive. There should be no overlap between the Archery category + Marksmanship category and any of the others. Archery and Marksmanship can have the same keybinds as each other though.

### Changing targeting mode

If you want to use `<stnpc>` targeting instead of the default `<t>` for your weaponskills you can change this by issuing a command in game (in chat window). You can use separate targeting mode for main hand WS's vs ranged WS's:
```
//wsb tm main
```
or
```
//wsb tm ranged
```

## Debugging Tips

If any of your job luas have a "bind" or an "unbind" command that overlaps with any of the ws keybinds you have defined, you will run into an issue where switching jobs results some of your keybinds not setting properly. It is up to you to ensure there is no overlap in keybinds.

## Known Issues

* Throws errors on login before fully loaded.
* Throws error when changing jobs or weapons if player has no sub job.
* Potential overflow error if `frame_count` reaches max int size.