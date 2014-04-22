#MacroPoetry
The Quintessential Macro Add-on for ESO (The Elder Scrolls Online.)

###Usage:
This Add-on is very powerful.
It aims to bring the full macro experience to ESO, reminiscient of the macro systems from SWG, FFXI, EQ/2 and even WOW to a certain degree.
Since it is possible to create long sequences with very long delays between commands, and is also possible to execute those in multiplicate:
this add-on has a Dump button to empty the command queue. (*You can crash your game by firing off too many overlapping macros if you're not careful.*)

Designed to be intuitive and fully featured, I will make whatever improvements can be made (API,) or might be made (features+) to this in the future.

As I'm sure you're aware: ESO Add-Ons are not permitted to post directly to chat channels for security reasons.
Except in the case of **emotes**, and **internally parsed addon commands** with which we can sneak by, this is a definite, (but necessary,) limitation.
For chats and standard game-related slash commands, instead, this add-on populates the chat input with all the correct info after which you need only
press "Enter,Enter" (enter twice) to send the appropriate message to the appropriate channel.
Beyond that, you do not need to activate or otherwise concern yourself with the chat input in regard to this add-on.

### Main Addon Commands:
*Chat Commands*

    /macro
        Toggle Add-On visibility

    /emotes
        List of all in-game performable emotes.

    /echo [anything]
        Echo something to the console. This can be helpful during boss fights for timing.

### Inside Macro Commands
*These are builtin commands, and will only work inside of macros.*

    /pause [seconds]
        Wait for this many seconds before executing the next command in the macro.

    /wait [seconds]
        **See /pause**

### Development:
- For the development version: be sure to rename the cloned/extracted directory to "MacroPoetry," (i.e. *-master to MacroPoetry.)
- Copy into ESO AddOns folder.

Repo: [https://github.com/archipoeta/eso-macropoetry](https://github.com/archipoeta/eso-macropoetry)

###Issues:
I will support this add-on, and address bugs here:
[https://github.com/archipoeta/eso-macropoetry/issues](https://github.com/archipoeta/eso-macropoetry/issues)