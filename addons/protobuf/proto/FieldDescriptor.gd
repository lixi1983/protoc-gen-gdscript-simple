extends RefCounted

# Protocol Buffer field type enumeration
enum FieldType {
	TYPE_DOUBLE = 1,        # double
	TYPE_FLOAT = 2,         # float
	TYPE_INT64 = 3,         # int64
	TYPE_UINT64 = 4,        # uint64
	TYPE_INT32 = 5,         # int32
	TYPE_FIXED64 = 6,       # fixed64
	TYPE_FIXED32 = 7,       # fixed32
	TYPE_BOOL = 8,          # bool
	TYPE_STRING = 9,        # string
	TYPE_GROUP = 10,        # group
	TYPE_MESSAGE = 11,      # message
	TYPE_BYTES = 12,        # bytes
	TYPE_UINT32 = 13,      # uint32
	TYPE_ENUM = 14,        # enum
	TYPE_SFIXED32 = 15,    # sfixed32
	TYPE_SFIXED64 = 16,    # sfixed64
	TYPE_SINT32 = 17,      # sint32
	TYPE_SINT64 = 18,      # sint64
	TYPE_MAP = 19,         # map
}

# Wire Types enumeration
enum WireType {
	WIRETYPE_VARINT = 0,           # int32, int64, uint32, uint64, sint32, sint64, bool, enum
	WIRETYPE_FIXED64 = 1,          # fixed64, sfixed64, double
	WIRETYPE_LENGTH_DELIMITED = 2,  # string, bytes, embedded messages, packed repeated fields
	WIRETYPE_START_GROUP = 3,       # groups (deprecated)
	WIRETYPE_END_GROUP = 4,         # groups (deprecated)
	WIRETYPE_FIXED32 = 5,          # fixed32, sfixed32, float
}

# Field label types
enum FieldLabel {
	LABEL_OPTIONAL = 1,  # optional
	LABEL_REQUIRED = 2,  # required (proto2 only)
	LABEL_REPEATED = 3,  # repeated
}

# Get wire type based on field type
static func get_wire_type(field_type: int) -> int:
	match field_type:
		FieldType.TYPE_INT32, FieldType.TYPE_INT64, FieldType.TYPE_UINT32, FieldType.TYPE_UINT64, FieldType.TYPE_SINT32, FieldType.TYPE_SINT64, FieldType.TYPE_BOOL, FieldType.TYPE_ENUM:
			return WireType.WIRETYPE_VARINT
		FieldType.TYPE_FIXED64, FieldType.TYPE_SFIXED64, FieldType.TYPE_DOUBLE:
			return WireType.WIRETYPE_FIXED64
		FieldType.TYPE_STRING, FieldType.TYPE_BYTES, FieldType.TYPE_MESSAGE, FieldType.TYPE_MAP:
			return WireType.WIRETYPE_LENGTH_DELIMITED
		FieldType.TYPE_FIXED32, FieldType.TYPE_SFIXED32, FieldType.TYPE_FLOAT:
			return WireType.WIRETYPE_FIXED32
		_:
			return WireType.WIRETYPE_VARINT

# Convert field type to string representation
static func field_type_to_string(field_type: int) -> String:
	match field_type:
		FieldType.TYPE_DOUBLE:
			return "TYPE_DOUBLE"
		FieldType.TYPE_FLOAT:
			return "TYPE_FLOAT"
		FieldType.TYPE_INT64:
			return "TYPE_INT64"
		FieldType.TYPE_UINT64:
			return "TYPE_UINT64"
		FieldType.TYPE_INT32:
			return "TYPE_INT32"
		FieldType.TYPE_FIXED64:
			return "TYPE_FIXED64"
		FieldType.TYPE_FIXED32:
			return "TYPE_FIXED32"
		FieldType.TYPE_BOOL:
			return "TYPE_BOOL"
		FieldType.TYPE_STRING:
			return "TYPE_STRING"
		FieldType.TYPE_GROUP:
			return "TYPE_GROUP"
		FieldType.TYPE_MESSAGE:
			return "TYPE_MESSAGE"
		FieldType.TYPE_BYTES:
			return "TYPE_BYTES"
		FieldType.TYPE_UINT32:
			return "TYPE_UINT32"
		FieldType.TYPE_ENUM:
			return "TYPE_ENUM"
		FieldType.TYPE_SFIXED32:
			return "TYPE_SFIXED32"
		FieldType.TYPE_SFIXED64:
			return "TYPE_SFIXED64"
		FieldType.TYPE_SINT32:
			return "TYPE_SINT32"
		FieldType.TYPE_SINT64:
			return "TYPE_SINT64"
		FieldType.TYPE_MAP:
			return "TYPE_MAP"
		_:
			push_error("Unknown field type: %d" % field_type)
			return "UNKNOWN"
