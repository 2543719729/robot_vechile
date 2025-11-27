
"use strict";

let robot_tts = require('./robot_tts.js')
let robot_iat = require('./robot_iat.js')
let up_sync = require('./up_sync.js')
let Control = require('./Control.js')
let Nav = require('./Nav.js')
let robot_semanteme = require('./robot_semanteme.js')
let Awake = require('./Awake.js')
let Collect = require('./Collect.js')

module.exports = {
  robot_tts: robot_tts,
  robot_iat: robot_iat,
  up_sync: up_sync,
  Control: Control,
  Nav: Nav,
  robot_semanteme: robot_semanteme,
  Awake: Awake,
  Collect: Collect,
};
