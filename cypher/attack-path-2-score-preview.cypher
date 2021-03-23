// Attack Path 2 - Score Preview
CALL gds.betweenness.stream({
    nodeQuery: "MATCH (a)-[:ATTACK_PATH]-() RETURN DISTINCT id(a) AS id",
    relationshipQuery: "MATCH (a)-[:ATTACK_PATH]->(b) RETURN id(a) AS source, id(b) AS target"
}) YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS n, score

RETURN n.name, head(labels(n)), score order by score desc limit 100