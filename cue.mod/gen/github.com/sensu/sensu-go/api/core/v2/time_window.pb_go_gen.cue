// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/sensu/sensu-go/api/core/v2 --exclude=HealthResponse,Claims,Version

package v2

// TimeWindowWhen defines the "when" attributes for time windows
#TimeWindowWhen: {
	// Days is a hash of days
	days: #TimeWindowDays @go(Days) @protobuf(1,bytes,opt,proto3)
}

// TimeWindowDays defines the days of a time window
#TimeWindowDays: {
	all?: [...null | #TimeWindowTimeRange] @go(All,[]*TimeWindowTimeRange) @protobuf(1,bytes,rep,proto3)
	sunday?: [...null | #TimeWindowTimeRange] @go(Sunday,[]*TimeWindowTimeRange) @protobuf(2,bytes,rep,proto3)
	monday?: [...null | #TimeWindowTimeRange] @go(Monday,[]*TimeWindowTimeRange) @protobuf(3,bytes,rep,proto3)
	tuesday?: [...null | #TimeWindowTimeRange] @go(Tuesday,[]*TimeWindowTimeRange) @protobuf(4,bytes,rep,proto3)
	wednesday?: [...null | #TimeWindowTimeRange] @go(Wednesday,[]*TimeWindowTimeRange) @protobuf(5,bytes,rep,proto3)
	thursday?: [...null | #TimeWindowTimeRange] @go(Thursday,[]*TimeWindowTimeRange) @protobuf(6,bytes,rep,proto3)
	friday?: [...null | #TimeWindowTimeRange] @go(Friday,[]*TimeWindowTimeRange) @protobuf(7,bytes,rep,proto3)
	saturday?: [...null | #TimeWindowTimeRange] @go(Saturday,[]*TimeWindowTimeRange) @protobuf(8,bytes,rep,proto3)
}

// TimeWindowTimeRange defines the time ranges of a time
#TimeWindowTimeRange: {
	// Begin is the time which the time window should begin, in the format
	// '3:00PM', which satisfies the time.Kitchen format
	begin: string @go(Begin) @protobuf(1,bytes,opt,proto3)

	// End is the time which the filter should end, in the format '3:00PM', which
	// satisfies the time.Kitchen format
	end: string @go(End) @protobuf(2,bytes,opt,proto3)
}

_#randyTimeWindow: _
