// Auto-generated. Do not edit!

// (in-package third_pkg.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class myTestMsg {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.name = null;
      this.age = null;
      this.handsome = null;
      this.salary = null;
    }
    else {
      if (initObj.hasOwnProperty('name')) {
        this.name = initObj.name
      }
      else {
        this.name = '';
      }
      if (initObj.hasOwnProperty('age')) {
        this.age = initObj.age
      }
      else {
        this.age = 0;
      }
      if (initObj.hasOwnProperty('handsome')) {
        this.handsome = initObj.handsome
      }
      else {
        this.handsome = false;
      }
      if (initObj.hasOwnProperty('salary')) {
        this.salary = initObj.salary
      }
      else {
        this.salary = 0.0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type myTestMsg
    // Serialize message field [name]
    bufferOffset = _serializer.string(obj.name, buffer, bufferOffset);
    // Serialize message field [age]
    bufferOffset = _serializer.uint16(obj.age, buffer, bufferOffset);
    // Serialize message field [handsome]
    bufferOffset = _serializer.bool(obj.handsome, buffer, bufferOffset);
    // Serialize message field [salary]
    bufferOffset = _serializer.float32(obj.salary, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type myTestMsg
    let len;
    let data = new myTestMsg(null);
    // Deserialize message field [name]
    data.name = _deserializer.string(buffer, bufferOffset);
    // Deserialize message field [age]
    data.age = _deserializer.uint16(buffer, bufferOffset);
    // Deserialize message field [handsome]
    data.handsome = _deserializer.bool(buffer, bufferOffset);
    // Deserialize message field [salary]
    data.salary = _deserializer.float32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += _getByteLength(object.name);
    return length + 11;
  }

  static datatype() {
    // Returns string type for a message object
    return 'third_pkg/myTestMsg';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '6ece56ce03fa8153af604f79dc40b971';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    string name
    uint16 age
    bool handsome
    float32 salary
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new myTestMsg(null);
    if (msg.name !== undefined) {
      resolved.name = msg.name;
    }
    else {
      resolved.name = ''
    }

    if (msg.age !== undefined) {
      resolved.age = msg.age;
    }
    else {
      resolved.age = 0
    }

    if (msg.handsome !== undefined) {
      resolved.handsome = msg.handsome;
    }
    else {
      resolved.handsome = false
    }

    if (msg.salary !== undefined) {
      resolved.salary = msg.salary;
    }
    else {
      resolved.salary = 0.0
    }

    return resolved;
    }
};

module.exports = myTestMsg;
