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
