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

class car_data {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.speed = null;
      this.crash = null;
      this.infrared = null;
      this.ultrasonic = null;
      this.smoke = null;
      this.power_voltage = null;
      this.mpu = null;
      this.tempareture = null;
      this.humidity = null;
    }
    else {
      if (initObj.hasOwnProperty('speed')) {
        this.speed = initObj.speed
      }
      else {
        this.speed = [];
      }
      if (initObj.hasOwnProperty('crash')) {
        this.crash = initObj.crash
      }
      else {
        this.crash = [];
      }
      if (initObj.hasOwnProperty('infrared')) {
        this.infrared = initObj.infrared
      }
      else {
        this.infrared = [];
      }
      if (initObj.hasOwnProperty('ultrasonic')) {
        this.ultrasonic = initObj.ultrasonic
      }
      else {
        this.ultrasonic = [];
      }
      if (initObj.hasOwnProperty('smoke')) {
        this.smoke = initObj.smoke
      }
      else {
        this.smoke = 0;
      }
      if (initObj.hasOwnProperty('power_voltage')) {
        this.power_voltage = initObj.power_voltage
      }
      else {
        this.power_voltage = 0;
      }
      if (initObj.hasOwnProperty('mpu')) {
        this.mpu = initObj.mpu
      }
      else {
        this.mpu = [];
      }
      if (initObj.hasOwnProperty('tempareture')) {
        this.tempareture = initObj.tempareture
      }
      else {
        this.tempareture = 0.0;
      }
      if (initObj.hasOwnProperty('humidity')) {
        this.humidity = initObj.humidity
      }
      else {
        this.humidity = 0.0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type car_data
    // Serialize message field [speed]
    bufferOffset = _arraySerializer.float64(obj.speed, buffer, bufferOffset, null);
    // Serialize message field [crash]
    bufferOffset = _arraySerializer.uint16(obj.crash, buffer, bufferOffset, null);
    // Serialize message field [infrared]
    bufferOffset = _arraySerializer.uint16(obj.infrared, buffer, bufferOffset, null);
    // Serialize message field [ultrasonic]
    bufferOffset = _arraySerializer.uint16(obj.ultrasonic, buffer, bufferOffset, null);
    // Serialize message field [smoke]
    bufferOffset = _serializer.uint16(obj.smoke, buffer, bufferOffset);
    // Serialize message field [power_voltage]
    bufferOffset = _serializer.uint16(obj.power_voltage, buffer, bufferOffset);
    // Serialize message field [mpu]
    bufferOffset = _arraySerializer.float32(obj.mpu, buffer, bufferOffset, null);
    // Serialize message field [tempareture]
    bufferOffset = _serializer.float32(obj.tempareture, buffer, bufferOffset);
    // Serialize message field [humidity]
    bufferOffset = _serializer.float32(obj.humidity, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type car_data
    let len;
    let data = new car_data(null);
    // Deserialize message field [speed]
    data.speed = _arrayDeserializer.float64(buffer, bufferOffset, null)
    // Deserialize message field [crash]
    data.crash = _arrayDeserializer.uint16(buffer, bufferOffset, null)
    // Deserialize message field [infrared]
    data.infrared = _arrayDeserializer.uint16(buffer, bufferOffset, null)
    // Deserialize message field [ultrasonic]
    data.ultrasonic = _arrayDeserializer.uint16(buffer, bufferOffset, null)
    // Deserialize message field [smoke]
    data.smoke = _deserializer.uint16(buffer, bufferOffset);
    // Deserialize message field [power_voltage]
    data.power_voltage = _deserializer.uint16(buffer, bufferOffset);
    // Deserialize message field [mpu]
    data.mpu = _arrayDeserializer.float32(buffer, bufferOffset, null)
    // Deserialize message field [tempareture]
    data.tempareture = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [humidity]
    data.humidity = _deserializer.float32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += 8 * object.speed.length;
    length += 2 * object.crash.length;
    length += 2 * object.infrared.length;
    length += 2 * object.ultrasonic.length;
    length += 4 * object.mpu.length;
    return length + 32;
  }

  static datatype() {
    // Returns string type for a message object
    return 'bobac3_msgs/car_data';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '2cce16e01821bbf3f6a71093439b392f';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    float64[] speed
    uint16[] crash
    uint16[] infrared
    uint16[] ultrasonic
    uint16 smoke
    uint16 power_voltage
    float32[] mpu
    float32 tempareture
    float32 humidity
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new car_data(null);
    if (msg.speed !== undefined) {
      resolved.speed = msg.speed;
    }
    else {
      resolved.speed = []
    }

    if (msg.crash !== undefined) {
      resolved.crash = msg.crash;
    }
    else {
      resolved.crash = []
    }

    if (msg.infrared !== undefined) {
      resolved.infrared = msg.infrared;
    }
    else {
      resolved.infrared = []
    }

    if (msg.ultrasonic !== undefined) {
      resolved.ultrasonic = msg.ultrasonic;
    }
    else {
      resolved.ultrasonic = []
    }

    if (msg.smoke !== undefined) {
      resolved.smoke = msg.smoke;
    }
    else {
      resolved.smoke = 0
    }

    if (msg.power_voltage !== undefined) {
      resolved.power_voltage = msg.power_voltage;
    }
    else {
      resolved.power_voltage = 0
    }

    if (msg.mpu !== undefined) {
      resolved.mpu = msg.mpu;
    }
    else {
      resolved.mpu = []
    }

    if (msg.tempareture !== undefined) {
      resolved.tempareture = msg.tempareture;
    }
    else {
      resolved.tempareture = 0.0
    }

    if (msg.humidity !== undefined) {
      resolved.humidity = msg.humidity;
    }
    else {
      resolved.humidity = 0.0
    }

    return resolved;
    }
};

module.exports = car_data;
