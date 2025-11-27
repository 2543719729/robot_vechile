// Auto-generated. Do not edit!

// (in-package bobac3_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class car_cmd {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.speed = null;
      this.been = null;
    }
    else {
      if (initObj.hasOwnProperty('speed')) {
        this.speed = initObj.speed
      }
      else {
        this.speed = [];
      }
      if (initObj.hasOwnProperty('been')) {
        this.been = initObj.been
      }
      else {
        this.been = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type car_cmd
    // Serialize message field [speed]
    bufferOffset = _arraySerializer.float64(obj.speed, buffer, bufferOffset, null);
    // Serialize message field [been]
    bufferOffset = _serializer.uint16(obj.been, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type car_cmd
    let len;
    let data = new car_cmd(null);
    // Deserialize message field [speed]
    data.speed = _arrayDeserializer.float64(buffer, bufferOffset, null)
    // Deserialize message field [been]
    data.been = _deserializer.uint16(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += 8 * object.speed.length;
    return length + 6;
  }

  static datatype() {
    // Returns string type for a message object
    return 'bobac3_msgs/car_cmd';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '5a353eb45570aedb9fa4844cc33fae72';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    float64[] speed
    uint16 been
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new car_cmd(null);
    if (msg.speed !== undefined) {
      resolved.speed = msg.speed;
    }
    else {
      resolved.speed = []
    }

    if (msg.been !== undefined) {
      resolved.been = msg.been;
    }
    else {
      resolved.been = 0
    }

    return resolved;
    }
};

module.exports = car_cmd;
