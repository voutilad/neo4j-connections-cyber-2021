// Attack Path 3 - Write  Scores
CALL gds.betweenness.write({
    nodeQuery: "MATCH (a)-[:ATTACK_PATH]-() RETURN DISTINCT id(a) AS id",
    relationshipQuery: "MATCH (a)-[:ATTACK_PATH]->(b) RETURN id(a) AS source, id(b) AS target",
    writeProperty: "betweennessScore"
})