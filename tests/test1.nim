import unittest
import scenery, macros

defScenes(S) do:
  menu
  game
  settings

test "can load scenes":
  reset()
  var called = false
  loadingScene do(id: S): called = true
  check called

test "can update scenes":
  reset()
  var called = false
  loadingScene do(id: S): discard
  updatingScene do(id: S): called = true
  check called

test "can draw scenes":
  reset()
  var called = false
  loadingScene do(id: S): discard
  updatingScene do(id: S): discard
  drawingScene do(id: S): called = true
  check called
