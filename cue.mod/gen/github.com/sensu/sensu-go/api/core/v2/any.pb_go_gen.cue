// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/sensu/sensu-go/api/core/v2 --exclude=HealthResponse,Claims,Version

package v2

#Any: {
	type_url?: string @go(TypeUrl) @protobuf(1,bytes,opt,json=typeUrl,proto3)
	value?:    bytes  @go(Value,[]byte) @protobuf(2,bytes,opt,proto3)
}

_#randyAny: _
