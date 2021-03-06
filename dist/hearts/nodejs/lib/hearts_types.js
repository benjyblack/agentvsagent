//
// Autogenerated by Thrift Compiler (1.0.0-dev)
//
// DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
//
var Thrift = require('thrift').Thrift;

var ttypes = module.exports = {};
if (typeof AgentVsAgent === 'undefined') {
  AgentVsAgent = {};
}
ttypes.Suit = {
'CLUBS' : 21,
'DIAMONDS' : 22,
'SPADES' : 23,
'HEARTS' : 24
};
ttypes.Rank = {
'TWO' : 2,
'THREE' : 3,
'FOUR' : 4,
'FIVE' : 5,
'SIX' : 6,
'SEVEN' : 7,
'EIGHT' : 8,
'NINE' : 9,
'TEN' : 10,
'JACK' : 11,
'QUEEN' : 12,
'KING' : 13,
'ACE' : 14
};
ttypes.GameStatus = {
'NEXT_ROUND' : 1,
'END_GAME' : 2
};
AgentVsAgent.Card = module.exports.Card = function(args) {
  this.suit = null;
  this.rank = null;
  if (args) {
    if (args.suit !== undefined) {
      this.suit = args.suit;
    }
    if (args.rank !== undefined) {
      this.rank = args.rank;
    }
  }
};
AgentVsAgent.Card.prototype = {};
AgentVsAgent.Card.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.I32) {
        this.suit = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.I32) {
        this.rank = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

AgentVsAgent.Card.prototype.write = function(output) {
  output.writeStructBegin('Card');
  if (this.suit !== null && this.suit !== undefined) {
    output.writeFieldBegin('suit', Thrift.Type.I32, 1);
    output.writeI32(this.suit);
    output.writeFieldEnd();
  }
  if (this.rank !== null && this.rank !== undefined) {
    output.writeFieldBegin('rank', Thrift.Type.I32, 2);
    output.writeI32(this.rank);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

AgentVsAgent.Ticket = module.exports.Ticket = function(args) {
  this.agentId = null;
  if (args) {
    if (args.agentId !== undefined) {
      this.agentId = args.agentId;
    }
  }
};
AgentVsAgent.Ticket.prototype = {};
AgentVsAgent.Ticket.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.agentId = input.readString();
      } else {
        input.skip(ftype);
      }
      break;
      case 0:
        input.skip(ftype);
        break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

AgentVsAgent.Ticket.prototype.write = function(output) {
  output.writeStructBegin('Ticket');
  if (this.agentId !== null && this.agentId !== undefined) {
    output.writeFieldBegin('agentId', Thrift.Type.STRING, 1);
    output.writeString(this.agentId);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

AgentVsAgent.EntryRequest = module.exports.EntryRequest = function(args) {
  this.version = '0.0.16';
  if (args) {
    if (args.version !== undefined) {
      this.version = args.version;
    }
  }
};
AgentVsAgent.EntryRequest.prototype = {};
AgentVsAgent.EntryRequest.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.version = input.readString();
      } else {
        input.skip(ftype);
      }
      break;
      case 0:
        input.skip(ftype);
        break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

AgentVsAgent.EntryRequest.prototype.write = function(output) {
  output.writeStructBegin('EntryRequest');
  if (this.version !== null && this.version !== undefined) {
    output.writeFieldBegin('version', Thrift.Type.STRING, 1);
    output.writeString(this.version);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

AgentVsAgent.EntryResponse = module.exports.EntryResponse = function(args) {
  this.ticket = null;
  this.message = null;
  if (args) {
    if (args.ticket !== undefined) {
      this.ticket = args.ticket;
    }
    if (args.message !== undefined) {
      this.message = args.message;
    }
  }
};
AgentVsAgent.EntryResponse.prototype = {};
AgentVsAgent.EntryResponse.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRUCT) {
        this.ticket = new ttypes.Ticket();
        this.ticket.read(input);
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.STRING) {
        this.message = input.readString();
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

AgentVsAgent.EntryResponse.prototype.write = function(output) {
  output.writeStructBegin('EntryResponse');
  if (this.ticket !== null && this.ticket !== undefined) {
    output.writeFieldBegin('ticket', Thrift.Type.STRUCT, 1);
    this.ticket.write(output);
    output.writeFieldEnd();
  }
  if (this.message !== null && this.message !== undefined) {
    output.writeFieldBegin('message', Thrift.Type.STRING, 2);
    output.writeString(this.message);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

AgentVsAgent.GameInfo = module.exports.GameInfo = function(args) {
  this.position = null;
  if (args) {
    if (args.position !== undefined) {
      this.position = args.position;
    }
  }
};
AgentVsAgent.GameInfo.prototype = {};
AgentVsAgent.GameInfo.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.position = input.readString();
      } else {
        input.skip(ftype);
      }
      break;
      case 0:
        input.skip(ftype);
        break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

AgentVsAgent.GameInfo.prototype.write = function(output) {
  output.writeStructBegin('GameInfo');
  if (this.position !== null && this.position !== undefined) {
    output.writeFieldBegin('position', Thrift.Type.STRING, 1);
    output.writeString(this.position);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

AgentVsAgent.Trick = module.exports.Trick = function(args) {
  this.leader = null;
  this.played = null;
  if (args) {
    if (args.leader !== undefined) {
      this.leader = args.leader;
    }
    if (args.played !== undefined) {
      this.played = args.played;
    }
  }
};
AgentVsAgent.Trick.prototype = {};
AgentVsAgent.Trick.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.leader = input.readString();
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.LIST) {
        var _size0 = 0;
        var _rtmp34;
        this.played = [];
        var _etype3 = 0;
        _rtmp34 = input.readListBegin();
        _etype3 = _rtmp34.etype;
        _size0 = _rtmp34.size;
        for (var _i5 = 0; _i5 < _size0; ++_i5)
        {
          var elem6 = null;
          elem6 = new ttypes.Card();
          elem6.read(input);
          this.played.push(elem6);
        }
        input.readListEnd();
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

AgentVsAgent.Trick.prototype.write = function(output) {
  output.writeStructBegin('Trick');
  if (this.leader !== null && this.leader !== undefined) {
    output.writeFieldBegin('leader', Thrift.Type.STRING, 1);
    output.writeString(this.leader);
    output.writeFieldEnd();
  }
  if (this.played !== null && this.played !== undefined) {
    output.writeFieldBegin('played', Thrift.Type.LIST, 2);
    output.writeListBegin(Thrift.Type.STRUCT, this.played.length);
    for (var iter7 in this.played)
    {
      if (this.played.hasOwnProperty(iter7))
      {
        iter7 = this.played[iter7];
        iter7.write(output);
      }
    }
    output.writeListEnd();
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

AgentVsAgent.RoundResult = module.exports.RoundResult = function(args) {
  this.north = null;
  this.east = null;
  this.south = null;
  this.west = null;
  this.status = null;
  if (args) {
    if (args.north !== undefined) {
      this.north = args.north;
    }
    if (args.east !== undefined) {
      this.east = args.east;
    }
    if (args.south !== undefined) {
      this.south = args.south;
    }
    if (args.west !== undefined) {
      this.west = args.west;
    }
    if (args.status !== undefined) {
      this.status = args.status;
    }
  }
};
AgentVsAgent.RoundResult.prototype = {};
AgentVsAgent.RoundResult.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.I32) {
        this.north = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.I32) {
        this.east = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      case 3:
      if (ftype == Thrift.Type.I32) {
        this.south = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      case 4:
      if (ftype == Thrift.Type.I32) {
        this.west = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      case 5:
      if (ftype == Thrift.Type.I32) {
        this.status = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

AgentVsAgent.RoundResult.prototype.write = function(output) {
  output.writeStructBegin('RoundResult');
  if (this.north !== null && this.north !== undefined) {
    output.writeFieldBegin('north', Thrift.Type.I32, 1);
    output.writeI32(this.north);
    output.writeFieldEnd();
  }
  if (this.east !== null && this.east !== undefined) {
    output.writeFieldBegin('east', Thrift.Type.I32, 2);
    output.writeI32(this.east);
    output.writeFieldEnd();
  }
  if (this.south !== null && this.south !== undefined) {
    output.writeFieldBegin('south', Thrift.Type.I32, 3);
    output.writeI32(this.south);
    output.writeFieldEnd();
  }
  if (this.west !== null && this.west !== undefined) {
    output.writeFieldBegin('west', Thrift.Type.I32, 4);
    output.writeI32(this.west);
    output.writeFieldEnd();
  }
  if (this.status !== null && this.status !== undefined) {
    output.writeFieldBegin('status', Thrift.Type.I32, 5);
    output.writeI32(this.status);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

AgentVsAgent.GameResult = module.exports.GameResult = function(args) {
  this.north = null;
  this.east = null;
  this.south = null;
  this.west = null;
  if (args) {
    if (args.north !== undefined) {
      this.north = args.north;
    }
    if (args.east !== undefined) {
      this.east = args.east;
    }
    if (args.south !== undefined) {
      this.south = args.south;
    }
    if (args.west !== undefined) {
      this.west = args.west;
    }
  }
};
AgentVsAgent.GameResult.prototype = {};
AgentVsAgent.GameResult.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.I32) {
        this.north = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.I32) {
        this.east = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      case 3:
      if (ftype == Thrift.Type.I32) {
        this.south = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      case 4:
      if (ftype == Thrift.Type.I32) {
        this.west = input.readI32();
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

AgentVsAgent.GameResult.prototype.write = function(output) {
  output.writeStructBegin('GameResult');
  if (this.north !== null && this.north !== undefined) {
    output.writeFieldBegin('north', Thrift.Type.I32, 1);
    output.writeI32(this.north);
    output.writeFieldEnd();
  }
  if (this.east !== null && this.east !== undefined) {
    output.writeFieldBegin('east', Thrift.Type.I32, 2);
    output.writeI32(this.east);
    output.writeFieldEnd();
  }
  if (this.south !== null && this.south !== undefined) {
    output.writeFieldBegin('south', Thrift.Type.I32, 3);
    output.writeI32(this.south);
    output.writeFieldEnd();
  }
  if (this.west !== null && this.west !== undefined) {
    output.writeFieldBegin('west', Thrift.Type.I32, 4);
    output.writeI32(this.west);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

AgentVsAgent.GameException = module.exports.GameException = function(args) {
  Thrift.TException.call(this, "AgentVsAgent.GameException")
  this.name = "AgentVsAgent.GameException"
  this.message = null;
  this.type = null;
  if (args) {
    if (args.message !== undefined) {
      this.message = args.message;
    }
    if (args.type !== undefined) {
      this.type = args.type;
    }
  }
};
Thrift.inherits(AgentVsAgent.GameException, Thrift.TException);
AgentVsAgent.GameException.prototype.name = 'GameException';
AgentVsAgent.GameException.prototype.read = function(input) {
  input.readStructBegin();
  while (true)
  {
    var ret = input.readFieldBegin();
    var fname = ret.fname;
    var ftype = ret.ftype;
    var fid = ret.fid;
    if (ftype == Thrift.Type.STOP) {
      break;
    }
    switch (fid)
    {
      case 1:
      if (ftype == Thrift.Type.STRING) {
        this.message = input.readString();
      } else {
        input.skip(ftype);
      }
      break;
      case 2:
      if (ftype == Thrift.Type.STRING) {
        this.type = input.readString();
      } else {
        input.skip(ftype);
      }
      break;
      default:
        input.skip(ftype);
    }
    input.readFieldEnd();
  }
  input.readStructEnd();
  return;
};

AgentVsAgent.GameException.prototype.write = function(output) {
  output.writeStructBegin('GameException');
  if (this.message !== null && this.message !== undefined) {
    output.writeFieldBegin('message', Thrift.Type.STRING, 1);
    output.writeString(this.message);
    output.writeFieldEnd();
  }
  if (this.type !== null && this.type !== undefined) {
    output.writeFieldBegin('type', Thrift.Type.STRING, 2);
    output.writeString(this.type);
    output.writeFieldEnd();
  }
  output.writeFieldStop();
  output.writeStructEnd();
  return;
};

ttypes.CURRENT_VERSION = '0.0.16';
