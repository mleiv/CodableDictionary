# CodableDictionary

CodableDictionary is a wrapper object that allows encoding/decoding dictionaries with varying types and unknown keys, using the new Swift Codable protocol. 

This is something Codable is currently missing versus the older JSONSerialization.

I've included a playground example.

CodableDictionary is currently limited to Date, UUID, Int, Float, Bool, String, and recursive CodableDictionary. Additonally, Bool must be true/false not 1/0.

Obviously this could all be improved, but I just needed something to process my existing data, until Apple works this all out.