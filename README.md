# CKS-E

**What Is This?**

CKS-E is a tool that allows you to remap and redirect user input to one or more applications. Its primary use case is for triggering repetitive actions in games such as World of Warcraft but there are many possible uses.

**So How Is This Different From CKS?**

CKS-E has a number of changes:

* Listen To Joypad - Joypad input can be detected and remapped.
* Networking - CKS-E can be used to send detected input on one computer to trigger actions on another. Work on a laptop while your desktop does MMO crafting!
* Load/Save profiles - Configs can be simply saved and loaded to and from their own files.
* Key Up/Down Emulation - CKS-E allows you to configure an interval between key down and up events.
* Lower CPU Usage - CKS wasn't exactly a CPU hog but CKS-E uses far less CPU when listening to analogue inputs.
* Various minor bugs fixed.

Note that CKS-E has also removed some features:

* Multiple key strokes per input - removed for better WoW TOS compliance. Open for discussion if people provide use cases showing a need.
* Auto Refresh Program List - removed because I couldn't find anyone who used it and I needed the UI space.
* Coord Spy - seemed rarely used and a difficult area for TOS compliance.

**What Does The 'E' Stand For?**

Nothing. I mean you could think of it as Extended or Evolved or Expanded or Extant but it's just a way to flag that this isn't CKS. The CKS doesn't stand for Consortium Key Sender either as I've never even been a member of those forums.

**You've Stolen The Code And Claimed It As Your Own!**

I'm not hiding the origin of the application. I've included an attribution and a link to the original. As stands I've rewritten pretty much every part of the code and most of what was there is stuff that is freely available on AutoHotkey forums as example code anyway. The original hasn't been updated or actively supported in many years and was posted without a licence. It's not my intention to steal anything here. I just wanted some more features and to have a proper repository and central location for a tool that is fairly important to the WoW goldmaking community.

# Usage/Notes for Alpha

**General**

This is an alpha. That means it's mostly working but not a finished release. I'm putting it out for user testing and feedback. So: 

* Do expect some issues and rough edges. 
* Do please give feedback via the issues list or on the woweconomy discord tools/addons channel: http://discord.gg/woweconomy
* Don't rely on this working or staying the same.

I've put notes about some specifics that I'll be looking at altering/improving in future so please have at least a skim before giveing any non-specific feedback about a feature needing improvement. I particularly don't need to know that the UI is too spaced out or misaligned. :)

**Listening Options**

Inputs are treated as digital or analogue. Digital inputs are essentially buttons/keys. Digital inputs are detected immediately and cause an output to be fired immediately *if an output slot is ready*. Analogue inputs are polled every 50ms for changes. (Yes, this means you can't fire keys based on mouse movement more than 20x a second. Do you want to?)

* Listen to Mouse - Should listen to mouse movement and mouse scroll as analogue inputs. I haven't put mouse clicks in yet.
* Listen to Keyboard - As CKS. These inputs are treated as digital.
* Listen to User Input - This uses an underlying AutoHotKey value giving the time of the last physical input. It is polled in the same way that analogue inputs are.
* Listen to Joypad - Should listen to all attached joypads/joysticks. Analogue inputs are treated as analogue, buttons as digital. Note that detection occurs when you activate the option so you'll need to uncheck and recheck the option to redetect. I'll look into auto detect and some sort of notification.

* Mirror Keys - I haven't intentionally changed this from the "Mimic" option in CKS but it may be different. Seems odd to me right now anyway as it will send printable keys to the output but also trigger the mapped keys for non-printable inputs. I need to look into how the original worked and how people want this to work. Feedback welcome.

*General Keyboard Listening Note* - both the original CKS and this app cause some sort of interference with key combos on my computers. Things like Alt-Tab and Shift-Arrow selection get interrupted. I'll be looking into possible fixes for this but it may be just down to AutoHotKey.

**Output Options**

* Output Intervals - Sets the gap between allowed output periods in seconds. Output will be allowed at a random point between the low and high values.
* Keypress Length - Sets the time between the Key Down and Key Up events if the emulation option is ticked. Also randomly picked between the low and high values in seconds.
* Keys to Send - Accepts a semi-colon delimited list of SINGLE keys. Non-printable keys should written out as with CKS but without the curly braces: e.g "1;2;3;4;5;6;Space". Very much open to discussion about how people want/need to use this.
  * Send In Sequence - As with CKS this will send each key in the list in turn.
  * Emulate Key Up/Down - activates the Keypress Length options.
  
**Network Options**

*Server IP/Port* - The IP is initialised to the detected IP of the first found network interface. Set the IP on the client to point at the server but be aware that the detected IP may not be the correct one if you have several network interfaces active. 
*Act As Server* - Have this instance of CKS act as a... server!

How To: 

The client is the computer you want to by detecting your input. The server is the computer you want to be firing keys at another application. The client input listening is defined on the client and the server outputs will be defined by the settings on the server.

1. Set the port on client and server to the same number on an open port that isn't in use (I use 29999).
2. Set the client IP entry to the server's actual IP address.
3. Check the "Act As Server" option on the server and click the button that should now say "Listen".
4. Click the "Connect" button on the client.

If all goes well the status line should tell you you're connected and give updates when events are fired.

**Networking Discussion**

I went back and forth over releasing this feature as I really, really don't want to be providing networking support. I'll certainly try to help people in the early stages and to make it all easier to use in the final release but if you're completely networking clueless and/or have a strange home network I can't promise this will work for you.

For those worried about security all this does is listen on the given port and treat any data packet received as if it were an input. By design the server won't do anything other than fire the input events you define and actually ignores any data in the packets sent to it. That said, please don't do anything silly like open up your router to the world to operate this from work. In the future I may look into a simple password encryption if I allow the client to dictate the output.
