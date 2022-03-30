// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/sensu/sensu-go/api/core/v2 --exclude=HealthResponse,Claims,Version

package v2

// A Handler is a handler specification.
#Handler: {
	// Metadata contains the name, namespace, labels and annotations of the
	// handler
	metadata?: #ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt,proto3,embedded=metadata)

	// Type is the handler type, i.e. pipe.
	type?: string @go(Type) @protobuf(2,bytes,opt,proto3)

	// Mutator is the handler event data mutator.
	mutator?: string @go(Mutator) @protobuf(3,bytes,opt,proto3)

	// Command is the command to be executed for a pipe handler.
	command?: string @go(Command) @protobuf(4,bytes,opt,proto3)

	// Timeout is the handler timeout in seconds.
	timeout: uint32 @go(Timeout) @protobuf(5,varint,opt,proto3)

	// Socket contains configuration for a TCP or UDP handler.
	socket?: null | #HandlerSocket @go(Socket,*HandlerSocket) @protobuf(6,bytes,opt,proto3)

	// Handlers is a list of handlers for a handler set.
	handlers: [...string] @go(Handlers,[]string) @protobuf(7,bytes,rep,proto3)

	// Filters is a list of filters name to evaluate before executing this
	// handler
	filters: [...string] @go(Filters,[]string) @protobuf(8,bytes,rep,proto3)

	// EnvVars is a list of environment variables to use with command execution
	env_vars: [...string] @go(EnvVars,[]string) @protobuf(9,bytes,rep,json=envVars,proto3)

	// RuntimeAssets are a list of assets required to execute a handler.
	runtime_assets: [...string] @go(RuntimeAssets,[]string) @protobuf(13,bytes,rep,json=runtimeAssets,proto3)

	// Secrets is the list of Sensu secrets to set for the handler's
	// execution environment.
	secrets: [...null | #Secret] @go(Secrets,[]*Secret) @protobuf(14,bytes,rep,proto3)
}

// HandlerSocket contains configuration for a TCP or UDP handler.
#HandlerSocket: {
	// Host is the socket peer address.
	host?: string @go(Host) @protobuf(1,bytes,opt,proto3)

	// Port is the socket peer port.
	port: uint32 @go(Port) @protobuf(2,varint,opt,proto3)
}

#HandlerFace: _

_#randyHandler: _
