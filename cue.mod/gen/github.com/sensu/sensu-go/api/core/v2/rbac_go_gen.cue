// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/sensu/sensu-go/api/core/v2 --exclude=HealthResponse,Claims,Version

package v2

// ClusterRolesResource is the name of this resource type
#ClusterRolesResource: "clusterroles"

// ClusterRoleBindingsResource is the name of this resource type
#ClusterRoleBindingsResource: "clusterrolebindings"

// RolesResource is the name of this resource type
#RolesResource: "roles"

// RoleBindingsResource is the name of this resource type
#RoleBindingsResource: "rolebindings"

// ResourceAll represents all possible resources
#ResourceAll: "*"

// VerbAll represents all possible verbs
#VerbAll: "*"

// GroupType represents a group object in a subject
#GroupType: "Group"

// UserType represents a user object in a subject
#UserType: "User"

// ClusterRoleType represents a ClusterRole in a RoleRef
#ClusterRoleType: "ClusterRole"

// RoleType represents a Role in a RoleRef
#RoleType: "Role"

// LocalSelfUserResource represents a local user trying to view itself
// or change its password
#LocalSelfUserResource: "localselfuser"
