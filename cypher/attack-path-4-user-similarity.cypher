//Attack Path 4 - User Similarity
// Clean up any existing projection
CALL gds.graph.drop("user-similarity", false) YIELD graphName
WITH count(*) AS cnt

// Create/Update our Cypher Projection
CALL gds.graph.project.cypher(
  "user-similarity",
  "MATCH (n) WHERE n:User OR n:Computer RETURN id(n) AS id, labels(n) AS labels",
  "CALL {
            MATCH (u:User)-[:MemberOf*1..]->(:Group)-[:CanRDP]->(c:Computer)
            RETURN u, c
            UNION
            MATCH (u:User)-[:CanRDP]->(c:Computer)
            RETURN u, c
   }
   RETURN id(u) AS source, id(c) AS target, 'CanRDP' AS type")
YIELD graphName
WITH graphName

// Compute similarity between Users
CALL gds.nodeSimilarity.stream(graphName, { similarityCutoff: 0.3 })
YIELD node1, node2, similarity
WITH gds.util.asNode(node1).name AS user,
     gds.util.asNode(node2).name AS other,
     similarity
WITH user, {score: similarity, name: other} AS result
WITH user, collect(result) AS results
RETURN user, results
ORDER BY size(results) DESC
