// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.31.0
// 	protoc        v3.10.0
// source: proto3/test.proto

package proto3

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type EnumTest int32

const (
	EnumTest_ENUM_TEST1 EnumTest = 0
	EnumTest_ENUM_TEST2 EnumTest = 2
	EnumTest_ENUM_TEST3 EnumTest = 3
)

// Enum value maps for EnumTest.
var (
	EnumTest_name = map[int32]string{
		0: "ENUM_TEST1",
		2: "ENUM_TEST2",
		3: "ENUM_TEST3",
	}
	EnumTest_value = map[string]int32{
		"ENUM_TEST1": 0,
		"ENUM_TEST2": 2,
		"ENUM_TEST3": 3,
	}
)

func (x EnumTest) Enum() *EnumTest {
	p := new(EnumTest)
	*p = x
	return p
}

func (x EnumTest) String() string {
	return protoimpl.X.EnumStringOf(x.Descriptor(), protoreflect.EnumNumber(x))
}

func (EnumTest) Descriptor() protoreflect.EnumDescriptor {
	return file_proto3_test_proto_enumTypes[0].Descriptor()
}

func (EnumTest) Type() protoreflect.EnumType {
	return &file_proto3_test_proto_enumTypes[0]
}

func (x EnumTest) Number() protoreflect.EnumNumber {
	return protoreflect.EnumNumber(x)
}

// Deprecated: Use EnumTest.Descriptor instead.
func (EnumTest) EnumDescriptor() ([]byte, []int) {
	return file_proto3_test_proto_rawDescGZIP(), []int{0}
}

type MsgBase struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	MsgField1    int32                      `protobuf:"varint,1,opt,name=msg_field1,json=msgField1,proto3" json:"msg_field1,omitempty"`
	Field2       []int64                    `protobuf:"varint,2,rep,packed,name=field2,proto3" json:"field2,omitempty"`
	MsgField2    string                     `protobuf:"bytes,3,opt,name=msg_field2,json=msgField2,proto3" json:"msg_field2,omitempty"`
	BField3      bool                       `protobuf:"varint,4,opt,name=b_field3,json=bField3,proto3" json:"b_field3,omitempty"`
	FField4      float32                    `protobuf:"fixed32,5,opt,name=f_field4,json=fField4,proto3" json:"f_field4,omitempty"`
	MapField5    map[int32]string           `protobuf:"bytes,6,rep,name=map_field5,json=mapField5,proto3" json:"map_field5,omitempty" protobuf_key:"varint,1,opt,name=key,proto3" protobuf_val:"bytes,2,opt,name=value,proto3"`
	EnumField6   EnumTest                   `protobuf:"varint,7,opt,name=enum_field6,json=enumField6,proto3,enum=test.EnumTest" json:"enum_field6,omitempty"`
	SubMsg       *MsgBase_SubMsg            `protobuf:"bytes,8,opt,name=sub_msg,json=subMsg,proto3" json:"sub_msg,omitempty"`
	CommonMsg    *CommonMessage             `protobuf:"bytes,9,opt,name=common_msg,json=commonMsg,proto3" json:"common_msg,omitempty"`
	CommonEnum   CommonEnum                 `protobuf:"varint,10,opt,name=common_enum,json=commonEnum,proto3,enum=common.CommonEnum" json:"common_enum,omitempty"`
	FixedField32 uint32                     `protobuf:"fixed32,11,opt,name=fixed_field32,json=fixedField32,proto3" json:"fixed_field32,omitempty"`
	FixedField64 uint64                     `protobuf:"fixed64,12,opt,name=fixed_field64,json=fixedField64,proto3" json:"fixed_field64,omitempty"`
	DoubleField  float64                    `protobuf:"fixed64,13,opt,name=double_field,json=doubleField,proto3" json:"double_field,omitempty"`
	MapFieldSub  map[string]*MsgBase_SubMsg `protobuf:"bytes,14,rep,name=map_field_sub,json=mapFieldSub,proto3" json:"map_field_sub,omitempty" protobuf_key:"bytes,1,opt,name=key,proto3" protobuf_val:"bytes,2,opt,name=value,proto3"`
}

func (x *MsgBase) Reset() {
	*x = MsgBase{}
	if protoimpl.UnsafeEnabled {
		mi := &file_proto3_test_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *MsgBase) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*MsgBase) ProtoMessage() {}

func (x *MsgBase) ProtoReflect() protoreflect.Message {
	mi := &file_proto3_test_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use MsgBase.ProtoReflect.Descriptor instead.
func (*MsgBase) Descriptor() ([]byte, []int) {
	return file_proto3_test_proto_rawDescGZIP(), []int{0}
}

func (x *MsgBase) GetMsgField1() int32 {
	if x != nil {
		return x.MsgField1
	}
	return 0
}

func (x *MsgBase) GetField2() []int64 {
	if x != nil {
		return x.Field2
	}
	return nil
}

func (x *MsgBase) GetMsgField2() string {
	if x != nil {
		return x.MsgField2
	}
	return ""
}

func (x *MsgBase) GetBField3() bool {
	if x != nil {
		return x.BField3
	}
	return false
}

func (x *MsgBase) GetFField4() float32 {
	if x != nil {
		return x.FField4
	}
	return 0
}

func (x *MsgBase) GetMapField5() map[int32]string {
	if x != nil {
		return x.MapField5
	}
	return nil
}

func (x *MsgBase) GetEnumField6() EnumTest {
	if x != nil {
		return x.EnumField6
	}
	return EnumTest_ENUM_TEST1
}

func (x *MsgBase) GetSubMsg() *MsgBase_SubMsg {
	if x != nil {
		return x.SubMsg
	}
	return nil
}

func (x *MsgBase) GetCommonMsg() *CommonMessage {
	if x != nil {
		return x.CommonMsg
	}
	return nil
}

func (x *MsgBase) GetCommonEnum() CommonEnum {
	if x != nil {
		return x.CommonEnum
	}
	return CommonEnum_COMMON_ENUM_ZERO
}

func (x *MsgBase) GetFixedField32() uint32 {
	if x != nil {
		return x.FixedField32
	}
	return 0
}

func (x *MsgBase) GetFixedField64() uint64 {
	if x != nil {
		return x.FixedField64
	}
	return 0
}

func (x *MsgBase) GetDoubleField() float64 {
	if x != nil {
		return x.DoubleField
	}
	return 0
}

func (x *MsgBase) GetMapFieldSub() map[string]*MsgBase_SubMsg {
	if x != nil {
		return x.MapFieldSub
	}
	return nil
}

type MsgTest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	CommonMsg   *CommonMessage `protobuf:"bytes,1,opt,name=common_msg,json=commonMsg,proto3" json:"common_msg,omitempty"`
	CommonEnums []CommonEnum   `protobuf:"varint,2,rep,packed,name=common_enums,json=commonEnums,proto3,enum=common.CommonEnum" json:"common_enums,omitempty"`
}

func (x *MsgTest) Reset() {
	*x = MsgTest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_proto3_test_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *MsgTest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*MsgTest) ProtoMessage() {}

func (x *MsgTest) ProtoReflect() protoreflect.Message {
	mi := &file_proto3_test_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use MsgTest.ProtoReflect.Descriptor instead.
func (*MsgTest) Descriptor() ([]byte, []int) {
	return file_proto3_test_proto_rawDescGZIP(), []int{1}
}

func (x *MsgTest) GetCommonMsg() *CommonMessage {
	if x != nil {
		return x.CommonMsg
	}
	return nil
}

func (x *MsgTest) GetCommonEnums() []CommonEnum {
	if x != nil {
		return x.CommonEnums
	}
	return nil
}

type MsgBase_SubMsg struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	SubField1 int32  `protobuf:"varint,1,opt,name=sub_field1,json=subField1,proto3" json:"sub_field1,omitempty"`
	SubField2 string `protobuf:"bytes,2,opt,name=sub_field2,json=subField2,proto3" json:"sub_field2,omitempty"`
}

func (x *MsgBase_SubMsg) Reset() {
	*x = MsgBase_SubMsg{}
	if protoimpl.UnsafeEnabled {
		mi := &file_proto3_test_proto_msgTypes[2]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *MsgBase_SubMsg) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*MsgBase_SubMsg) ProtoMessage() {}

func (x *MsgBase_SubMsg) ProtoReflect() protoreflect.Message {
	mi := &file_proto3_test_proto_msgTypes[2]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use MsgBase_SubMsg.ProtoReflect.Descriptor instead.
func (*MsgBase_SubMsg) Descriptor() ([]byte, []int) {
	return file_proto3_test_proto_rawDescGZIP(), []int{0, 0}
}

func (x *MsgBase_SubMsg) GetSubField1() int32 {
	if x != nil {
		return x.SubField1
	}
	return 0
}

func (x *MsgBase_SubMsg) GetSubField2() string {
	if x != nil {
		return x.SubField2
	}
	return ""
}

var File_proto3_test_proto protoreflect.FileDescriptor

var file_proto3_test_proto_rawDesc = []byte{
	0x0a, 0x11, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33, 0x2f, 0x74, 0x65, 0x73, 0x74, 0x2e, 0x70, 0x72,
	0x6f, 0x74, 0x6f, 0x12, 0x04, 0x74, 0x65, 0x73, 0x74, 0x1a, 0x13, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x33, 0x2f, 0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x22, 0xaa,
	0x06, 0x0a, 0x07, 0x4d, 0x73, 0x67, 0x42, 0x61, 0x73, 0x65, 0x12, 0x1d, 0x0a, 0x0a, 0x6d, 0x73,
	0x67, 0x5f, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x31, 0x18, 0x01, 0x20, 0x01, 0x28, 0x05, 0x52, 0x09,
	0x6d, 0x73, 0x67, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x31, 0x12, 0x16, 0x0a, 0x06, 0x66, 0x69, 0x65,
	0x6c, 0x64, 0x32, 0x18, 0x02, 0x20, 0x03, 0x28, 0x03, 0x52, 0x06, 0x66, 0x69, 0x65, 0x6c, 0x64,
	0x32, 0x12, 0x1d, 0x0a, 0x0a, 0x6d, 0x73, 0x67, 0x5f, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x32, 0x18,
	0x03, 0x20, 0x01, 0x28, 0x09, 0x52, 0x09, 0x6d, 0x73, 0x67, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x32,
	0x12, 0x19, 0x0a, 0x08, 0x62, 0x5f, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x33, 0x18, 0x04, 0x20, 0x01,
	0x28, 0x08, 0x52, 0x07, 0x62, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x33, 0x12, 0x19, 0x0a, 0x08, 0x66,
	0x5f, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x34, 0x18, 0x05, 0x20, 0x01, 0x28, 0x02, 0x52, 0x07, 0x66,
	0x46, 0x69, 0x65, 0x6c, 0x64, 0x34, 0x12, 0x3b, 0x0a, 0x0a, 0x6d, 0x61, 0x70, 0x5f, 0x66, 0x69,
	0x65, 0x6c, 0x64, 0x35, 0x18, 0x06, 0x20, 0x03, 0x28, 0x0b, 0x32, 0x1c, 0x2e, 0x74, 0x65, 0x73,
	0x74, 0x2e, 0x4d, 0x73, 0x67, 0x42, 0x61, 0x73, 0x65, 0x2e, 0x4d, 0x61, 0x70, 0x46, 0x69, 0x65,
	0x6c, 0x64, 0x35, 0x45, 0x6e, 0x74, 0x72, 0x79, 0x52, 0x09, 0x6d, 0x61, 0x70, 0x46, 0x69, 0x65,
	0x6c, 0x64, 0x35, 0x12, 0x2f, 0x0a, 0x0b, 0x65, 0x6e, 0x75, 0x6d, 0x5f, 0x66, 0x69, 0x65, 0x6c,
	0x64, 0x36, 0x18, 0x07, 0x20, 0x01, 0x28, 0x0e, 0x32, 0x0e, 0x2e, 0x74, 0x65, 0x73, 0x74, 0x2e,
	0x45, 0x6e, 0x75, 0x6d, 0x54, 0x65, 0x73, 0x74, 0x52, 0x0a, 0x65, 0x6e, 0x75, 0x6d, 0x46, 0x69,
	0x65, 0x6c, 0x64, 0x36, 0x12, 0x2d, 0x0a, 0x07, 0x73, 0x75, 0x62, 0x5f, 0x6d, 0x73, 0x67, 0x18,
	0x08, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x14, 0x2e, 0x74, 0x65, 0x73, 0x74, 0x2e, 0x4d, 0x73, 0x67,
	0x42, 0x61, 0x73, 0x65, 0x2e, 0x53, 0x75, 0x62, 0x4d, 0x73, 0x67, 0x52, 0x06, 0x73, 0x75, 0x62,
	0x4d, 0x73, 0x67, 0x12, 0x34, 0x0a, 0x0a, 0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x5f, 0x6d, 0x73,
	0x67, 0x18, 0x09, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x15, 0x2e, 0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e,
	0x2e, 0x43, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x4d, 0x65, 0x73, 0x73, 0x61, 0x67, 0x65, 0x52, 0x09,
	0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x4d, 0x73, 0x67, 0x12, 0x33, 0x0a, 0x0b, 0x63, 0x6f, 0x6d,
	0x6d, 0x6f, 0x6e, 0x5f, 0x65, 0x6e, 0x75, 0x6d, 0x18, 0x0a, 0x20, 0x01, 0x28, 0x0e, 0x32, 0x12,
	0x2e, 0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x2e, 0x43, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x45, 0x6e,
	0x75, 0x6d, 0x52, 0x0a, 0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x45, 0x6e, 0x75, 0x6d, 0x12, 0x23,
	0x0a, 0x0d, 0x66, 0x69, 0x78, 0x65, 0x64, 0x5f, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x33, 0x32, 0x18,
	0x0b, 0x20, 0x01, 0x28, 0x07, 0x52, 0x0c, 0x66, 0x69, 0x78, 0x65, 0x64, 0x46, 0x69, 0x65, 0x6c,
	0x64, 0x33, 0x32, 0x12, 0x23, 0x0a, 0x0d, 0x66, 0x69, 0x78, 0x65, 0x64, 0x5f, 0x66, 0x69, 0x65,
	0x6c, 0x64, 0x36, 0x34, 0x18, 0x0c, 0x20, 0x01, 0x28, 0x06, 0x52, 0x0c, 0x66, 0x69, 0x78, 0x65,
	0x64, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x36, 0x34, 0x12, 0x21, 0x0a, 0x0c, 0x64, 0x6f, 0x75, 0x62,
	0x6c, 0x65, 0x5f, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x18, 0x0d, 0x20, 0x01, 0x28, 0x01, 0x52, 0x0b,
	0x64, 0x6f, 0x75, 0x62, 0x6c, 0x65, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x12, 0x42, 0x0a, 0x0d, 0x6d,
	0x61, 0x70, 0x5f, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x5f, 0x73, 0x75, 0x62, 0x18, 0x0e, 0x20, 0x03,
	0x28, 0x0b, 0x32, 0x1e, 0x2e, 0x74, 0x65, 0x73, 0x74, 0x2e, 0x4d, 0x73, 0x67, 0x42, 0x61, 0x73,
	0x65, 0x2e, 0x4d, 0x61, 0x70, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x53, 0x75, 0x62, 0x45, 0x6e, 0x74,
	0x72, 0x79, 0x52, 0x0b, 0x6d, 0x61, 0x70, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x53, 0x75, 0x62, 0x1a,
	0x46, 0x0a, 0x06, 0x53, 0x75, 0x62, 0x4d, 0x73, 0x67, 0x12, 0x1d, 0x0a, 0x0a, 0x73, 0x75, 0x62,
	0x5f, 0x66, 0x69, 0x65, 0x6c, 0x64, 0x31, 0x18, 0x01, 0x20, 0x01, 0x28, 0x05, 0x52, 0x09, 0x73,
	0x75, 0x62, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x31, 0x12, 0x1d, 0x0a, 0x0a, 0x73, 0x75, 0x62, 0x5f,
	0x66, 0x69, 0x65, 0x6c, 0x64, 0x32, 0x18, 0x02, 0x20, 0x01, 0x28, 0x09, 0x52, 0x09, 0x73, 0x75,
	0x62, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x32, 0x1a, 0x3c, 0x0a, 0x0e, 0x4d, 0x61, 0x70, 0x46, 0x69,
	0x65, 0x6c, 0x64, 0x35, 0x45, 0x6e, 0x74, 0x72, 0x79, 0x12, 0x10, 0x0a, 0x03, 0x6b, 0x65, 0x79,
	0x18, 0x01, 0x20, 0x01, 0x28, 0x05, 0x52, 0x03, 0x6b, 0x65, 0x79, 0x12, 0x14, 0x0a, 0x05, 0x76,
	0x61, 0x6c, 0x75, 0x65, 0x18, 0x02, 0x20, 0x01, 0x28, 0x09, 0x52, 0x05, 0x76, 0x61, 0x6c, 0x75,
	0x65, 0x3a, 0x02, 0x38, 0x01, 0x1a, 0x54, 0x0a, 0x10, 0x4d, 0x61, 0x70, 0x46, 0x69, 0x65, 0x6c,
	0x64, 0x53, 0x75, 0x62, 0x45, 0x6e, 0x74, 0x72, 0x79, 0x12, 0x10, 0x0a, 0x03, 0x6b, 0x65, 0x79,
	0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x03, 0x6b, 0x65, 0x79, 0x12, 0x2a, 0x0a, 0x05, 0x76,
	0x61, 0x6c, 0x75, 0x65, 0x18, 0x02, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x14, 0x2e, 0x74, 0x65, 0x73,
	0x74, 0x2e, 0x4d, 0x73, 0x67, 0x42, 0x61, 0x73, 0x65, 0x2e, 0x53, 0x75, 0x62, 0x4d, 0x73, 0x67,
	0x52, 0x05, 0x76, 0x61, 0x6c, 0x75, 0x65, 0x3a, 0x02, 0x38, 0x01, 0x22, 0x76, 0x0a, 0x07, 0x4d,
	0x73, 0x67, 0x54, 0x65, 0x73, 0x74, 0x12, 0x34, 0x0a, 0x0a, 0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e,
	0x5f, 0x6d, 0x73, 0x67, 0x18, 0x01, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x15, 0x2e, 0x63, 0x6f, 0x6d,
	0x6d, 0x6f, 0x6e, 0x2e, 0x43, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x4d, 0x65, 0x73, 0x73, 0x61, 0x67,
	0x65, 0x52, 0x09, 0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x4d, 0x73, 0x67, 0x12, 0x35, 0x0a, 0x0c,
	0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x5f, 0x65, 0x6e, 0x75, 0x6d, 0x73, 0x18, 0x02, 0x20, 0x03,
	0x28, 0x0e, 0x32, 0x12, 0x2e, 0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x2e, 0x43, 0x6f, 0x6d, 0x6d,
	0x6f, 0x6e, 0x45, 0x6e, 0x75, 0x6d, 0x52, 0x0b, 0x63, 0x6f, 0x6d, 0x6d, 0x6f, 0x6e, 0x45, 0x6e,
	0x75, 0x6d, 0x73, 0x2a, 0x3a, 0x0a, 0x08, 0x45, 0x6e, 0x75, 0x6d, 0x54, 0x65, 0x73, 0x74, 0x12,
	0x0e, 0x0a, 0x0a, 0x45, 0x4e, 0x55, 0x4d, 0x5f, 0x54, 0x45, 0x53, 0x54, 0x31, 0x10, 0x00, 0x12,
	0x0e, 0x0a, 0x0a, 0x45, 0x4e, 0x55, 0x4d, 0x5f, 0x54, 0x45, 0x53, 0x54, 0x32, 0x10, 0x02, 0x12,
	0x0e, 0x0a, 0x0a, 0x45, 0x4e, 0x55, 0x4d, 0x5f, 0x54, 0x45, 0x53, 0x54, 0x33, 0x10, 0x03, 0x42,
	0x15, 0x5a, 0x13, 0x62, 0x61, 0x63, 0x6b, 0x65, 0x6e, 0x64, 0x5f, 0x68, 0x74, 0x74, 0x70, 0x2f,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33,
}

var (
	file_proto3_test_proto_rawDescOnce sync.Once
	file_proto3_test_proto_rawDescData = file_proto3_test_proto_rawDesc
)

func file_proto3_test_proto_rawDescGZIP() []byte {
	file_proto3_test_proto_rawDescOnce.Do(func() {
		file_proto3_test_proto_rawDescData = protoimpl.X.CompressGZIP(file_proto3_test_proto_rawDescData)
	})
	return file_proto3_test_proto_rawDescData
}

var file_proto3_test_proto_enumTypes = make([]protoimpl.EnumInfo, 1)
var file_proto3_test_proto_msgTypes = make([]protoimpl.MessageInfo, 5)
var file_proto3_test_proto_goTypes = []interface{}{
	(EnumTest)(0),          // 0: test.EnumTest
	(*MsgBase)(nil),        // 1: test.MsgBase
	(*MsgTest)(nil),        // 2: test.MsgTest
	(*MsgBase_SubMsg)(nil), // 3: test.MsgBase.SubMsg
	nil,                    // 4: test.MsgBase.MapField5Entry
	nil,                    // 5: test.MsgBase.MapFieldSubEntry
	(*CommonMessage)(nil),  // 6: common.CommonMessage
	(CommonEnum)(0),        // 7: common.CommonEnum
}
var file_proto3_test_proto_depIdxs = []int32{
	4, // 0: test.MsgBase.map_field5:type_name -> test.MsgBase.MapField5Entry
	0, // 1: test.MsgBase.enum_field6:type_name -> test.EnumTest
	3, // 2: test.MsgBase.sub_msg:type_name -> test.MsgBase.SubMsg
	6, // 3: test.MsgBase.common_msg:type_name -> common.CommonMessage
	7, // 4: test.MsgBase.common_enum:type_name -> common.CommonEnum
	5, // 5: test.MsgBase.map_field_sub:type_name -> test.MsgBase.MapFieldSubEntry
	6, // 6: test.MsgTest.common_msg:type_name -> common.CommonMessage
	7, // 7: test.MsgTest.common_enums:type_name -> common.CommonEnum
	3, // 8: test.MsgBase.MapFieldSubEntry.value:type_name -> test.MsgBase.SubMsg
	9, // [9:9] is the sub-list for method output_type
	9, // [9:9] is the sub-list for method input_type
	9, // [9:9] is the sub-list for extension type_name
	9, // [9:9] is the sub-list for extension extendee
	0, // [0:9] is the sub-list for field type_name
}

func init() { file_proto3_test_proto_init() }
func file_proto3_test_proto_init() {
	if File_proto3_test_proto != nil {
		return
	}
	file_proto3_common_proto_init()
	if !protoimpl.UnsafeEnabled {
		file_proto3_test_proto_msgTypes[0].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*MsgBase); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_proto3_test_proto_msgTypes[1].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*MsgTest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_proto3_test_proto_msgTypes[2].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*MsgBase_SubMsg); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_proto3_test_proto_rawDesc,
			NumEnums:      1,
			NumMessages:   5,
			NumExtensions: 0,
			NumServices:   0,
		},
		GoTypes:           file_proto3_test_proto_goTypes,
		DependencyIndexes: file_proto3_test_proto_depIdxs,
		EnumInfos:         file_proto3_test_proto_enumTypes,
		MessageInfos:      file_proto3_test_proto_msgTypes,
	}.Build()
	File_proto3_test_proto = out.File
	file_proto3_test_proto_rawDesc = nil
	file_proto3_test_proto_goTypes = nil
	file_proto3_test_proto_depIdxs = nil
}
