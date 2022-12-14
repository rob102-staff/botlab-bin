"""LCM type definitions
This file automatically generated by lcm.
DO NOT MODIFY BY HAND!!!!
"""

try:
    import cStringIO.StringIO as BytesIO
except ImportError:
    from io import BytesIO
import struct

class wifi_data_t(object):
    __slots__ = ["timestamp", "mac_address", "ssid", "strength"]

    __typenames__ = ["int64_t", "string", "string", "float"]

    __dimensions__ = [None, None, None, None]

    def __init__(self):
        self.timestamp = 0
        self.mac_address = ""
        self.ssid = ""
        self.strength = 0.0

    def encode(self):
        buf = BytesIO()
        buf.write(wifi_data_t._get_packed_fingerprint())
        self._encode_one(buf)
        return buf.getvalue()

    def _encode_one(self, buf):
        buf.write(struct.pack(">q", self.timestamp))
        __mac_address_encoded = self.mac_address.encode('utf-8')
        buf.write(struct.pack('>I', len(__mac_address_encoded)+1))
        buf.write(__mac_address_encoded)
        buf.write(b"\0")
        __ssid_encoded = self.ssid.encode('utf-8')
        buf.write(struct.pack('>I', len(__ssid_encoded)+1))
        buf.write(__ssid_encoded)
        buf.write(b"\0")
        buf.write(struct.pack(">f", self.strength))

    def decode(data):
        if hasattr(data, 'read'):
            buf = data
        else:
            buf = BytesIO(data)
        if buf.read(8) != wifi_data_t._get_packed_fingerprint():
            raise ValueError("Decode error")
        return wifi_data_t._decode_one(buf)
    decode = staticmethod(decode)

    def _decode_one(buf):
        self = wifi_data_t()
        self.timestamp = struct.unpack(">q", buf.read(8))[0]
        __mac_address_len = struct.unpack('>I', buf.read(4))[0]
        self.mac_address = buf.read(__mac_address_len)[:-1].decode('utf-8', 'replace')
        __ssid_len = struct.unpack('>I', buf.read(4))[0]
        self.ssid = buf.read(__ssid_len)[:-1].decode('utf-8', 'replace')
        self.strength = struct.unpack(">f", buf.read(4))[0]
        return self
    _decode_one = staticmethod(_decode_one)

    def _get_hash_recursive(parents):
        if wifi_data_t in parents: return 0
        tmphash = (0x24a240b71ffcb820) & 0xffffffffffffffff
        tmphash  = (((tmphash<<1)&0xffffffffffffffff) + (tmphash>>63)) & 0xffffffffffffffff
        return tmphash
    _get_hash_recursive = staticmethod(_get_hash_recursive)
    _packed_fingerprint = None

    def _get_packed_fingerprint():
        if wifi_data_t._packed_fingerprint is None:
            wifi_data_t._packed_fingerprint = struct.pack(">Q", wifi_data_t._get_hash_recursive([]))
        return wifi_data_t._packed_fingerprint
    _get_packed_fingerprint = staticmethod(_get_packed_fingerprint)

    def get_hash(self):
        """Get the LCM hash of the struct"""
        return struct.unpack(">Q", wifi_data_t._get_packed_fingerprint())[0]

