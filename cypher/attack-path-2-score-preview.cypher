// Attack Path 2 - Score Preview
// Clean up any existing projection
CALL gds.graph.drop("attack-paths", false) YIELD graphName
WITH count(*) AS cnt

// Create/Update our Cypher Projection
CALL gds.graph.project.cypher(
     "attack-paths",
     "MATCH (a)-[:ATTACK_PATH]-() RETURN DISTINCT id(a) AS id",
     "MATCH (a)-[:ATTACK_PATH]->(b) RETURN id(a) AS source, id(b) AS target"
) YIELD graphName
WITH graphName

// Calculate a Betweenness Centrality score for each node in our attack paths
CALL gds.betweenness.stream(graphName) YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS n, score
RETURN n.name, head(labels(n)), score
ORDER BY score DESC LIMIT 200
