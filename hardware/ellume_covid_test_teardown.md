# Ellume Covid Test Teardown

_Originally Posted: [2021-07-21](https://twitter.com/netspooky/status/1417721950881959938)_

I bought one of these today because I needed to take a test. It was the only one at CVS and it was disappointing because it required me to link with a phone to get my results. Let's see what's inside:

![image](https://user-images.githubusercontent.com/26436276/209997590-19cfbbca-b4a6-43cf-9806-41caf2818127.png)

The test itself is pretty standard. You do the nose thing, dip in some fluid, then squirt into The Hole. Pair with your phone and some weird app with weird reviews, and boom, helth

![image](https://user-images.githubusercontent.com/26436276/209997632-c4ff6d59-f0f6-46b0-abe1-2f06c99b65d5.png)

You can very easily pry it apart with a screw driver, revealing a small board with a plastic housing attached, and a lil coin battery

![image](https://user-images.githubusercontent.com/26436276/209997679-af82caa0-401a-4059-8f56-2f39f43f6380.png)

Pop off the housing to reveal that it's just a test strip being read by some circuit that shines light and reads the strip. It's pretty straight forward, but also annoying that this whole contraption was $40USD and required me to download an app and give them all my info.

![image](https://user-images.githubusercontent.com/26436276/209997714-67ec3f5e-d1fb-4def-a378-d26d906ff08a.png)

![image](https://user-images.githubusercontent.com/26436276/209997719-dfd2a4c6-4a72-4b4e-b95f-010fd2870dca.png)

On the plus side, you do get a nice Nordic Semiconductor nRF52810 and test pads to reprogram it if you want to play around with BLE. It's got an ARM Cortex M4 and a 2.4 GHz transciever. It's a shame it's meant to be thrown away, you can have a lot of fun with this.

![image](https://user-images.githubusercontent.com/26436276/209998039-b2232172-9008-402f-b7ba-3d211eb9e2ca.png)

tl;dr - You can rip the test strip out instead of giving your data to some dodgy company, and you get a BLE SoC to mess around with. 

Also I tested negative 🎉

For those wondering, here is the backside of the board. So many test pads! Also I labeled the main test pads near the battery after tracing from the datasheet if you want to reprogram using SWD. Have fun!

![image](https://user-images.githubusercontent.com/26436276/209997784-1f101ad6-64f7-4d61-997c-518c1f1e4b84.png)

![image](https://user-images.githubusercontent.com/26436276/209997793-c9787707-93d1-4b74-8343-210326553f82.png)

![image](https://user-images.githubusercontent.com/26436276/209997807-43323e00-c79b-468f-87b4-ed66146f2f82.png)

Additionally, [black0wl](https://twitter.com/b1ack0wl/status/1417991582444310528) found that there's some funky stuff going on on the company's website that probably came from a vulnerable wordpress plugin.

![image](https://user-images.githubusercontent.com/26436276/209997902-d2dae350-aabf-4e16-bd8a-95780ae315bc.png)

Also someone else did a more in depth teardown here: https://routevegetable.com/covid-test-2/
