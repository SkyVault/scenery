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
    scenes: seq[T] = @[low(T)]
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
    state = loading

  proc activeScene*(): T =
    if len(scenes) == 0:
      default(T)
    else:
      scenes[^1]

  proc reset*() =
    state = loading

  template loadingScene(body: untyped): untyped =
    if state == loading:
      let sceneId {.inject.} = activeScene()
      state = updating
      body

  template updatingScene(body: untyped): untyped =
    if state == updating:
      let sceneId {.inject.} = activeScene()
      state = drawing
      body

  template drawingScene(body: untyped): untyped =
    if state == drawing:
      let sceneId {.inject.} = activeScene()
      state = updating
      body

  template unloadingScene(body: untyped): untyped =
    if state == unload:
      let sceneId {.inject.} = unload
      body
      unload = default(T)
