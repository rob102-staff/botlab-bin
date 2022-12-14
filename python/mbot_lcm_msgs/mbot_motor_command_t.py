"""LCM type definitions
This file automatically generated by lcm.
DO NOT MODIFY BY HAND!!!!
"""

try:
    import cStringIO.StringIO as BytesIO
except ImportError:
    from io import BytesIO
import struct

class mbot_motor_command_t(object):
    __slots__ = ["utime", "trans_v", "angular_v"]

    __typenames__ = ["int64_t", "float", "float"]

    __dimensions__ = [None, None, None]

    def __init__(self):
        self.utime = 0
        self.trans_v = 0.0
        self.angular_v = 0.0

    def encode(self):
        buf = BytesIO()
        buf.write(mbot_motor_command_t._get_packed_fingerprint())
        self._encode_one(buf)
        return buf.getvalue()

    def _encode_one(self, buf):
        buf.write(struct.pack(">qff", self.utime, self.trans_v, self.angular_v))

    def decode(data):
        if hasattr(data, 'read'):
            buf = data
        else:
            buf = BytesIO(data)
        if buf.read(8) != mbot_motor_command_t._get_packed_fingerprint():
            raise ValueError("Decode error")
        return mbot_motor_command_t._decode_one(buf)
    decode = staticmethod(decode)

    def _decode_one(buf):
        self = mbot_motor_command_t()
        self.utime, self.trans_v, self.angular_v = struct.unpack(">qff", buf.read(16))
        return self
    _decode_one = staticmethod(_decode_one)

    def _get_hash_recursive(parents):
        if mbot_motor_command_t in parents: return 0
        tmphash = (0xf40b9c36f86202d1) & 0xffffffffffffffff
        tmphash  = (((tmphash<<1)&0xffffffffffffffff) + (tmphash>>63)) & 0xffffffffffffffff
        return tmphash
    _get_hash_recursive = staticmethod(_get_hash_recursive)
    _packed_fingerprint = None

    def _get_packed_fingerprint():
        if mbot_motor_command_t._packed_fingerprint is None:
            mbot_motor_command_t._packed_fingerprint = struct.pack(">Q", mbot_motor_command_t._get_hash_recursive([]))
        return mbot_motor_command_t._packed_fingerprint
    _get_packed_fingerprint = staticmethod(_get_packed_fingerprint)

    def get_hash(self):
        """Get the LCM hash of the struct"""
        return struct.unpack(">Q", mbot_motor_command_t._get_packed_fingerprint())[0]

