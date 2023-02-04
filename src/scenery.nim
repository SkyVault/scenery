import std/macros, sugar, sequtils, strutils

type
  SceneState = enum
    loading
    updating
    drawing

macro genEnum*(T, xs: untyped): untyped =
  result = newEnum(
    name = ident($T),
    fields = sugar.collect(for x in xs: $x).mapIt(ident(it)),
    public = true,
    pure = false
  )

template defScenes*(T, xs: untyped): untyped =
  genEnum(T, xs)

  var
    scenes: seq[T] = @[]
    state = loading
    unload = default(T)

  proc isActive*(s: T): bool =
    if len(scenes) == 0: return false
    result = scenes[^1] == s

  proc pushScene*(s: T) =
    scenes.add(s)
    state = loading

  proc popScene*(s: T): auto {.discardable.} =
    result = scenes.pop()
    unload = result

  proc switchScene*(s: T): auto {.discardable.} =
    result = popScene(s)
    pushScene(s)

  proc activeScene*(): T =
    if len(scenes) == 0:
      default(T)
    else:
      scenes[^1]

  proc reset*() =
    state = loading

  template loadingScene(body: untyped): untyped =
    if state == loading:
      body(activeScene())
      state = updating

  template updatingScene(body: untyped): untyped =
    if state == updating:
      body(activeScene())
      state = drawing

  template drawingScene(body: untyped): untyped =
    if state == drawing:
      body(activeScene())
      state = updating

  template unloadingScene(body: untyped): untyped =
    if state == unload:
      body(unload)
      unload = default(T)
