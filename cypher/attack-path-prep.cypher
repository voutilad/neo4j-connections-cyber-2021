// Attack Path - Prep
// Drop graphs
CALL gds.graph.list() YIELD graphName
WITH graphName
CALL gds.graph.drop(graphName) YIELD graphName AS dropped
RETURN *;

// Drop existing materialized attack paths
MATCH ()-[r:ATTACK_PATH]->() DELETE r;

// Rebuild projection
CALL gds.graph.project.cypher("raw-paths",
    "MATCH (n) RETURN id(n) AS id",
    "MATCH (a)-[r]->(b) WHERE type(r) <> 'PATH' AND type(r) <> 'RAW_PATH' " +
    "  AND type(r) <> 'PATH_0' RETURN id(a) AS source, id(b) AS target"
);
