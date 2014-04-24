#MacroPoetry
The Quintessential Macro Add-on for ESO (The Elder Scrolls Online.)

###About:
This Add-on is very powerful.
It aims to bring the full macro experience to ESO, reminiscient of the macro systems from SWG, FFXI, EQ/2 and even WOW to a certain degree.
That means a macro editor which allows for multi-line multi-command editing, macro actionbar, and the ability to assign icons to the macro slots.

Designed to be intuitive and fully featured, I will make whatever improvements can be made (API,) or might be made (features+) to this in the future.

Since it is possible to create long sequences with very long delays between commands, and is also possible to execute those in multiplicate:
this add-on has a Dump button to empty the command queue. (*You can lag your game by queueing up too many macro commands if you're not careful.*)

As I'm sure you're aware: ESO Add-Ons are not permitted to post directly to chat channels for security reasons.

Except in the case of **emotes**, and **internally parsed addon commands** with which we can sneak by, this is a definite, (but necessary,) limitation.

For chats and standard game-related slash commands, instead, this add-on populates the chat input with all the correct info after which you need only
press "Enter,Enter" (enter twice) to send the appropriate message to the appropriate channel.
Beyond that, you do not need to activate or otherwise concern yourself with the chat input in regard to this add-on.

###Main Addon Commands:
*Chat Commands*

    /macro
        Toggle Add-On visibility

	/macro [number]
		Execute the macro in a given slot number.

    /emotes
        List of all in-game performable emotes.

	/dump
		Empty the pending command queue.

    /echo [anything]
        Echo something to the console. This can be helpful during boss fights for timing.

	/mail [to] [subject] [body]
		Send an in-game mail to another player.

	/money
		Display your gold on-hand and in the bank.

	/playtime
		Display the total time played.

	/repair
		Attempt to repair all equipment.
		This only works if you have a kit, or are in the merchant interface.

	/repaircost
		Display how much the total repairs are going to cost.

	/whereami
		Display the current Region/Area.

	/whoami
		Who are you really?

###Inside Macro Commands
*These are builtin commands, and will only work inside of macros.*

	/loop
		**See /repeat**

    /pause [seconds]
        Wait for this many seconds before executing the next command in the macro.

	/pause [min],[max]
		Wait for a random number of seconds between range min-max (inclusive.)

    /wait [seconds]
        **See /pause**

    /wait [min],[max]
        **See /pause**

	/repeat
		Start the macro over again from the begining. (Technically requeue for execution.)
		*BE CAREFUL WITH THIS* -- /dump is your best friend here!

###Development:
- For the development version: be sure to rename the cloned/extracted directory to "MacroPoetry," (i.e. *-master to MacroPoetry.)
- Copy into ESO AddOns folder.

Repo: [https://github.com/archipoeta/eso-macropoetry](https://github.com/archipoeta/eso-macropoetry)

###Issues:
I will support this add-on, and address bugs here:
[https://github.com/archipoeta/eso-macropoetry/issues](https://github.com/archipoeta/eso-macropoetry/issues)

###Planned Features:
* per macro, unique slot hover and text color
* easy color name parsing inside macros, (i.e. {blue})
* internal command to other addons' methods mapping, (i.e. /iv -> WF_ImageViewerWindow())