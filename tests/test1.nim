import unittest
import scenery, macros

defScenes(S) do:
  menu
  game
  settings

test "can load scenes":
  reset()
  var called = false
  loadingScene:
    check sceneId == menu
    called = true
  check called

test "can update scenes":
  reset()
  var called = false
  loadingScene: discard
  updatingScene: called = true
  check called

test "can draw scenes":
  reset()
  var called = false
  loadingScene: discard
  updatingScene: discard
  drawingScene: called = true
  check called
