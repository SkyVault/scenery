import unittest
import scenery

test "can load scenes":
  var wasCalled = false
  switchScene SceneId("menu")
  sceneLoad do(id: SceneId):
    check isSceneActive(id)
    wasCalled = true
  check wasCalled

test "can update scenes":
  var wasCalled = false
  switchScene SceneId("menu")

  sceneLoad do(id: SceneId):
    discard

  sceneUpdate do(id: SceneId):
    check isSceneActive(id)
    wasCalled = true

  check wasCalled

test "can draw scenes":
  var wasCalled = false
  switchScene SceneId("menu")

  sceneLoad do(id: SceneId):
    discard

  sceneUpdate do(id: SceneId):
    discard

  sceneDraw do(id: SceneId):
    check isSceneActive(id)
    wasCalled = true

  check wasCalled
