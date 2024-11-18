


We are refining the use cases we can imagine for the requirements we have within the bank.

 

The main requirements:

The DataFlows in the associated DCRs needs to be created with “overlapping” streams, 
so the ama-logs agent needs to replicate the logging streams  (sending the same logs to multiple LAWs)




- 

2  questions: for customers

- Are the LA are in same region or different regions?
- Do they need all the streams or just (syslog + containerlogv2)? 

- 

We can make the same DCR with 2 dataflow (targeting 2 different LAWs) - with a new API version

TODO for me

- 1 DCR with 1 Dataflow but 2 destinations 
- UAT in MSX
