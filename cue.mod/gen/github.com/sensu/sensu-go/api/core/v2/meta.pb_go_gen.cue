// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/sensu/sensu-go/api/core/v2 --exclude=HealthResponse,Claims,Version

package v2

// ObjectMeta is metadata all persisted objects have.
#ObjectMeta: {
	// Name must be unique within a namespace. Name is primarily intended for
	// creation idempotence and configuration definition.
	name?: string @go(Name) @protobuf(1,bytes,opt,proto3)

	// Namespace defines a logical grouping of objects within which each object
	// name must be unique.
	namespace?: string @go(Namespace) @protobuf(2,bytes,opt,proto3)

	// Map of string keys and values that can be used to organize and categorize
	// (scope and select) objects. May also be used in filters and token
	// substitution.
	// TODO: Link to Sensu documentation.
	// More info: http://kubernetes.io/docs/user-guide/labels
	labels?: {[string]: string} @go(Labels,map[string]string) @protobuf(3,bytes,rep,proto3)

	// Annotations is an unstructured key value map stored with a resource that
	// may be set by external tools to store and retrieve arbitrary metadata. They
	// are not queryable and should be preserved when modifying objects.
	// TODO: Link to Sensu documentation.
	// More info: http://kubernetes.io/docs/user-guide/annotations
	annotations?: {[string]: string} @go(Annotations,map[string]string) @protobuf(4,bytes,rep,proto3)

	// CreatedBy indicates which user created the resource.
	created_by?: string @go(CreatedBy) @protobuf(5,bytes,opt,json=createdBy,proto3)
}

// TypeMeta is information that can be used to resolve a data type
#TypeMeta: {
	// Type is the type name of the data type
	type: string @go(Type) @protobuf(1,bytes,opt,name=Type,proto3)

	// APIVersion is the APIVersion of the data type
	api_version: string @go(APIVersion) @protobuf(2,bytes,opt,name=APIVersion,proto3)
}

_#randyMeta: _
