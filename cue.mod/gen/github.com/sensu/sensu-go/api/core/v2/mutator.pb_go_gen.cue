// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/sensu/sensu-go/api/core/v2 --exclude=HealthResponse,Claims,Version

package v2

// A Mutator is a mutator specification.
#Mutator: {
	// Metadata contains the name, namespace, labels and annotations of the
	// mutator
	metadata?: #ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt,proto3,embedded=metadata)

	// Command is the command to be executed.
	command?: string @go(Command) @protobuf(2,bytes,opt,proto3)

	// Timeout is the command execution timeout in seconds.
	timeout: uint32 @go(Timeout) @protobuf(3,varint,opt,proto3)

	// Env is a list of environment variables to use with command execution
	env_vars: [...string] @go(EnvVars,[]string) @protobuf(4,bytes,rep,json=envVars,proto3)

	// RuntimeAssets are a list of assets required to execute a mutator.
	runtime_assets: [...string] @go(RuntimeAssets,[]string) @protobuf(8,bytes,rep,json=runtimeAssets,proto3)

	// Secrets is the list of Sensu secrets to set for the mutators's
	// execution environment.
	secrets: [...null | #Secret] @go(Secrets,[]*Secret) @protobuf(9,bytes,rep,proto3)

	// Type specifies the type of the mutator. If blank or set to "pipe", the
	// mutator will execute a command with the default shell of the sensu user.
	// If set to "javascript", the eval field will be used, interpreted as ECMAScript 5
	// and run on the Otto VM. The runtime assets will be assumed to be javascript
	// assets, and the environment variables will be made available to the global
	// environment of the mutator.
	type?: string @go(Type) @protobuf(10,bytes,opt,proto3)

	// When the type of the mutator is "javascript", the eval field will be expected
	// to hold a valid ECMAScript 5 expression.
	eval?: string @go(Eval) @protobuf(11,bytes,opt,proto3)
}

#MutatorFace: _

_#randyMutator: _
