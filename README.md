# CodableDictionary

CodableDictionary is a wrapper object that allows encoding/decoding dictionaries with varying types and unknown keys, using the new Swift Codable protocol. 

This is something Codable is currently missing versus the older JSONSerialization.

I've included a playground example.

CodableDictionary is currently limited to Date, UUID, Int, Float, Bool, and String. I've left it immutable for now, because UUID and Date have no ExpressibleLiteral type, so those two would require some jumping through some hoops in order to permit subscript mutations.

Obviously this could all be improved, but I just needed something to process my existing data, until Apple works this all out.