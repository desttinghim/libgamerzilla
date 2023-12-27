# LibGamerzilla
 
Library to interact with gamerzilla plugin for hubzilla.

To build - cmake and make. To install, make install.

## FOR GAME DEVELOPERS

At the start of your game call the GamerzillaStart, GamerzillaInitGame
and GamerzillaSetGame functions. The first should be called with server
argument set to false and the saveDir a directory to save achievements
when offline.

```c
GamerzillaStart(false, "save/");
````

GamerzillaInitGame will clear the Gamerzilla structure which is needed
for GamerzillaSetGame. GamerzillaSetGame will make a copy of the
structure so it can be destroyed after calling the function. The
function returns a game ID which you will need to pass into other
functions.

```c
Gamerzilla g;
GamerzillaTrophy trophy[1];
GamerzillaInitGame(&g);
g.short_name = strdup("test");
g.name = strdup("Test");
g.image = strdup("test.png");
g.version = 1;
g.numTrophy = 1;
g.trophy = trophy;
trophy[0].name = strdup("Win Game");
trophy[0].desc = strdup("Win Game");
trophy[0].max_progress = 0;
int game_id = GamerzillaSetGame(&g);
```

Version number must be greater than zero. You are not allowed to remove
trophies. All future versions should only add new trophies.

When the game is shutting down, you can call GamerzillaQuit to clean up
memory.

```c
GamerzillaQuit();
```

During the game you can call GamerzillaSetTophy and
GamerzillaSetTophyStat to record information about trophies. Setting the
stat for a trophy sets it to a new value. If you want to add to a
previous value you will need to retrieve it with
GamerzillaGetTrophyStat.

```c
GamerzillaSetTophy(game_id, "Win Game");
int progress;
GamerzillaGetTrophyStat(game_id, "Slayer", &progress)
GamerzillaSetTophyStat(game_id, "Slayer", progress + 2);
```

All of this assumes you are working offline or connecting to a local
process to update your trophies online. It is possible to connect
directly from the game instead. Before you call GamerzillaGameInit, you
must call GamerzillaConnect.

```c
GamerzillaConnect("http://yourhuzilla.com/", "username", "password");
```

The recommended use to a local game manager instead of connecting
directly.

## FOR GAME MANAGERS

The interface for game managers is not entirely fleshed out yet. You
will need to call GamerzillaInit. The first argument is true and the
second will store all trophy information when offline.

```c
GamerzillaStart(true, "./server/");
```

Assuming you want to update online information, you will then need to
call GamerzillaConnect.

```c
GamerzillaConnect("http://yourhuzilla.com/", "username", "password");
```

After that you must periodically call the GamerzillaServerProcess
function. You could dedicate a thread to performing this task or call it
will a timeout value.

```c
while (true)
{
    GamerzillaServerProcess(NULL);
}
```
