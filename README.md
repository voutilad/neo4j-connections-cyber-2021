# Neo4j Connections: Graphs for Cybersecurity

Demo as [presented](https://youtu.be/2O2JfqeHJR4) on 31 Mar, 2021.

![bloom animation](./bloom.gif?raw=true)

## Background

This demo is based on the data and themes from the BloodHound[1] project. I
recommend looking into BloodHound or reading the very comprehensive handbook[2]
on it to learn more about Active Directory attack paths and auditing
techniques.

In this demo, the BloodHound Tools project was used to populate a fictitious
Active Directory graph in Neo4j.

## Prerequisites

Install the following:

- Neo4j 4.4.x
- Neo4j Graph Data Science Library 1.8
- Neo4j Bloom 2.0 
- APOC (for Neo4j v4.4)

### Neo4j Memory Settings

For the neo4j instance, you can use the same `neo4j.conf` memory settings I
used. They might be overkill, but are safe:

```properties
dbms.memory.heap.initial_size=1G
dbms.memory.heap.max_size=2G
dbms.memory.pagecache.size=256m
```

## Populating the Graph

Follow the README.md in the `DBCreator` directory. In effect, it's as simple as
running:

```bash
$ pip install -r requirements.txt
$ python DBCreator.py
```

Use the `dbconfig` command to set up your connection url, username, and the
password to the database.

Then run `clear_and_generate` to wipe and populate the database.

> NOTE: it will default to the neo4j database until I (or someone else) update
> the DBCreator.py to support specifying alternative database names!


## The GDS Cypher

I've provided the GDS cypher queries in [./cypher](./cypher). However, the one
you should keep handy is the one to "reset" or initialize the system for giving
the demo:

```cypher
// Attack Path - Prep
// Drop graphs
CALL gds.graph.list() YIELD graphName
CALL gds.graph.drop(graphName) YIELD graphName AS dropped
RETURN count(*);

// Drop attack paths
MATCH ()-[r:ATTACK_PATH]->() DELETE r;

// Rebuild projection
CALL gds.graph.create.cypher("attackPaths", 
    "MATCH (n) RETURN id(n) AS id",
    "MATCH (a)-[r]->(b) WHERE type(r) <> 'PATH' AND type(r) <> 'RAW_PATH' " +
    "  AND type(r) <> 'PATH_0' RETURN id(a) AS source, id(b) AS target"
);
```

## Installing the Bloom Perspectives

The provided Bloom perspectives (in [./bloom](./bloom)) can be imported[4]
very easily. Make sure to import them both.

They contain all the cypher statements used by Bloom, so unless you want to
try the GDS queries, you're good to explore the graph!

> Make sure that you run the initialization cypher mentioned in the previous
> section first!

Keep in mind that if you generate your own data, you may need to tweak the
user accounts used for the queries.

## Presentation Materials

Slides are available [here](./Cybersecurity_Connections-2021.pdf).

You can also skip some steps and load this [dump file](./ad-auditing.dump).

More of a video person? The [recording](https://youtu.be/2O2JfqeHJR4) is
available on YouTube.

## Footnotes
> Github typically doesn't render these well.

[1] https://github.com/BloodHoundAD/BloodHound

[2] https://ernw.de/download/BloodHoundWorkshop/ERNW_DogWhispererHandbook.pdf

[3] https://github.com/voutilad/BloodHound-Tools/tree/update-to-neo4j4

[4] https://neo4j.com/docs/bloom-user-guide/current/bloom-perspectives/
