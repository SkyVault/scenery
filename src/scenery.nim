import tables, sets, hashes

type
  SceneId* = distinct string
  SceneState = enum
    loading
    updating
    drawing
    unloading

var
  scenes = @[SceneId("")]
  state = loading

proc `==`*(a, b: SceneId): auto = a.string == b.string
proc hash*(s: SceneId): auto = hash(s.string)
proc `$`*(s: SceneId): auto = s.string

var
  sceneIds {.compileTime.} = initHashSet[SceneId]()

proc isSceneActive*(sceneId: SceneId): bool =
  scenes[^1] == sceneId

proc switchScene*(scene: SceneId) =
  scenes[^1] = scene
  state = loading

proc pushScene*(scene: SceneId) =
  scenes.add(scene)
  state = loading

proc popScene*(): auto {.discardable.} =
  if scenes.len() == 1:
    scenes[0] = SceneId("")
    scenes[0]
  else:
    scenes.pop()

template sceneLoad*(body: untyped) =
  let scene = scenes[^1]

  if scene != SceneId("") and state == loading:
    body(scene)
    state = updating

template sceneUpdate*(body: untyped) =
  let scene = scenes[^1]

  if scene != SceneId("") and state == updating:
    body(scene)
    state = drawing

template sceneDraw*(body: untyped) =
  let scene = scenes[^1]

  if scene != SceneId("") and state == drawing:
    body(scene)
    state = updating
